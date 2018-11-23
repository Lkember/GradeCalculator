//
//  CourseTableViewController.swift
//  GradeCalculator
//
//  Created by Logan Kember on 2016-07-25.
//  Copyright © 2016 Logan Kember. All rights reserved.
//

import UIKit

class CourseTableViewController: UITableViewController {

    // MARK: - Properties
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var index = -1
    @IBOutlet weak var overallAverage: UILabel!
    @IBOutlet weak var numCourses: UILabel!
    @IBOutlet weak var deleteButton: UIBarButtonItem!
    @IBOutlet weak var editButton: UIBarButtonItem!
    @IBOutlet weak var addButton: UIBarButtonItem!
    @IBOutlet weak var informationView: UIView!
    
    // MARK: - Views
    override func viewDidLoad() {
        print("CourseTable: viewDidLoad -> Entry")
        super.viewDidLoad()
        
        if (index != -1) {
            print("CourseTable: viewDidLoad: Current Index = \(index)")
            self.title = appDelegate.groups[index].groupName
            
//            let currentFrame = self.informationView.frame
//            self.informationView.frame = CGRect(x: currentFrame.origin.x, y: currentFrame.origin.y, width: currentFrame.width, height: currentFrame.height + 50)
        }
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
        self.tableView.allowsMultipleSelectionDuringEditing = true
        self.tableView.allowsSelectionDuringEditing = true
        self.navigationController?.navigationBar.barStyle = UIBarStyle.black
        self.navigationController?.toolbar.barStyle = UIBarStyle.black
        
        //Add an edit button to the navigation bar
//        navigationItem.leftBarButtonItem = editButtonItem
        self.navigationItem.rightBarButtonItems?.append(self.editButtonItem)
        
        // Add buttons to tool bar
        self.navigationController?.setToolbarHidden(true, animated: true)
        self.deleteButton.isEnabled = false
        self.editButton.isEnabled = false
        
        // Adding an edge swipe listener
//        let edgePan = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(screenEdgeSwiped))
//        edgePan.edges = .left
//        view.addGestureRecognizer(edgePan)
        
        print("CourseTable: viewDidLoad Loading courses")
        
        if let loadedData = appDelegate.load() {
            appDelegate.groups = loadedData
        }
        
//        if groups.courses.count == 0 {
//            loadSampleCourses()
//        }
        
        updateLabels()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        print("CourseTable: viewDidAppear -> Entry")
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
        tableView.reloadData()
        updateLabels()
        appDelegate.save()
        print("CourseTable: viewDidAppear -> Exit")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        let views = self.navigationController!.viewControllers
        
        if (views.count > 2 && views[views.count-2] == self.navigationController) {
            print("CourseTable: viewWillDisappear -> New view controller was pushed onto the stack.")
        }
        else if (!views.contains(self) && !(views[views.count-1] is GroupsTableViewController)) {
            print("CourseTable: viewWillDisappear -> View controller was popped from stack.")
            self.navigationController?.setNavigationBarHidden(true, animated: true)
        }
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
        print("CourseTable: prepare: current identifier \(String(describing: segue.identifier))")
        if segue.identifier=="CourseView" {
            print("CourseTable: prepare: Setting courses to courseView")
            let selectedCourse = sender as? CourseTableViewCell
            let destVC = segue.destination as? MarksTableViewController
            
            destVC?.courseName = (selectedCourse?.courseName.text)!
            destVC?.groupIndex = self.index
            print("CourseTable: prepare: destVC.index=\(String(describing: destVC?.groupIndex))")
        }
            
        else if segue.identifier=="AddItem" {
            print("CourseTable: prepare: Setting courses to view.")
            let destinationViewController = segue.destination.children[0] as? NewCoursesViewController
//            destinationViewController?.groups = appDelegate.groups
            destinationViewController?.index = index
        }
        else if segue.identifier == nil {
            print("CourseTable: prepare: Back to startUpView")
            self.navigationController?.setNavigationBarHidden(true, animated: true)
        }
    }
    
    
    // Go back to the details view
    @IBAction func backToDetailView(_ sender: AnyObject) {
        print("CourseTable: backToDetailView: Going back a view")
        appDelegate.save()
        self.dismiss(animated: true, completion: nil)
    }
    
//    override func willMove(toParentViewController parent: UIViewController?) {
//        super.willMove(toParentViewController: parent)
//        
//        if parent == nil {
//            navigationController?.setNavigationBarHidden(true, animated: true)
////            navigationController?.navigationBar.isHidden = true
//        }
//        else {
//            navigationController?.setNavigationBarHidden(false, animated: true)
//        }
//    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    // MARK: - Functions
    //Find index for course with courseName
    func findIndexForGroup(groupName: String) -> Int {
        for i in 0..<appDelegate.groups.count {
            if appDelegate.groups[i].groupName == groupName {
                return i
            }
        }
        return -1
    }
    
    
    // If the user selects multiple courses and chooses delete
    @IBAction func deleteCourses(_ sender: AnyObject) {
        var indexPaths = tableView.indexPathsForSelectedRows
        if (indexPaths != nil) {
            print("CoursesTable: deleteCourses -> Entry: Deleting \(indexPaths!.count) rows")
            
            
            ///////////////// BEGINNING OF UIALERT
            let alertController = UIAlertController(title: "Delete Course(s)", message: "Are you sure you want to delete \(indexPaths!.count) course(s)", preferredStyle: UIAlertController.Style.alert)
            
            alertController.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
            
            alertController.addAction(UIAlertAction(title: "Delete", style: UIAlertAction.Style.destructive, handler: { action in
                
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
                
                if (self.index != -1) {
                    print("CoursesTable: deleteCourses -> Deleting from group \(self.appDelegate.groups[self.index].groupName)")
                    for i in 0..<indexPaths!.count {
                        self.appDelegate.groups[self.index].courses.remove(at: (indexPaths?[i].row)! + offset)
                        offset -= 1
                    }
                    
                    self.tableView.deleteRows(at: indexPaths!, with: .fade)
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
                        
                        print("CourseTable: deleteCourses: Removing course: \(self.appDelegate.groups[indexPaths![i].section].courses[indexPaths![i].row + offset].courseName)")
                        self.appDelegate.groups[indexPaths![i].section].courses.remove(at: (indexPaths![i].row) + offset)
                        
                    }
                    
                    self.tableView.deleteRows(at: indexPaths!, with: .fade)
                }
                
                //reload data, update the labels and save changes
                self.tableView.reloadData()
                self.updateLabels()
                self.appDelegate.save()
                
                // Get out of editing mode
                self.tableView.setEditing(false, animated: true)
                self.setEditing(false, animated: true)
                
                //If courses.count is empty, then hide toolbar. This is to fix a bug where the toolbar appears when no courses are in the list
                self.navigationController?.setToolbarHidden(true, animated: true)
                
                self.updateLabels()
                
            }))
            //////////////// END OF UIALERT
            
            self.present(alertController, animated: true, completion: nil)
            
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
        let average = getOverallAverage()
        let num = getNumCourses()
        
        print("CourseTable: updateLabels: updating labels. Average = \(average), # courses = \(num)")
        
        if (average != -1.0) {
            overallAverage.text = "\(average)%"
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
        var groupMark = 0.0
        var numCourses = 0
        var totalNumCourses = 0
        
        var returnVal: Double = 0.0
        if (index == -1) {
            for i in 0..<appDelegate.groups.count {
                groupMark = appDelegate.groups[i].getGroupAverage()
                numCourses = appDelegate.groups[i].getNumActiveCourses()
                
                if groupMark != -1.0 {
                    average += groupMark * Double(numCourses)
                    totalNumCourses += numCourses
                }
            }
            
            if totalNumCourses != 0 {
                returnVal = average/Double(totalNumCourses)
            }
            else {
                return -1.0
            }
        }
        else {
            returnVal = appDelegate.groups[index].getGroupAverage()
        }
        
        return Helper.roundOneDecimalPlace(value: returnVal)
    }
    
    //Gets the total number of courses
    func getNumCourses() -> Int {
        print("CourseTable: getNumCourses Called")
        if (index == -1) {
            var total = 0
            for group in appDelegate.groups {
                total += group.courses.count
            }
            return total
        }
        else {
            return appDelegate.groups[index].courses.count
        }
    }
    
    
    
    @IBAction func unwindToCourseList(_ sender: UIStoryboardSegue) {
        print("CourseTable: unwindToCourseList: Adding course to course list.")
        if let svc = sender.source as? NewCoursesViewController {
            let course = svc.course
            
            print("CourseTable: unwindToCourseList: New course: \(course.courseName)")
            let newIndexPath: IndexPath
            let groupIndex = svc.groupSelection.selectedRow(inComponent: 0)
            
            // Adding the final mark to the course if the user entered this information
            if (svc.courseIsComplete.isOn &&
                svc.gradeField.text != "" &&
                svc.gradeOutOfField.text != "") {
                if let grade = Double(svc.gradeField.text!), let outOf = Double(svc.gradeOutOfField.text!) {
                    course.addProject("Final Mark", grade: grade, outOf: outOf, weight: 100.0, newDueDate: nil, isComplete: true)
                }
            }
            
            // Adding the course to it's designated group
            if (index == -1) {
                newIndexPath = IndexPath(row: appDelegate.groups[groupIndex].courses.count, section: groupIndex)
                appDelegate.groups[groupIndex].courses.append(course)
                tableView.insertRows(at: [newIndexPath], with: .bottom)
                tableView.reloadRows(at: [newIndexPath], with: .fade)
            }
            else {
                if (index == groupIndex) {
                    print("CourseTable: unwindToCourseList: index == groupIndex, adding course")
                    newIndexPath = IndexPath(row: appDelegate.groups[groupIndex].courses.count, section: 0)
                    appDelegate.groups[groupIndex].courses.append(course)
                    tableView.insertRows(at: [newIndexPath], with: .bottom)
                    tableView.reloadRows(at: [newIndexPath], with: .fade)
                }
                else {
                    appDelegate.groups[groupIndex].courses.append(course)
                }
            }
            
            appDelegate.save()
        }
        else {
            print("CourseTable: unwindToCourseList: Failed to add course.")
        }
    }
    
    
    func editCourseTitle(indexPath: IndexPath) {
        print("CourseTableView: editActionsForRowAt: User selected edit")
        var alertController: UIAlertController
        if (index == -1) {
            alertController = UIAlertController(title: "Editing Course: \(self.appDelegate.groups[indexPath.section].courses[indexPath.row].courseName)", message: "", preferredStyle: UIAlertController.Style.alert)
        }
        else {
            alertController = UIAlertController(title: "Editing Course: \(self.appDelegate.groups[self.index].courses[indexPath.row].courseName)", message: "", preferredStyle: UIAlertController.Style.alert)
        }
        
        let saveAction = UIAlertAction(title: "Save", style: UIAlertAction.Style.default, handler: {
            (action: UIAlertAction!) -> Void in
            
            let courseNameField = alertController.textFields![0] as UITextField
            
            if (courseNameField.text! != "") {
                if (self.index == -1) {
                    self.appDelegate.groups[indexPath.section].courses[indexPath.row].courseName = courseNameField.text!
                }
                else {
                    self.appDelegate.groups[self.index].courses[indexPath.row].courseName = courseNameField.text!
                }
            }
            
            self.appDelegate.save()
            self.setEditing(false, animated: true)
            self.navigationController?.setToolbarHidden(true, animated: true)
            self.tableView.reloadRows(at: [indexPath], with: UITableView.RowAnimation.fade)
        });
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: {
            (action: UIAlertAction!) -> Void in
            self.setEditing(false, animated: true)
            self.navigationController?.setToolbarHidden(true, animated: true)
            // do nothing
        });
        
        alertController.addTextField(configurationHandler: { (textField : UITextField!) -> Void in
        
            if (self.index == -1) {
                textField.text = self.appDelegate.groups[indexPath.section].courses[indexPath.row].courseName
            }
            else {
                textField.text = self.appDelegate.groups[self.index].courses[indexPath.row].courseName
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
            print("CourseTable: numberOfSections: Returning \(appDelegate.groups.count)")
            return appDelegate.groups.count
        }
        else {
            print("CourseTable: numberOfSections: Returning static(1)")
            return 1
        }
    }
    
    // Returns the number of rows per section
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (index == -1) {
            print("CourseTable: numberOfRowsInSection \(section): Returning \(appDelegate.groups[section].courses.count) for section \(section)")
            return appDelegate.groups[section].courses.count
        }
        else {
            print("CourseTable: numberOfRowsInSection \(section): Returning \(appDelegate.groups[index].courses.count)")
            return appDelegate.groups[index].courses.count
        }
    }
    
    //Returns the title for the current section
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if index == -1 {
            if appDelegate.groups[section].groupName == "Ungrouped Courses" && appDelegate.groups[section].courses.count == 0 {
                return nil
            }
            return appDelegate.groups[section].groupName
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
            course = appDelegate.groups[indexPath.section].courses[indexPath.row]
        }
        else {
            course = appDelegate.groups[index].courses[indexPath.row]
        }
        
        cell.courseName.text = course.courseName
        
        var average = course.getAverage()
        average = Helper.roundOneDecimalPlace(value: average)
        
        if average != -1.0 {
            cell.courseDescription.text = "Mark: \(average)%"
        }
        else {
            cell.courseDescription.text = "Incomplete"
        }
        
        cell.accessoryType = UITableViewCell.AccessoryType.disclosureIndicator
        
        let view = UIView()
        view.backgroundColor = UIColor.init(red: 0, green: 139/255, blue: 1, alpha: 1)
        cell.selectedBackgroundView = view
        
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
        let deleteRowAction = UITableViewRowAction(style: UITableViewRowAction.Style.destructive, title: "Delete", handler:{action, indexPath in
            
            if (self.index == -1) {
                self.appDelegate.groups[indexPath.section].courses.remove(at: indexPath.row)
            }
            else {
                self.appDelegate.groups[self.index].courses.remove(at: indexPath.row)
            }
            
            self.setEditing(false, animated: true)
            self.navigationController?.setToolbarHidden(true, animated: true)
            self.appDelegate.save()
            self.tableView.deleteRows(at: [indexPath], with: .fade)
            self.updateLabels()
        });
        
        let editCourseTitle = UITableViewRowAction(style: UITableViewRowAction.Style.normal, title: "Edit", handler: { action, indexPath in
            self.editCourseTitle(indexPath: indexPath)
        });
        
        return [deleteRowAction, editCourseTitle]
    }
    
    
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        print("CourseTable: tableView moveRowAt -> Entry")
        
        if index == -1 {
            let tempCourse = appDelegate.groups[sourceIndexPath.section].courses.remove(at: sourceIndexPath.row)
            print("CourseTableView: moveRowAt: Moving course: \(tempCourse.courseName) from group \(appDelegate.groups[sourceIndexPath.section].groupName) to group \(appDelegate.groups[destinationIndexPath.section].groupName)")
            appDelegate.groups[destinationIndexPath.section].courses.insert(tempCourse, at: destinationIndexPath.row)
        }
        else {
            let tempCourse = appDelegate.groups[index].courses.remove(at: sourceIndexPath.row)
            print("CourseTableView: moveRowAt: Moving course: \(tempCourse.courseName) from group \(appDelegate.groups[sourceIndexPath.section].groupName) to group \(appDelegate.groups[destinationIndexPath.section].groupName)")
            appDelegate.groups[index].courses.insert(tempCourse, at: destinationIndexPath.row)
        }
        
        appDelegate.save()
        print("CourseTable: moveRowAt -> Exit")
    }
    
    
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Always allow rearranging
        return true
    }
    
}
