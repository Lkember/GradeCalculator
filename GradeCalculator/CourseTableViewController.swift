//
//  CourseTableViewController.swift
//  GradeCalculator
//
//  Created by Logan Kember on 2016-07-25.
//  Copyright © 2016 Logan Kember. All rights reserved.
//

import UIKit

class CourseTableViewController: UITableViewController {

    // MARK: Properties
//    var dictionaryKey: String = ""
    var groups: [Group] = []
    var index = -1
    @IBOutlet weak var overallAverage: UILabel!
    @IBOutlet weak var numCourses: UILabel!
    @IBOutlet weak var deleteButton: UIBarButtonItem!
    @IBOutlet weak var editButton: UIBarButtonItem!
    @IBOutlet weak var addButton: UIBarButtonItem!
    @IBOutlet weak var backButton: UIButton!
    
    override func viewDidLoad() {
        print("CourseTable: viewDidLoad -> Entry")
        super.viewDidLoad()
        
        if (index != -1) {
            backButton.setTitle("Back", for: UIControlState.normal)
            print("CourseTable: viewDidLoad: Current Index = \(index)")
            self.title = groups[index].groupName
        }
        
        self.tableView.allowsMultipleSelectionDuringEditing = true
        self.tableView.allowsSelectionDuringEditing = true
        self.navigationController?.navigationBar.barStyle = UIBarStyle.black
        self.navigationController?.toolbar.barStyle = UIBarStyle.black
        
        //Add an edit button to the navigation bar
        navigationItem.leftBarButtonItem = editButtonItem
        
        // Add buttons to tool bar
        self.navigationController!.toolbar.isHidden = true
        self.deleteButton.isEnabled = false
        self.editButton.isEnabled = false
        
        // Rounding the back button
        self.backButton.layer.cornerRadius = 10
        
        print("CourseTable: viewDidLoad Loading courses")
        
        if let loadedData = load() {
            groups = loadedData
        }
        
//        if groups.courses.count == 0 {
//            loadSampleCourses()
//        }
        
        updateLabels()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        print("CourseTable: viewDidAppear -> Entry")
        tableView.reloadData()
        updateLabels()

        save()
        print("CourseTable: viewDidAppear -> Exit")
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // should perform segue
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        print("CourseTable: shouldPerformSegue -> Entry")
        if (sender as? UIButton) != nil {
            print("CourseTable: shouldPerformSegue -> Sender is UIButton")
            if (index == -1) {
                print("CourseTable: shouldPerformSegue -> Exit Return False")
                return false
            }
            else {
                print("CourseTable: shouldPerformSegue -> Exit Return True")
                return true
            }
        }
        if tableView.isEditing == true {
            print("CourseTable: shouldPerformSegue -> Exit Return False")
            return false
        }
        else {
            print("CourseTable: shouldPerformSegue -> Exit Return True")
            return true
        }
    }
    
    // preparing for segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier=="CourseView" {
            print("CourseTable: prepare: Setting courses to courseView")
            let selectedCourse = sender as? CourseTableViewCell
            let destVC = segue.destination as? MarksTableViewController
            
            destVC?.groups = self.groups
            destVC?.courseName = (selectedCourse?.courseName.text)!
            destVC?.index = self.index
            print("CourseTable: prepare: destVC.index=\(destVC?.index)")
        }
            
        else if segue.identifier=="AddItem" {
            print("CourseTable: prepare: Setting courses to view.")
            let destinationViewController = segue.destination.childViewControllers[0] as? NewCoursesViewController
            destinationViewController?.groups = groups
            destinationViewController?.index = index
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    // MARK: Functions
    
    //Find index for course with courseName
    func findIndexForGroup(groupName: String) -> Int {
        for i in 0..<groups.count {
            if groups[i].groupName == groupName {
                return i
            }
        }
        return -1
    }
    
    // Go back to the details view
    @IBAction func backToDetailView(_ sender: AnyObject) {
        print("CourseTable: backToDetailView: Going back a view")
        save()
        self.dismiss(animated: true, completion: nil)
    }
    
    
    // If the user selects multiple courses and chooses delete
    @IBAction func deleteCourses(_ sender: AnyObject) {
        var indexPaths = tableView.indexPathsForSelectedRows
        if (indexPaths != nil) {
            print("CoursesTable: deleteCourses -> Entry: Deleting \(indexPaths!.count) rows")
            
            // the indexes must be sorted by row value since you can only delete one course at a time, the size of courses is always changing
            for i in 0..<indexPaths!.count {
                print("Index \(i): Section: \(indexPaths![i].section) Row: \(indexPaths![i].row)")
            }
            print("Sorting")
            indexPaths = indexPaths?.sorted()
            for i in 0..<indexPaths!.count {
                print("Index \(i): Section: \(indexPaths![i].section) Row: \(indexPaths![i].row)")
            }
            
            var offset = 0
            
            if (index != -1) {
                print("CoursesTable: deleteCourses -> Deleting from group \(groups[index].groupName)")
                for i in 0..<indexPaths!.count {
                    groups[index].courses.remove(at: (indexPaths?[i].row)! + offset)
                    offset -= 1
                }
            }
            else {
                var offset = 0
                var previousSection = indexPaths![0].section
                
                for i in 0..<indexPaths!.count {
                    
                    if (previousSection == indexPaths![i].section && i != 0) {
                        offset -= 1
                    }
                    else {
                        offset = 0
                    }
                    
                    if (i != 0) {
                        previousSection = indexPaths![i].section
                    }
                    
                    print("CourseTable: deleteCourses: Removing course: \(groups[indexPaths![i].section].courses[indexPaths![i].row + offset].courseName)")
                    groups[indexPaths![i].section].courses.remove(at: (indexPaths![i].row) + offset)
                    
                }
                
                tableView.deleteRows(at: indexPaths!, with: .fade)
            }
            
            //reload data, update the labels and save changes
            tableView.reloadData()
            updateLabels()
            save()
            
            // Get out of editing mode
            tableView.setEditing(false, animated: true)
            self.setEditing(false, animated: true)
            
            //If courses.count is empty, then hide toolbar. This is to fix a bug where the toolbar appears when no courses are in the list
            self.navigationController!.toolbar.isHidden = true
            
            self.updateLabels()
            
            print("CoursesTable: deleteCourses -> Exit")
        }
    }
    
    
    @IBAction func editCourse(_ sender: AnyObject) {
        let indexPaths = tableView.indexPathsForSelectedRows
        if (indexPaths!.count != 1) {
            print("CourseTable: editCourse: The user has \(indexPaths!.count) and clicked the edit button. This cannot happen.")
        }
        else {
            editCourseTitle(indexPath: indexPaths![0])
        }
    }
    
    
    func updateLabels() {
        print("CourseTable: updateLabels: updating labels.")
        let average = getOverallAverage()
        let num = getNumCourses()
        
        if (average != -1.0) {
            overallAverage.text = "\(round(10*average*100)/10)%"
        }
        else {
            overallAverage.text = "N/A"
        }
        numCourses.text = "\(num)"
    }
    
    
    //Returns the overall average of all courses in view
    func getOverallAverage() -> Double {
        print("CourseTable: getOverallAverage -> Entry")
        var average = 0.0
        var courseMark = 0.0
        var numCourses = 0
        
        if (index == -1) {
            for i in 0..<groups.count {
                courseMark = groups[i].getGroupAverage()
                
                if courseMark != -1.0 {
                    average += courseMark
                    numCourses += 1
                }
            }
            
            if (numCourses != 0) {
                print("CourseTable: getOverallAverage -> Exit: RETURN \(average) with number of courses in calculation: \(numCourses)")
                return (average/Double(numCourses))
            }
            else {
                print("CourseTable: getOverallAverage -> Exit: RETURN -1.0 since there are no courses in calculation.")
                return -1.0
            }
        }
        else {
            print("CourseTable: getOverallAverage: Getting averages in dictionary: \(groups[index].groupName)")
            let returnVal = groups[index].getGroupAverage()
            print("CourseTable: getOverallAverage: Exit: RETURN \(returnVal)")
            return returnVal
        }
    }
    
    
    //Gets the total number of courses
    func getNumCourses() -> Int {
        print("CourseTable: getNumCourses Called")
        if (index == -1) {
            var total = 0
            for group in groups {
                total += group.courses.count
            }
            return total
        }
        else {
            return groups[index].courses.count
        }
    }
    
    
    
    @IBAction func unwindToCourseList(_ sender: UIStoryboardSegue) {
        print("CourseTable: unwindToCourseList: Adding course to course list.")
        if let sourceViewController = sender.source as? NewCoursesViewController {
            let course = sourceViewController.course
            print("CourseTable: unwindToCourseList: New course: \(course.courseName)")
            let newIndexPath: IndexPath
            let groupIndex = sourceViewController.groupSelection.selectedRow(inComponent: 0)
            
            if (index == -1) {
                newIndexPath = IndexPath(row: groups[groupIndex].courses.count, section: groupIndex)
                groups[groupIndex].courses.append(course)
                tableView.insertRows(at: [newIndexPath], with: .bottom)
                tableView.reloadRows(at: [newIndexPath], with: .fade)
            }
            else {
                if (index == groupIndex) {
                    print("CourseTable: unwindToCourseList: index == groupIndex, adding course")
                    newIndexPath = IndexPath(row: groups[groupIndex].courses.count, section: 0)
                    groups[groupIndex].courses.append(course)
                    tableView.insertRows(at: [newIndexPath], with: .bottom)
                    tableView.reloadRows(at: [newIndexPath], with: .fade)
                }
                else {
                    groups[groupIndex].courses.append(course)
                }
            }
            
//            if (index == -1) {
//                print("CourseTable: unwindToCourseList: index is -1")
//                let tempIndex = findIndexForGroup(groupName: "Ungrouped Courses")
//                newIndexPath = IndexPath(row: groups[tempIndex].courses.count, section: tempIndex)
//                groups[tempIndex].courses.append(course)
//            }
//            else {
//                print("CourseTable: unwindToCourseList: index is \(index)")
//                newIndexPath = IndexPath(row: groups[index].courses.count, section: 0)
//                groups[index].courses.append(course)
//            }
            
            save()
        }
        else {
            print("CourseTable: unwindToCourseList: Failed to add course.")
        }
    }
    
    
    func editCourseTitle(indexPath: IndexPath) {
        print("CourseTableView: editActionsForRowAt: User selected edit")
        var alertController: UIAlertController
        if (index == -1) {
            alertController = UIAlertController(title: "Editing Course: \(self.groups[indexPath.section].courses[indexPath.row].courseName)", message: "", preferredStyle: UIAlertControllerStyle.alert)
        }
        else {
            alertController = UIAlertController(title: "Editing Course: \(self.groups[self.index].courses[indexPath.row].courseName)", message: "", preferredStyle: UIAlertControllerStyle.alert)
        }
        
        let saveAction = UIAlertAction(title: "Save", style: UIAlertActionStyle.default, handler: {
            (action: UIAlertAction!) -> Void in
            
            let courseNameField = alertController.textFields![0] as UITextField
            
            if (self.index == -1) {
                self.groups[indexPath.section].courses[indexPath.row].courseName = courseNameField.text!
            }
            else {
                self.groups[self.index].courses[indexPath.row].courseName = courseNameField.text!
            }
            
            self.save()
            self.tableView.reloadRows(at: [indexPath], with: UITableViewRowAnimation.fade)
        });
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: {
            (action: UIAlertAction!) -> Void in
            // do nothing
        });
        
        alertController.addTextField(configurationHandler: { (textField : UITextField!) -> Void in
        
            if (self.index == -1) {
                textField.text = self.groups[indexPath.section].courses[indexPath.row].courseName
            }
            else {
                textField.text = self.groups[self.index].courses[indexPath.row].courseName
            }
        });
        
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    

    // MARK: - Table view data source
    
    // Returns the number of sections in the table
    override func numberOfSections(in tableView: UITableView) -> Int {
        if (index == -1) {
            print("CourseTable: numberOfSections: Returning \(groups.count)")
            return groups.count
        }
        else {
            print("CourseTable: numberOfSections: Returning static(1)")
            return 1
        }
    }
    
    // Returns the number of rows per section
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (index == -1) {
            print("CourseTable: numberOfRowsInSection \(section): Returning \(groups[section].courses.count) for section \(section)")
            return groups[section].courses.count
        }
        else {
            print("CourseTable: numberOfRowsInSection \(section): Returning \(groups[index].courses.count)")
            return groups[index].courses.count
        }
    }
    
    //Returns the title for the current section
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if index == -1 {
//            if groups[section].courses.count != 0 {
                return groups[section].groupName
//            }
//            return nil
        }
        else {
            return nil
        }
    }
    
    // Setting the data of each cell
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "CourseTableViewCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! CourseTableViewCell

        var course: Course
        
        if (index == -1) {
            course = groups[indexPath.section].courses[indexPath.row]
        }
        else {
            course = groups[index].courses[indexPath.row]
        }
        
        cell.courseName.text = course.courseName
            
        if course.getAverage() != -1.0 {
            cell.courseDescription.text = "Mark: \(round(10*course.getAverage()*100)/10)%"
        }
        else {
            cell.courseDescription.text = "Not enough information"
        }
        
        cell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
        
        return cell
    }

    
    // Override to support conditional editing of the table view.
    // Sets all cells to be editable and when editing it brings up the toolbar
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        print("CourseTable: canEditRowAt -> Entry")
        if (tableView.isEditing) {
            print("CourseTable: canEditRowAt -> setToolBarHidden = false")
            self.navigationController?.setToolbarHidden(false, animated: true)
            addButton.isEnabled = false
        }
        else {
            print("CourseTable: canEditRowAt -> setToolBarHidden = true")
            self.navigationController?.setToolbarHidden(true, animated: true)
            addButton.isEnabled = true
        }
        print("CourseTable: canEditRowAt -> Exit")
        return true
    }
    
    // Checks a cell when in edit mode
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (tableView.isEditing) {
            let selectedRows = tableView.indexPathsForSelectedRows
            
            if selectedRows?.count == 0 {
                print("CourseTable: TableView: 0 rows selected")
                self.deleteButton.isEnabled = false
                self.editButton.isEnabled = false
            }
            else if selectedRows?.count == 1 {
                print("CourseTable: TableView: 1 row selected")
                self.deleteButton.isEnabled = true
                self.editButton.isEnabled = true
            }
            else {
                print("CourseTable: TableView: >1 rows selected")
                self.deleteButton.isEnabled = true
                self.editButton.isEnabled = false
            }
        }
    }

    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if (tableView.isEditing) {
            let selectedRows = tableView.indexPathsForSelectedRows
            
            if selectedRows?.count == 0 {
                print("CourseTable: TableViewDeselect: 0 rows selected")
                self.deleteButton.isEnabled = false
                self.editButton.isEnabled = false
            }
            else if selectedRows?.count == 1 {
                print("CourseTable: TableViewDeselect: 1 rows selected")
                self.deleteButton.isEnabled = true
                self.editButton.isEnabled = true
            }
            else {
                print("CourseTable: TableViewDeselect: >1 rows selected")
                self.deleteButton.isEnabled = true
                self.editButton.isEnabled = false
            }
        }
    }
    
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        print("CourseTable: editActionsForRowAt: Setting buttons")
        let deleteRowAction = UITableViewRowAction(style: UITableViewRowActionStyle.destructive, title: "Delete", handler:{action, indexPath in
            
            if (self.index == -1) {
                self.groups[indexPath.section].courses.remove(at: indexPath.row)
            }
            else {
                self.groups[self.index].courses.remove(at: indexPath.row)
            }
            
            self.save()
            self.tableView.deleteRows(at: [indexPath], with: .fade)
            self.updateLabels()
        });
        
        let editCourseTitle = UITableViewRowAction(style: UITableViewRowActionStyle.normal, title: "Edit", handler: { action, indexPath in
            self.editCourseTitle(indexPath: indexPath)
        });
        
        return [deleteRowAction, editCourseTitle]
    }
    
    
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        print("CourseTable: tableView moveRowAt -> Entry")
        
        if index == -1 {
            //TODO: Need to delete course from current group and add to a new group
            let tempCourse = groups[sourceIndexPath.section].courses.remove(at: sourceIndexPath.row)
            print("CourseTableView: moveRowAt: Moving course: \(tempCourse.courseName) from group \(groups[sourceIndexPath.section].groupName) to group \(groups[destinationIndexPath.section].groupName)")
            groups[destinationIndexPath.section].courses.insert(tempCourse, at: destinationIndexPath.row)
        }
        else {
            let tempCourse = groups[index].courses.remove(at: sourceIndexPath.row)
            print("CourseTableView: moveRowAt: Moving course: \(tempCourse.courseName) from group \(groups[sourceIndexPath.section].groupName) to group \(groups[destinationIndexPath.section].groupName)")
            groups[index].courses.insert(tempCourse, at: destinationIndexPath.row)
        }
        
        //////////// LOGGING START
        if index == -1 {
            print("CourseTable: moveRowAt: New order of courses:")
            for course in groups[sourceIndexPath.section].courses {
                print(course.courseName)
            }
        }
        else {
            print("CourseTable: moveRowAt: New order of courses:")
            for course in groups[index].courses {
                print(course.courseName)
            }
        }
        /////////// END LOGGING
        
        save()
        print("CourseTable: moveRowAt -> Exit")
    }
    
    
    
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }

    
    // MARK: NSCoding
    
    // Save user information
    func save() {
        print("CourseTable: save: Saving courses and groups.")
        if (!NSKeyedArchiver.archiveRootObject(self.groups, toFile: Group.ArchiveURL.path)) {
            print("CourseTable: save: Failed to save courses and groups.")
        }
    }
    
    // Load user information
    func load() -> [Group]? {
        print("CourseTable: Load: Loading courses.")
        return (NSKeyedUnarchiver.unarchiveObject(withFile: Group.ArchiveURL.path) as! [Group]?)
    }
    
}
