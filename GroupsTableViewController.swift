//
//  GroupsTableViewController.swift
//  GradeCalculator
//
//  Created by Logan Kember on 2016-10-07.
//  Copyright © 2016 Logan Kember. All rights reserved.
//

import UIKit

class GroupsTableViewController: UITableViewController {
    
    var groups: [Group] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("GroupsTableViewController: viewDidLoad")
        
        //Making sure the keys are updated
//        groups.updateKeys()
        save()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        self.navigationItem.leftBarButtonItem = self.editButtonItem
        self.navigationController?.navigationBar.barStyle = UIBarStyle.black
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

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    
    // MARK: - Functions
    
    //This method gets the group with a specific group name
    func getGroupIndexWithName(nameOfGroup: String) -> Int {
        
        for i in 0..<groups.count {
            if (groups[i].groupName == nameOfGroup) {
                return i
            }
        }
        return -1
    }
    
    // This method is run when the user is adding a new group.
    @IBAction func unwindToCourseDict(sender: UIStoryboardSegue) {
        print("GroupsTable: unwindToCourseDict: -> Entry")
        if let sourceVC = sender.source as? AddGroupViewController {
            print("GroupsTable: unwindToCourseDict: Source view is AddGroupView")
            
            let newGroup = sourceVC.groupName.text                                              //Getting the name of the new group
            if let indexPaths = sourceVC.tableView.indexPathsForSelectedRows?.sorted() {        //Getting the indexes of the courses to add to the group
                
                var coursesToMove: [Course] = []
                let ungroupedCourses = sourceVC.groups[getGroupIndexWithName(nameOfGroup: "Ungrouped Courses")]
                
                for i in 0 ..< indexPaths.count {
                    print("GroupsTable: unwindToCourseDict: Courses to move: \(ungroupedCourses.courses[indexPaths[i].row].courseName)")
                    coursesToMove.append(groups[0].courses.remove(at: (indexPaths[i].row) - i))
                }
                
                // Add the courses to the new group
                groups.append(Group.init(groupName: newGroup!, courses: coursesToMove))
            }
            else {
                groups.append(Group.init(groupName: newGroup!, courses: [Course]()))
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
        if (groups[getGroupIndexWithName(nameOfGroup: "Ungrouped Courses")].courses.count == 0) {
            return groups.count-1
        }
        return groups.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "GroupCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        var tempIndex = 0
        
        if (groups[getGroupIndexWithName(nameOfGroup: "Ungrouped Courses")].courses.count == 0) {
            tempIndex = indexPath.row + 1
        }
        else {
            tempIndex = indexPath.row
        }
        
        let groupName = groups[tempIndex].groupName
        
        cell.textLabel?.text = groupName
        cell.detailTextLabel?.text = "Number of courses in group: \(groups[tempIndex].courses.count)"
        
        if (!tableView.isEditing) {
            cell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
        }
        else {
            cell.accessoryType = UITableViewCellAccessoryType.none
        }
        
        return cell
    }
    
    
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
        
        if groups[indexPath.row].groupName != "Ungrouped Courses" {
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
            
            if groups[indexPath.row].courses.count == 0 {
                print("GroupsTable: commit editingStyle: count == 0")
                groups.remove(at: indexPath.row)
            }
            else {
                print("GroupsTable: commit editingStyle: count > 0")
                let tempCourses = groups[indexPath.row].courses
                
                groups[getGroupIndexWithName(nameOfGroup: "Ungrouped Courses")].courses += tempCourses
                
                groups.remove(at: indexPath.row)
            }
            
            // Delete the row from the data source
//            tableView.deleteRows(at: [indexPath], with: .fade)
//            tableView.insertRows(at: [IndexPath.init(item: 0, section: 0)], with: .fade)
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
        // TODO: Support rearranging of table
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
            print("GroupsTable: prepare: ShowGroupSegue has started")
            let destView = segue.destination.childViewControllers[0] as! CourseTableViewController
            let cell = sender as! UITableViewCell
            print("GroupsTable: prepare: Showing \(cell.textLabel?.text)")
//            destView.dictionaryKey = (cell.textLabel?.text)!
            destView.groups = groups
            destView.index = getGroupIndexWithName(nameOfGroup: cell.textLabel!.text!)
        }
    }
    
    
    // MARK: - NSCoding
    
    func save() {
        print("GroupsTable: save: Saving courses and groups.")
        if (!NSKeyedArchiver.archiveRootObject(self.groups, toFile: Group.ArchiveURL.path)) {
            print("GroupsTable: save: Failed to save courses and groups.")
        }
    }
    
    func load() -> [Group]? {
        print("GroupsTable: load: Loading courses.")
        return (NSKeyedUnarchiver.unarchiveObject(withFile: Group.ArchiveURL.path) as! [Group]?)
    }
}
