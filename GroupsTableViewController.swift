//
//  GroupsTableViewController.swift
//  GradeCalculator
//
//  Created by Logan Kember on 2016-10-07.
//  Copyright © 2016 Logan Kember. All rights reserved.
//

import UIKit

class GroupsTableViewController: UITableViewController {
    
    var groups = Group()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("GroupsTableViewController: viewDidLoad")
        
        //Making sure the keys are updated
        groups.updateKeys()
        save()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
         self.navigationItem.leftBarButtonItem = self.editButtonItem
    }

    override func viewDidAppear(_ animated: Bool) {
        print("GroupsTableViewController: viewDidAppear -> Loading courses and reloading table")
        if let loadedData = load() {
            groups = loadedData
        }
        
        tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    // MARK: - Functions
    
    @IBAction func unwindToCourseDict(sender: UIStoryboardSegue) {
        print("GroupsTable: unwindToCourseDict: -> Entry")
        if let sourceVC = sender.source as? AddGroupViewController {
            print("GroupsTable: unwindToCourseDict: Source view is AddGroupView")
            let newGroup = sourceVC.groupName.text
            if let indexPaths = sourceVC.tableView.indexPathsForSelectedRows?.sorted() {
                
                var moveCourses: [Course] = []
                var ungroupedCourses = sourceVC.groups.group["Ungrouped Courses"]
                
                for i in 0 ..< indexPaths.count {
                    print("GroupsTable: unwindToCourseDict: Courses to move: \((ungroupedCourses?[(indexPaths[i].row)])!.courseName)")
                    moveCourses.append((ungroupedCourses?[(indexPaths[i].row)])!)
                    _ = groups.group["Ungrouped Courses"]?.remove(at: (indexPaths[i].row) - i)
                }
                
                if moveCourses.count == 0 {
                    groups.group[newGroup!] = []
                }
                else {
                    groups.group[newGroup!] = moveCourses
                }
                
                groups.keys.append(newGroup!)
                
                print("groups.count == \(groups.group.count)")
            }
            else {
                groups.group[newGroup!] = []
                groups.keys.append(newGroup!)
            }
        }
        save()
        self.tableView.reloadData()
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("GroupsTable: numberOfRows = \(groups.group.count)")
        return groups.group.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "GroupCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        
        let groupName = groups.keys[indexPath.row]
        
        cell.textLabel?.text = groupName
        cell.detailTextLabel?.text = "Number of courses in group: \(groups.group[groupName]!.count)"
        
        if (!tableView.isEditing) {
            cell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
        }
        else {
            cell.accessoryType = UITableViewCellAccessoryType.none
        }
        
        return cell
    }
    
    
//    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        print("GroupsTable: didSelectRowAt: -> Entry")
//        if (tableView.isEditing) {
//            print("GroupsTable: didSelectRowAt: isEditing")
//        }
//        else {
//            
//        }
//    }
    
    /*
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        
    }
    */
    
    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */
    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if (tableView.isEditing) {
            tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCellAccessoryType.none
        }
        else {
            tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
        }
        print("indexPath.row=\(indexPath.row), groups.keys.count=\(groups.keys.count)")
        if groups.keys[indexPath.row] != "Ungrouped Courses" {
            print("GroupsTable: canEditRowAt \(indexPath.row) -> True")
            return true
        }
        print("GroupsTable: canEditRowAt \(indexPath.row) -> False")
        return false
    }

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        print("GroupsTable: commit editingStyle -> Entry")
        if editingStyle == .delete {
            if groups.group[groups.keys[indexPath.row]]!.count == 0 {
                print("GroupsTable: commit editingStyle: count == 0")
                groups.group.removeValue(forKey: groups.keys[indexPath.row])
                groups.keys.remove(at: indexPath.row)
            }
            else {
                print("GroupsTable: commit editingStyle: count > 0")
                let tempCourses = groups.group[groups.keys[indexPath.row]]!
                
                for course in tempCourses {
                    print("GroupsTable: commit editingStyle: current course = \(course.courseName)")
                    groups.group["Ungrouped Courses"]!.append(course)
                }
                groups.group.removeValue(forKey: groups.keys[indexPath.row])
                groups.keys.remove(at: indexPath.row)
            }
            
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.reloadData()
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
        save()
        print("GroupsTable: commit editingStyle -> Exit")
    }

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
        
    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("GroupsTable: prepare: Entry")
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if (segue.identifier == "AddGroupSegue") {
            print("GroupsTable: prepare: AddGroupSegue has started")
            let destView = segue.destination.childViewControllers[0] as! AddGroupViewController
            destView.groups = self.groups
        }
        else if (segue.identifier == "ShowGroupSegue") {
            print("GroupsTable: prepare: ViewGroupSegue has started")
            let destView = segue.destination.childViewControllers[0] as! CourseTableViewController
            let cell = sender as! UITableViewCell
            print("GroupsTable: prepare: Showing \(cell.textLabel?.text)")
            destView.dictionaryKey = (cell.textLabel?.text)!
        }
    }
    
    
    // MARK: - NSCoding
    
    func save() {
        print("GroupsTable: save: Saving courses and groups.")
        if (!NSKeyedArchiver.archiveRootObject(self.groups, toFile: Group.ArchiveURL.path)) {
            print("GroupsTable: save: Failed to save courses and groups.")
        }
    }
    
    func load() -> Group? {
        print("GroupsTable: load: Loading courses.")
        return (NSKeyedUnarchiver.unarchiveObject(withFile: Group.ArchiveURL.path) as! Group?)
    }
}
