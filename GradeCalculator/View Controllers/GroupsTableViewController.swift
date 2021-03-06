//
//  GroupsTableViewController.swift
//  GradeCalculator
//
//  Created by Logan Kember on 2016-10-07.
//  Copyright © 2016 Logan Kember. All rights reserved.
//

import UIKit

class GroupsTableViewController: UITableViewController {
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("GroupsTableViewController: viewDidLoad")
        
        appDelegate.save()
        
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
//        self.navigationController?.setNavigationBarHidden(false, animated: true)
        if let loadedData = appDelegate.load() {
            appDelegate.groups = loadedData
        }
        
        tableView.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        let views = self.navigationController!.viewControllers
        
        if (views.count > 2 && views[views.count-2] == self.navigationController) {
            print("GroupsTableViewController: viewWillDisappear -> New view controller was pushed onto the stack.")
        }
        else if (!views.contains(self)) {
            print("GroupsTableViewController: viewWillDisappear -> View controller was popped from stack.")
            self.navigationController?.setNavigationBarHidden(true, animated: true)
        }
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
        if (appDelegate.groups[ungroupedIndex].courses.count == 0 && ungroupedIndex <= index) {
            index += 1
            print("Incrementing index. Now index = \(index) which points to \(appDelegate.groups[index].groupName)")
        }
        
        let alertController = UIAlertController(title: "Editing Group: \(appDelegate.groups[index].groupName)", message: "", preferredStyle: UIAlertController.Style.alert)
        
        let saveAction = UIAlertAction(title: "Save", style: UIAlertAction.Style.default, handler: {
            (action: UIAlertAction!) -> Void in
            
            let groupNameField = alertController.textFields![0].text ?? ""
            
            // Only change the name of the group if the field isn't empty and the group name doesn't exist
            if (groupNameField != "" && self.getGroupIndexWithName(nameOfGroup: groupNameField) == -1) {
                self.appDelegate.groups[index].groupName = groupNameField
                self.appDelegate.save()
                self.tableView.reloadRows(at: [indexPath], with: UITableView.RowAnimation.fade)
            }
            
            self.setEditing(false, animated: true)
            self.tableView.setEditing(false, animated: true)
        });
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: { (action: UIAlertAction!) -> Void in
            self.setEditing(false, animated: true)
            self.tableView.setEditing(false, animated: true)
        });
    
        
        alertController.addTextField(configurationHandler: {(textField: UITextField!) -> Void in
            textField.text = self.appDelegate.groups[index].groupName
        });
        
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    //This method gets the group with a specific group name
    func getGroupIndexWithName(nameOfGroup: String) -> Int {
        
        for i in 0..<appDelegate.groups.count {
            if (appDelegate.groups[i].groupName == nameOfGroup) {
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
                let ungroupedCourses = appDelegate.groups[getGroupIndexWithName(nameOfGroup: "Ungrouped Courses")]
                
                for i in 0 ..< indexPaths.count {
                    print("GroupsTable: unwindToCourseDict: Courses to move: \(ungroupedCourses.courses[indexPaths[i].row - i].courseName)")
                    coursesToMove.append(appDelegate.groups[0].courses.remove(at: (indexPaths[i].row) - i))
                }
                
                // Add the courses to the new group
                appDelegate.groups.append(Group.init(groupName: newGroup!, courses: coursesToMove))
            }
            else {
                appDelegate.groups.append(Group.init(groupName: newGroup!, courses: [Course]()))
            }
        }
        appDelegate.save()
        self.tableView.reloadData()
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("GroupsTable: numberOfRowsInSection: groups.count=\(appDelegate.groups.count) Printing groupNames:")
        for group in appDelegate.groups {
            print("\(group.groupName)")
        }
        if (appDelegate.groups[getGroupIndexWithName(nameOfGroup: "Ungrouped Courses")].courses.count == 0) {
            return appDelegate.groups.count-1
        }
        return appDelegate.groups.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "GroupCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        var tempIndex = 0
        
        if (appDelegate.groups[getGroupIndexWithName(nameOfGroup: "Ungrouped Courses")].courses.count == 0) {
            tempIndex = indexPath.row + 1
        }
        else {
            tempIndex = indexPath.row
        }
        
        let groupName = appDelegate.groups[tempIndex].groupName
        
        cell.textLabel?.text = groupName
        cell.detailTextLabel?.text = "Number of courses in group: \(appDelegate.groups[tempIndex].courses.count)"
        
        if (!tableView.isEditing) {
            cell.accessoryType = UITableViewCell.AccessoryType.disclosureIndicator
        }
        else {
            cell.accessoryType = UITableViewCell.AccessoryType.none
        }
        
        let view = UIView()
        view.backgroundColor = UIColor.init(red: 0, green: 139/255, blue: 1, alpha: 1)
        cell.selectedBackgroundView = view
        
        return cell
    }
    
    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if (tableView.isEditing) {
            tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCell.AccessoryType.none
        }
        else {
            tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCell.AccessoryType.disclosureIndicator
        }
        if (appDelegate.groups[getGroupIndexWithName(nameOfGroup: "Ungrouped Courses")].courses.count == 0) {
            return true
        }
        else {
            if appDelegate.groups[indexPath.row].groupName != "Ungrouped Courses" {
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
        let deleteRowAction = UITableViewRowAction(style: UITableViewRowAction.Style.destructive, title: "Delete", handler:{action, indexPath in
            
            let ungroupedIndex = self.getGroupIndexWithName(nameOfGroup: "Ungrouped Courses")
            var newIndex = indexPath.row
            
            if self.appDelegate.groups[ungroupedIndex].courses.count == 0 {
                print("Ungrouped courses.count = 0, ungroupedIndex = \(ungroupedIndex), indexPath.row=\(indexPath.row)")
                if (ungroupedIndex <= indexPath.row) {
                    newIndex += 1
                    print("newIndex increment \(newIndex)")
                }
            }
            
            if self.appDelegate.groups[newIndex].courses.count == 0 {
                print("GroupsTable: commit editingStyle: \(self.appDelegate.groups[newIndex].groupName).courses.count == 0")
                print("Currently looking at group \(self.appDelegate.groups[newIndex].groupName)")
                self.appDelegate.groups.remove(at: newIndex)
                print(">1")
                tableView.deleteRows(at: [indexPath], with: .fade)
                tableView.isEditing = false
            }
            else {
                print("GroupsTable: commit editingStyle: count > 0")
                print("Currently looking at group \(self.appDelegate.groups[newIndex].groupName)")
                let tempCourses = self.appDelegate.groups[newIndex].courses
                
                self.appDelegate.groups.remove(at: newIndex)
                tableView.deleteRows(at: [indexPath], with: .fade)
                
                self.appDelegate.groups[ungroupedIndex].courses += tempCourses
                
                if (newIndex != indexPath.row) {
                    tableView.insertRows(at: [IndexPath.init(row: 0, section: 0)], with: .fade)
                }
                else {
                    tableView.reloadRows(at: [IndexPath.init(row: ungroupedIndex, section: 0)], with: UITableView.RowAnimation.middle)
                }
            }
            
            self.appDelegate.save()
            print("GroupsTable: editActions -> Exit")
            
        });
        
        let editCourseTitle = UITableViewRowAction(style: UITableViewRowAction.Style.normal, title: "Edit", handler: { action, indexPath in
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
        for group in appDelegate.groups {
            print(group.groupName)
        }
        
        if appDelegate.groups[getGroupIndexWithName(nameOfGroup: "Ungrouped Courses")].courses.count == 0 {
            let ungroupedIndex = getGroupIndexWithName(nameOfGroup: "UngroupedCourses")
            var fromIndex = fromIndexPath.row
            var toIndex = to.row
            
            if (ungroupedIndex <= fromIndex) {
                fromIndex += 1
            }
            if ungroupedIndex <= toIndex {
                toIndex += 1
            }
            
            let tempGroup = appDelegate.groups[toIndex]
            appDelegate.groups[toIndex] = appDelegate.groups[fromIndex]
            appDelegate.groups[fromIndex] = tempGroup
        }
        else {
            let tempGroup = appDelegate.groups[to.row]
            appDelegate.groups[to.row] = appDelegate.groups[fromIndexPath.row]
            appDelegate.groups[fromIndexPath.row] = tempGroup
        }
        
        print("Order of groups after rearrangement")
        for group in appDelegate.groups {
            print(group.groupName)
        }
        
        appDelegate.save()
    }


    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        if (appDelegate.groups[getGroupIndexWithName(nameOfGroup: "Ungrouped Courses")].courses.count == 0) {
            return true
        }
        else {
            if appDelegate.groups[indexPath.row].groupName == "Ungrouped Courses" {
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
            let destView = segue.destination.children[0] as! AddGroupViewController
//            destView.appDelegate.groups = self.appDelegate.groups
        }
        else if (segue.identifier == "ShowGroupSegue") {
            print("GroupsTable: prepare: ShowGroupSegue has started")
//            let destView = segue.destination.childViewControllers[0] as! CourseTableViewController
            let destView = segue.destination as! CourseTableViewController
            let cell = sender as! UITableViewCell
            print("GroupsTable: prepare: Showing \(String(describing: cell.textLabel?.text))")
//            destView.appDelegate.groups = appDelegate.groups
            destView.index = getGroupIndexWithName(nameOfGroup: cell.textLabel!.text!)
            print("GroupsTable: prepare: destView index = \(destView.index)")
        }
    }
}
