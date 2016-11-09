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
        
        save()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
        // Adding the edit button to the right bar buttons
        self.navigationItem.rightBarButtonItems?.append(self.editButtonItem)
        
        // Setting the nav bar style to black
        self.navigationController?.navigationBar.barStyle = UIBarStyle.black
    }

    override func viewDidAppear(_ animated: Bool) {
        print("GroupsTableViewController: viewDidAppear -> Loading courses and reloading table")
        self.navigationController?.setNavigationBarHidden(false, animated: true)
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
    
    func editCourseTitle(indexPath: IndexPath) {
        let ungroupedIndex = getGroupIndexWithName(nameOfGroup: "Ungrouped Courses")
        var index = indexPath.row
        
        print("Test: ungrouped \(ungroupedIndex), index \(index)")
        if (groups[ungroupedIndex].courses.count == 0 && ungroupedIndex <= index) {
            index += 1
            print("Incrementing index. Now index = \(index) which points to \(groups[index].groupName)")
        }
        
        let alertController = UIAlertController(title: "Editing Group: \(groups[index].groupName)", message: "", preferredStyle: UIAlertControllerStyle.alert)
        
        let saveAction = UIAlertAction(title: "Save", style: UIAlertActionStyle.default, handler: {
            (action: UIAlertAction!) -> Void in
            
            let groupNameField = alertController.textFields![0].text ?? ""
            
            // Only change the name of the group if the field isn't empty and the group name doesn't exist
            if (groupNameField != "" && self.getGroupIndexWithName(nameOfGroup: groupNameField) == -1) {
                self.groups[index].groupName = groupNameField
                self.save()
                self.tableView.reloadRows(at: [indexPath], with: UITableViewRowAnimation.fade)
            }
            
            self.setEditing(false, animated: true)
            self.tableView.setEditing(false, animated: true)
        });
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: { (action: UIAlertAction!) -> Void in
            self.setEditing(false, animated: true)
            self.tableView.setEditing(false, animated: true)
        });
    
        
        alertController.addTextField(configurationHandler: {(textField: UITextField!) -> Void in
            textField.text = self.groups[index].groupName
        });
        
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
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
                    print("GroupsTable: unwindToCourseDict: Courses to move: \(ungroupedCourses.courses[indexPaths[i].row - i].courseName)")
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
        print("GroupsTable: numberOfRowsInSection: groups.count=\(groups.count) Printing groupNames:")
        for group in groups {
            print("\(group.groupName)")
        }
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
    
    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if (tableView.isEditing) {
            tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCellAccessoryType.none
        }
        else {
            tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
        }
        if (groups[getGroupIndexWithName(nameOfGroup: "Ungrouped Courses")].courses.count == 0) {
            return true
        }
        else {
            if groups[indexPath.row].groupName != "Ungrouped Courses" {
                print("GroupsTable: canEditRowAt \(indexPath.row) -> True")
                return true
            }
        }
        print("GroupsTable: canEditRowAt \(indexPath.row) -> False")
        return false
    }

    // Making the delete and edit button when editing a cell
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        print("GroupsTable: editActionsForRowAt -> Entry: Setting edit actions")
        let deleteRowAction = UITableViewRowAction(style: UITableViewRowActionStyle.destructive, title: "Delete", handler:{action, indexPath in
            
            let ungroupedIndex = self.getGroupIndexWithName(nameOfGroup: "Ungrouped Courses")
            var newIndex = indexPath.row
            
            if self.groups[ungroupedIndex].courses.count == 0 {
                print("Ungrouped courses.count = 0, ungroupedIndex = \(ungroupedIndex), indexPath.row=\(indexPath.row)")
                if (ungroupedIndex <= indexPath.row) {
                    newIndex += 1
                    print("newIndex increment \(newIndex)")
                }
            }
            
            if self.groups[newIndex].courses.count == 0 {
                print("GroupsTable: commit editingStyle: \(self.groups[newIndex].groupName).courses.count == 0")
                print("Currently looking at group \(self.groups[newIndex].groupName)")
                self.groups.remove(at: newIndex)
                print(">1")
                tableView.deleteRows(at: [indexPath], with: .fade)
                tableView.isEditing = false
            }
            else {
                print("GroupsTable: commit editingStyle: count > 0")
                print("Currently looking at group \(self.groups[newIndex].groupName)")
                let tempCourses = self.groups[newIndex].courses
                
                self.groups.remove(at: newIndex)
                tableView.deleteRows(at: [indexPath], with: .fade)
                
                self.groups[ungroupedIndex].courses += tempCourses
                
                if (newIndex != indexPath.row) {
                    tableView.insertRows(at: [IndexPath.init(row: 0, section: 0)], with: .fade)
                }
                else {
                    tableView.reloadRows(at: [IndexPath.init(row: ungroupedIndex, section: 0)], with: UITableViewRowAnimation.middle)
                }
            }
            
            self.save()
            print("GroupsTable: editActions -> Exit")
            
        });
        
        let editCourseTitle = UITableViewRowAction(style: UITableViewRowActionStyle.normal, title: "Edit", handler: { action, indexPath in
            self.editCourseTitle(indexPath: indexPath)
        });
        
        return[deleteRowAction, editCourseTitle]
    }
    
    // This method is used so that the Ungrouped Courses cell can NOT be reordered
    override func tableView(_ tableView: UITableView, targetIndexPathForMoveFromRowAt sourceIndexPath: IndexPath, toProposedIndexPath proposedDestinationIndexPath: IndexPath) -> IndexPath {
        if (proposedDestinationIndexPath.row == 0) {
            return IndexPath(row: 1, section: 0)
        }
        return proposedDestinationIndexPath
    }
    
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
        
        print("Order of groups before rearrangement")
        for group in groups {
            print(group.groupName)
        }
        
        if groups[getGroupIndexWithName(nameOfGroup: "Ungrouped Courses")].courses.count == 0 {
            let ungroupedIndex = getGroupIndexWithName(nameOfGroup: "UngroupedCourses")
            var fromIndex = fromIndexPath.row
            var toIndex = to.row
            
            if (ungroupedIndex <= fromIndex) {
                fromIndex += 1
            }
            if ungroupedIndex <= toIndex {
                toIndex += 1
            }
            
            let tempGroup = groups[toIndex]
            groups[toIndex] = groups[fromIndex]
            groups[fromIndex] = tempGroup
        }
        else {
            let tempGroup = groups[to.row]
            groups[to.row] = groups[fromIndexPath.row]
            groups[fromIndexPath.row] = tempGroup
        }
        
        print("Order of groups after rearrangement")
        for group in groups {
            print(group.groupName)
        }
        
        save()
    }


    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        if (groups[getGroupIndexWithName(nameOfGroup: "Ungrouped Courses")].courses.count == 0) {
            return true
        }
        else {
            if groups[indexPath.row].groupName == "Ungrouped Courses" {
                return false
            }
            return true
        }
    }

    
    
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
//            let destView = segue.destination.childViewControllers[0] as! CourseTableViewController
            let destView = segue.destination as! CourseTableViewController
            let cell = sender as! UITableViewCell
            print("GroupsTable: prepare: Showing \(cell.textLabel?.text)")
            destView.groups = groups
            destView.index = getGroupIndexWithName(nameOfGroup: cell.textLabel!.text!)
            print("GroupsTable: prepare: destView groups.count=\(destView.groups.count), groups[0].courses.count=\(destView.groups[0].courses.count), destView index = \(destView.index)")
        }
    }
    
    
    // MARK: - NSCoding
    // saves the current groups
    func save() {
        print("GroupsTable: save: Saving courses and groups.")
        if (!NSKeyedArchiver.archiveRootObject(self.groups, toFile: Group.ArchiveURL.path)) {
            print("GroupsTable: save: Failed to save courses and groups.")
        }
    }
    
    // loads any saved groups
    func load() -> [Group]? {
        print("GroupsTable: load: Loading courses.")
        return (NSKeyedUnarchiver.unarchiveObject(withFile: Group.ArchiveURL.path) as! [Group]?)
    }
}
