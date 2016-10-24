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
<<<<<<< HEAD
    var groups: [Group] = []
    var index = -1
=======
    var index = -1
    var groups : [Group] = []
>>>>>>> master
    @IBOutlet weak var overallAverage: UILabel!
    @IBOutlet weak var numCourses: UILabel!
    @IBOutlet weak var deleteButton: UIBarButtonItem!
    @IBOutlet weak var editButton: UIBarButtonItem!
    @IBOutlet weak var addButton: UIBarButtonItem!
    @IBOutlet weak var backButton: UIButton!
    
    override func viewDidLoad() {
        print("CourseTable: viewDidLoad -> Entry")
        super.viewDidLoad()
        
<<<<<<< HEAD
        if (index != -1) {
            backButton.setTitle("Back", for: UIControlState.normal)
            print("CourseTable: viewDidLoad: Current Index = \(index)")
=======
//        if (dictionaryKey != "") {
//            backButton.setTitle("Back", for: UIControlState.normal)
//            self.title = dictionaryKey
//        }
        if index != -1 {
            backButton.setTitle("Back", for: UIControlState.normal)
>>>>>>> master
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
        
        print("CourseTable: viewDidLoad Loading courses")
        
        if let loadedData = load() {
            groups = loadedData
        }
        
        //TODO: Fix below method
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
<<<<<<< HEAD
            if (index == -1) {
=======
//            if (dictionaryKey == "") {
            if index == -1 {
>>>>>>> master
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
<<<<<<< HEAD
            print("DestVC count = \(destVC?.groups.count)")
//            destVC?.dictionaryKey = self.dictionaryKey
=======
            destVC?.index = self.index
>>>>>>> master
            destVC?.courseName = (selectedCourse?.courseName.text)!
            destVC?.index = self.index
            print("CourseTable: prepare: destVC.index=\(destVC?.index)")
        }
            
        else if segue.identifier=="AddItem" {
            print("CourseTable: prepare: Setting courses to view.")
            let destinationViewController = segue.destination.childViewControllers[0] as? NewCoursesViewController
<<<<<<< HEAD
            destinationViewController?.courses = groups[0].courses;
=======
            destinationViewController?.courses = groups[index].courses;
>>>>>>> master
            
//            destinationViewController?.groups = self.groups
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    // MARK: Functions
    
    // Go back to the details view
    @IBAction func backToDetailView(_ sender: AnyObject) {
        print("CourseTable: backToDetailView: Going back a view")
        save()
        self.dismiss(animated: true, completion: nil)
    }
    
    
    //TODO: THIS METHOD MUST BE COMPLETED TO DEAL WITH THE NEW DATA TYPE
    // If the user selects multiple courses and chooses delete
    @IBAction func deleteCourses(_ sender: AnyObject) {
        var indexPaths = tableView.indexPathsForSelectedRows
        if (indexPaths != nil) {
            print("CoursesTable: deleteCourses -> Entry: Deleting \(indexPaths!.count) rows")
            
            // the indexes must be sorted by row value since you can only delete one course at a time, the size of courses is always changing
            indexPaths = indexPaths?.sorted()
            var offset = 0
            
<<<<<<< HEAD
            if (index != -1) {
                print("CoursesTable: deleteCourses -> Deleting from group \(groups[index].groupName)")
                for i in 0..<indexPaths!.count {
                    groups[index].courses.remove(at: (indexPaths?[i].row)! + offset)
=======
//            if (dictionaryKey != "") {
            if (index != -1) {
                print("CoursesTable: deleteCourses -> Deleting from group \(groups[index].groupName)")
                for i in 0..<indexPaths!.count {
                    //TODO: I don't think this will work. It must be fixed.
                    groups[index].deleteFromCourseList(courseToDelete: groups[index].courses[(indexPaths?[i].row)!])
//                    groups.deleteFromCourseList(courseToDelete: groups.group[dictionaryKey]?.remove(at: (indexPaths?[i].row)! + offset))
>>>>>>> master
                    offset -= 1
                }
            }
<<<<<<< HEAD
            else {
                
                //TODO: NEED TO IMPLEMENT STILL
=======
//            else {
>>>>>>> master
//                var tempCourses: [Course] = []
//                
//                for i in 0..<indexPaths!.count {
//                    tempCourses.append(groups.courses[(indexPaths?[i].row)!])
//                    print("CoursesTable: deleteCourses: Deleting course \(tempCourses.last!.courseName)")
//                }
//                
//                for i in 0..<indexPaths!.count {
//                    groups.courses.remove(at: (indexPaths![i].row) + offset)
//                    
//                    offset-=1
//                }
//                
//                print("CoursesTable: deleteCourses -> Running removeCourses from Group Class.")
//                groups.removeCourses(coursesToDelete: tempCourses)
<<<<<<< HEAD
            }
=======
//            }
>>>>>>> master
            
            //reload data, update the labels and save changes
            tableView.reloadData()
            updateLabels()
            save()
            
            // Get out of editing mode
            tableView.setEditing(false, animated: true)
            self.setEditing(false, animated: true)
            
            //If courses.count is empty, then hide toolbar. This is to fix a bug where the toolbar appears when no courses are in the list
            self.navigationController!.toolbar.isHidden = true
            
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
    
<<<<<<< HEAD
    
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
=======
//TODO: THIS METHOD MUST BE UPDATED TO DEAL WITH NEW DATA TYPE
    func getOverallAverage() -> Double {
//        print("CourseTable: getOverallAverage -> Entry")
//        var average = 0.0
//        var courseMark = 0.0
//        var numCourses = 0
//        
//        if (index == -1) {
//            for course in groups.courses {
//                courseMark = course.getAverage()
//                if courseMark != -1.0 {
//                    average += course.getAverage()
//                    numCourses += 1
//                }
//            }
//            if (numCourses != 0) {
//                average = (average/Double(numCourses))
//            }
//            else {
//                average = -1.0
//            }
//            print("CourseTable: getOverallAverage RETURN \(average) with number of courses in calculation: \(numCourses)")
//            print("CourseTable: getOverallAverage -> Exit")
//            return average
//        }
//        else {
//            print("CourseTable: getOverallAverage: Getting averages in dictionary: \(dictionaryKey)")
//            for course in groups.group[dictionaryKey]! {
//                courseMark = course.getAverage()
//                if courseMark != -1.0 {
//                    average += course.getAverage()
//                    numCourses += 1
//                }
//            }
//            if (numCourses != 0) {
//                average = (average/Double(numCourses))
//            }
//            else {
//                average = -1.0
//            }
//            print("CourseTable: getOverallAverage RETURN \(average) with number of courses in calculation: \(numCourses)")
//            print("CourseTable: getOverallAverage -> Exit")
//            return average
//        }
        return -1.0
>>>>>>> master
    }
    
    
    //Gets the total number of courses
    func getNumCourses() -> Int {
        print("CourseTable: getNumCourses Called")
        if (index == -1) {
<<<<<<< HEAD
            var total = 0
            for group in groups {
                total += group.courses.count
            }
            return total
=======
            var counter = 0
            for group in groups {
                counter += group.courses.count
            }
            return counter
>>>>>>> master
        }
        else {
            return groups[index].courses.count
        }
    }
    
<<<<<<< HEAD
    
    
=======
    //TODO: THIS METHOD STILL NEEDS TO BE COMPLETED
>>>>>>> master
    @IBAction func unwindToCourseList(_ sender: UIStoryboardSegue) {
        print("CourseTable: unwindToCourseList: Adding course to course list.")
        if let sourceViewController = sender.source as? NewCoursesViewController, let course = sourceViewController.course {
            print("CourseTable: unwindToCourseList: New course: \(course.courseName)")
            let newIndexPath: IndexPath
            
<<<<<<< HEAD
            if (index == -1) {
                newIndexPath = IndexPath(row: groups[0].courses.count, section: 0)
                groups[0].courses.append(course)
            }
            else {
                newIndexPath = IndexPath(row: groups[index].courses.count, section: index)
                groups[index].courses.append(course)
            }
            
=======
//            if (dictionaryKey == "") {
            if (index == -1) {
                newIndexPath = IndexPath(row: getNumCourses(), section: 0)
//                groups.group["Ungrouped Courses"]?.append(course)
                groups[0].courses.append(course)
            }
            else {
                newIndexPath = IndexPath(row: getNumCourses(), section: 0)
                groups[index].courses.append(course)
            }
            
//            self.groups.courses.append(course)
            
>>>>>>> master
            tableView.insertRows(at: [newIndexPath], with: .bottom)
            tableView.reloadRows(at: [newIndexPath], with: .fade)
            
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
<<<<<<< HEAD
            alertController = UIAlertController(title: "Editing Course: \(self.groups[self.index].courses[indexPath.row].courseName)", message: "", preferredStyle: UIAlertControllerStyle.alert)
=======
            alertController = UIAlertController(title: "Editing Course: \(self.groups[index].courses[indexPath.row].courseName)", message: "", preferredStyle: UIAlertControllerStyle.alert)
>>>>>>> master
        }
        
        let saveAction = UIAlertAction(title: "Save", style: UIAlertActionStyle.default, handler: {
            (action: UIAlertAction!) -> Void in
            
            let courseNameField = alertController.textFields![0] as UITextField
            
            if (self.index == -1) {
<<<<<<< HEAD
                self.groups[indexPath.section].courses[indexPath.row].courseName = courseNameField.text!
=======
                let tempCourse = self.groups[indexPath.section].courses[indexPath.row]
                self.groups[indexPath.section].courses[indexPath.row].courseName = courseNameField.text!
//                self.groups.editCourse(courseToEdit: tempCourse, newCourseName: courseNameField.text!)
>>>>>>> master
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
    
    
//    func loadSampleCourses() {
//        print("CourseTable: loadSampleCourses -> Entry")
//        let calculus = Course(courseName: "Calculus 1000")
//        let physics = Course(courseName: "Physics 1026")
//        let compSci = Course(courseName: "CompSci 1027")
//        calculus?.addProject("Midterm", grade: 0.86, outOf: 1, weight: 25)
//        calculus?.addProject("Assignment 1", grade: 0.95, outOf: 1, weight: 12)
//        calculus?.addProject("Assignment 2", grade: 0.82, outOf: 1, weight: 13)
//        physics?.addProject("Midterm", grade: 0.78, outOf: 1, weight: 35)
//        physics?.addProject("Assignment 1", grade: 0.67, outOf: 1, weight: 10)
//        physics?.addProject("Assignment 2", grade: 1.0, outOf: 1, weight: 10)
//        
//        groups.courses.append(calculus!)
//        groups.courses.append(physics!)
//        groups.courses.append(compSci!)
//        
//        groups.group["Ungrouped Courses"]?.append(calculus!)
//        groups.group["Ungrouped Courses"]?.append(physics!)
//        groups.group["Ungrouped Courses"]?.append(compSci!)
//        
//        print("CourseTable: loadSampleCourses -> Exit")
//    }
    

    // MARK: - Table view data source
    
    // Returns the number of sections in the table
    override func numberOfSections(in tableView: UITableView) -> Int {
        if (index != -1) {
            return 1
        }
        return groups.count
    }
    
    // Returns the number of rows per section
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //TODO: Make this function return the number of courses in a section (group) using the keys array
        
        if (index == -1) {
            return groups[section].courses.count
        }
        else {
            return groups[index].courses.count
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
<<<<<<< HEAD
                self.groups[indexPath.section].courses.remove(at: indexPath.row)
            }
            else {
=======
                var course: [Course] = []
                course.append(self.groups[indexPath.section].courses[indexPath.row])
                self.groups[indexPath.section].courses.remove(at: indexPath.row)
//                self.groups.removeCourses(coursesToDelete: course)
            }
            else {
//                self.groups[index].deleteFromCourseList(courseToDelete: self.groups.group[self.dictionaryKey]![indexPath.row])
>>>>>>> master
                self.groups[self.index].courses.remove(at: indexPath.row)
            }
            
            self.save()
            self.tableView.deleteRows(at: [indexPath], with: .fade)
        });
        
        let editCourseTitle = UITableViewRowAction(style: UITableViewRowActionStyle.normal, title: "Edit", handler: { action, indexPath in
            self.editCourseTitle(indexPath: indexPath)
        });
        
        return [deleteRowAction, editCourseTitle]
    }
    
    
    //TODO: IF TABLE CAN BE REARRANGED THIS METHOD MUST BE COMPLETED FOR NEW DATA TYPE
    // Override to support rearranging the table view.
<<<<<<< HEAD
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        print("CourseTable: tableView moveRowAt -> Entry")
        
        if (sourceIndexPath.section == destinationIndexPath.section) {
            if (index == -1) {
                var sourceIndex = sourceIndexPath.row
                let temp = groups[sourceIndexPath.section].courses[sourceIndexPath.row]
                
                if sourceIndexPath.row < destinationIndexPath.row {
                    while (sourceIndex < destinationIndexPath.row) {
                        groups[sourceIndexPath.section].courses[sourceIndex] = groups[sourceIndexPath.section].courses[sourceIndex+1]
                        sourceIndex += 1
                    }
                }
                else {
                    while (sourceIndex > destinationIndexPath.row) {
                        groups[sourceIndexPath.section].courses[sourceIndex] = groups[sourceIndexPath.section].courses[sourceIndex-1]
                        sourceIndex -= 1
                    }
                }
                groups[sourceIndexPath.section].courses[destinationIndexPath.row] = temp
            }
            else {
                var sourceIndex = sourceIndexPath.row
                let temp = groups[index].courses[sourceIndex]
                
                if sourceIndexPath.row < destinationIndexPath.row {
                    while (sourceIndex < destinationIndexPath.row) {
                        groups[index].courses[sourceIndex] = groups[index].courses[sourceIndex+1]
                        sourceIndex += 1
                    }
                }
                else {
                    while (sourceIndex > destinationIndexPath.row) {
                        groups[index].courses[sourceIndex] = groups[index].courses[sourceIndex-1]
                        sourceIndex -= 1
                    }
                    groups[index].courses[destinationIndexPath.row] = temp
                }
            }
        }
        save()
    }
=======
//    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
//        print("CourseTable: tableView moveRowAt -> Entry")
//
//        //TODO: If the table is changed to have sections, than this method must be changed
//        if (index == -1) {
//            var index = sourceIndexPath.row
//            let temp = groups[sourceIndexPath.section].courses[index]
//            
//            if sourceIndexPath.row < destinationIndexPath.row {
//                while (index < destinationIndexPath.row) {
//                    groups.courses[index] = groups.courses[index+1]
//                    index += 1
//                }
//            }
//            else {
//                while (index > destinationIndexPath.row) {
//                    groups.courses[index] = groups.courses[index-1]
//                    index -= 1
//                }
//            }
//            groups.courses[destinationIndexPath.row] = temp
//        }
//        else {
//            var index = sourceIndexPath.row
//            let temp = groups.group[dictionaryKey]![index]
//            
//            if sourceIndexPath.row < destinationIndexPath.row {
//                while (index < destinationIndexPath.row) {
//                    groups.group[dictionaryKey]![index] = groups.group[dictionaryKey]![index+1]
//                    index += 1
//                }
//            }
//            else {
//                while (index > destinationIndexPath.row) {
//                    groups.group[dictionaryKey]![index] = groups.group[dictionaryKey]![index-1]
//                    index -= 1
//                }
//                groups.group[dictionaryKey]![destinationIndexPath.row] = temp
//            }
//        }
//        save()
//    }
>>>>>>> master
    
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
