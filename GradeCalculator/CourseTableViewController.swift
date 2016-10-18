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
    var dictionaryKey: String = ""
    var groups = Group()
//    var courses = [Course]()
    @IBOutlet weak var overallAverage: UILabel!
    @IBOutlet weak var numCourses: UILabel!
    @IBOutlet weak var deleteButton: UIBarButtonItem!
    @IBOutlet weak var editButton: UIBarButtonItem!
    @IBOutlet weak var addButton: UIBarButtonItem!
    
    
    override func viewDidLoad() {
        print("CourseTable: viewDidLoad -> Entry")
        super.viewDidLoad()
        
        self.tableView.allowsMultipleSelectionDuringEditing = true
        self.tableView.allowsSelectionDuringEditing = true
        
        //Add an edit button to the navigation bar
        navigationItem.leftBarButtonItem = editButtonItem
        
        // Add buttons to tool bar
        self.navigationController!.toolbar.isHidden = true
        self.deleteButton.isEnabled = false
        self.editButton.isEnabled = false
        
        print("CourseTable: viewDidLoad Loading courses")
//        if let savedCourses = loadCourses() {
//            if groups.courses.count == 0 {
//                groups.courses = savedCourses
//                groups.group["Ungrouped Courses"] = savedCourses
//            }
//            courses += savedCourses
//        }
        
        
        ///////////////////////////////////////////////////////////
        if let loadedData = load() {
            groups = loadedData
            for course in groups.courses {
                print("Loaded Course: \(course.courseName)")
            }
        }
        ///////////////////////////////////////////////////////////
        
        
        if groups.courses.count == 0 {
            loadSampleCourses()
        }
        
        updateLabels()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        print("CourseTable: viewDidAppear -> Entry")
        tableView.reloadData()
        updateLabels()
//        saveCourses()
        
        ///////////////////////////////////////////////////////////
        save()
        ///////////////////////////////////////////////////////////
        print("CourseTable: viewDidAppear -> Exit")
    }
    
    // should perform segue
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if tableView.isEditing == true {
            return false
        }
        else {
            return true
        }
    }
    
    // preparing for segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier=="CourseView" {
            print("CourseTable: prepare: Setting courses to courseView")
            let selectedCourse = sender as? CourseTableViewCell
            let destVC = segue.destination as? MarksTableViewController
            destVC?.courses = self.groups.courses
            destVC?.courseName = (selectedCourse?.courseName.text)!
            
            ///////////////////////////////////////////////////////////
//            destVC?.groups = self.groups
//            destVC?.courseName = (selectedCourse?.courseName.text)!
            ///////////////////////////////////////////////////////////
        }
            
        else if segue.identifier=="AddItem" {
            print("CourseTable: prepare: Setting courses to view.")
            let destinationViewController = segue.destination.childViewControllers[0] as? NewCoursesViewController
            destinationViewController?.courses = groups.courses;
            
            ///////////////////////////////////////////////////////////
//            destinationViewController?.groups = self.groups
            ///////////////////////////////////////////////////////////
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    // MARK: Functions
    
    // Go back to the details view
    @IBAction func backToDetailView(_ sender: AnyObject) {
        ///////////////////////////////////////////////////////////
        save()
        ///////////////////////////////////////////////////////////
//        saveCourses()
        self.dismiss(animated: true, completion: nil)
    }
    
    
    // If the user selects multiple courses and chooses delete
    @IBAction func deleteCourses(_ sender: AnyObject) {
        var indexPaths = tableView.indexPathsForSelectedRows
        if (indexPaths != nil) {
            print("CoursesTable: deleteCourses -> Entry: Deleting \(indexPaths!.count) rows")
            
            // the indexes must be sorted by row value since you can only delete one course at a time, the size of courses is always changing
            indexPaths = indexPaths?.sorted()
            var offset = 0
            
            //TODO: Still have to delete the course from groups as well.
            ///////////////////////////////////////////////////////////
            if (dictionaryKey != "") {
                for i in 0..<indexPaths!.count {
                    _ = groups.group[dictionaryKey]?.remove(at: (indexPaths?[i].row)! + offset)
                    offset -= 1
                }
            }
            else {
                print("CoursesTable: deleteCourses -> Deleting from group \(dictionaryKey)")
                var tempCourses: [Course?] = []
                
                for i in 0..<indexPaths!.count {
                    tempCourses.append(groups.courses[(indexPaths?[i].row)!])
                }
                
                print("CoursesTable: deleteCourses -> Running removeCourses from Group Class.")
                groups.removeCourses(coursesToDelete: tempCourses)
                for course in groups.courses {
                    print("remaining courses = \(course.courseName)")
                }
            }
            ///////////////////////////////////////////////////////////
            offset = 0
            
//            for i in 0..<indexPaths!.count {
//                print("CoursesTable: deleteCourses: Removing course: \(courses[(indexPaths?[i].row)! + offset].courseName), indexPath=\(indexPaths?[i].row), offset=\(offset)")
//                courses.remove(at: (indexPaths?[i].row)! + offset)
//                offset -= 1
//            }
            
            //reload data, update the labels and save changes
            tableView.reloadData()
            updateLabels()
//            saveCourses()
            
            ///////////////////////////////////////////////////////////
            save()
            ///////////////////////////////////////////////////////////
            
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
    
    
    func getOverallAverage() -> Double {
        print("CourseTable: getOverallAverage -> Entry")
        var average = 0.0
        var courseMark = 0.0
        var numCourses = 0
        
//        for course in courses {
//            courseMark = course.getAverage()
//            if courseMark != -1.0 {
//                average += course.getAverage()
//                numCourses += 1
//            }
//        }
//        if (numCourses != 0) {
//            average = (average/Double(numCourses))
//        }
//        else {
//            average = -1.0
//        }
//        print("CourseTable: getOverallAverage RETURN \(average) with number of courses in calculation: \(numCourses)")
//        print("CourseTable: getOverallAverage -> Exit")
//        return average
        
        ///////////////////////////////////////////////////////
        if (dictionaryKey == "") {
            for course in groups.courses {
                courseMark = course.getAverage()
                if courseMark != -1.0 {
                    average += course.getAverage()
                    numCourses += 1
                }
            }
            if (numCourses != 0) {
                average = (average/Double(numCourses))
            }
            else {
                average = -1.0
            }
            print("CourseTable: getOverallAverage RETURN \(average) with number of courses in calculation: \(numCourses)")
            print("CourseTable: getOverallAverage -> Exit")
            return average
        }
        else {
            for course in groups.group[dictionaryKey]! {
                courseMark = course.getAverage()
                if courseMark != -1.0 {
                    average += course.getAverage()
                    numCourses += 1
                }
            }
            if (numCourses != 0) {
                average = (average/Double(numCourses))
            }
            else {
                average = -1.0
            }
            print("CourseTable: getOverallAverage RETURN \(average) with number of courses in calculation: \(numCourses)")
            print("CourseTable: getOverallAverage -> Exit")
            return average
        }
        ///////////////////////////////////////////////////////
    }
    
    
    func getNumCourses() -> Int {
        ///////////////////////////////////////////////////////////
        if (dictionaryKey == "") {
            return groups.courses.count
        }
        else {
            return groups.group[dictionaryKey]!.count
        }
        ///////////////////////////////////////////////////////////
//        return courses.count
    }
    
    
    @IBAction func unwindToCourseList(_ sender: UIStoryboardSegue) {
        print("CourseTable: unwindToCourseList: Adding course to course list.")
        if let sourceViewController = sender.source as? NewCoursesViewController, let course = sourceViewController.course {
            print("CourseTable: unwindToCourseList: New course: \(course.courseName)")
//            let newIndexPath = IndexPath(row: courses.count, section: 0)
            let newIndexPath: IndexPath
//            self.courses.append(course)
            ///////////////////////////////////////////////////////////
            
            if (dictionaryKey == "") {
                newIndexPath = IndexPath(row: groups.courses.count, section: 0)
                groups.group["Ungrouped Courses"]?.append(course)
            }
            else {
                newIndexPath = IndexPath(row: groups.group[dictionaryKey]!.count, section: 0)
                groups.group[dictionaryKey]?.append(course)
            }
            
            self.groups.courses.append(course)
            ///////////////////////////////////////////////////////////
            tableView.insertRows(at: [newIndexPath], with: .bottom)
            
            tableView.reloadData()
            
            // save courses
//            saveCourses()
            
            ///////////////////////////////////////////////////////////
            save()
            ///////////////////////////////////////////////////////////
        }
        else {
            print("CourseTable: Failed to add course.")
        }
    }
    
    
    func editCourseTitle(indexPath: IndexPath) {
        print("CourseTableView: editActionsForRowAt: User selected edit")
        ////////////////////////////////////////////////////////////////
        var alertController: UIAlertController
        if (dictionaryKey == "") {
            alertController = UIAlertController(title: "Editing Course: \(self.groups.courses[indexPath.row].courseName)", message: "", preferredStyle: UIAlertControllerStyle.alert)
        }
        else {
            alertController = UIAlertController(title: "Editing Course: \(self.groups.group[dictionaryKey]?[indexPath.row].courseName)", message: "", preferredStyle: UIAlertControllerStyle.alert)
        }
        ////////////////////////////////////////////////////////////////
        
        let saveAction = UIAlertAction(title: "Save", style: UIAlertActionStyle.default, handler: {
            (action: UIAlertAction!) -> Void in
            
            let courseNameField = alertController.textFields![0] as UITextField
            
            ///////////////////////////////////////////////////////////
            if (self.dictionaryKey == "") {
                let tempCourse = self.groups.courses[indexPath.row]
                self.groups.courses[indexPath.row].courseName = courseNameField.text!
                self.groups.editCourse(courseToEdit: tempCourse, newCourseName: courseNameField.text!)
            }
            else {
                self.groups.group[self.dictionaryKey]?[indexPath.row].courseName = courseNameField.text!
            }
            self.save()
            ///////////////////////////////////////////////////////////
            
//            self.courses[indexPath.row].courseName = courseNameField.text!
//            self.saveCourses()
            self.tableView.reloadRows(at: [indexPath], with: UITableViewRowAnimation.fade)
        });
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: {
            (action: UIAlertAction!) -> Void in
            // do nothing
        });
        
        alertController.addTextField(configurationHandler: { (textField : UITextField!) -> Void in
//            textField.text = self.courses[indexPath.row].courseName
            //////////////////////////////////////////////////////////
            if (self.dictionaryKey == "") {
                textField.text = self.groups.courses[indexPath.row].courseName
            }
            else {
                textField.text = self.groups.group[self.dictionaryKey]?[indexPath.row].courseName
            }
            //////////////////////////////////////////////////////////
        });
        
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    func loadSampleCourses() {
        print("CourseTable: loadSampleCourses -> Entry")
        let calculus = Course(courseName: "Calculus 1000")
        let physics = Course(courseName: "Physics 1026")
        let compSci = Course(courseName: "CompSci 1027")
        calculus?.addProject("Midterm", grade: 0.86, outOf: 1, weight: 25)
        calculus?.addProject("Assignment 1", grade: 0.95, outOf: 1, weight: 12)
        calculus?.addProject("Assignment 2", grade: 0.82, outOf: 1, weight: 13)
        physics?.addProject("Midterm", grade: 0.78, outOf: 1, weight: 35)
        physics?.addProject("Assignment 1", grade: 0.67, outOf: 1, weight: 1)
        physics?.addProject("Assignment 2", grade: 1.0, outOf: 1, weight: 1)
//        courses.append(calculus!)
//        courses.append(physics!)
//        courses.append(compSci!)
        
        groups.courses.append(calculus!)
        groups.courses.append(physics!)
        groups.courses.append(compSci!)
        
        groups.group["Ungrouped Courses"]?.append(calculus!)
        groups.group["Ungrouped Courses"]?.append(physics!)
        groups.group["Ungrouped Courses"]?.append(compSci!)
        
//        groups.courses = courses
//        groups.group["Ungrouped Courses"] = courses
        print("CourseTable: loadSampleCourses -> Exit")
    }
    

    // MARK: - Table view data source
    
    // Returns the number of sections in the table
    override func numberOfSections(in tableView: UITableView) -> Int {
        //TODO: Make the number of sections equal to the number of groups
        return 1
    }
    
    // Returns the number of rows per section
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //TODO: Make this function return the number of courses in a section (group) using the keys array
//        return courses.count
        //////////////////////////////////////////////////
        if (dictionaryKey == "") {
            return groups.courses.count
        }
        else {
            return groups.group[dictionaryKey]!.count
        }
        //////////////////////////////////////////////////
    }

    // Setting the data of each cell
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "CourseTableViewCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! CourseTableViewCell
        
//        let course = courses[(indexPath as NSIndexPath).row]
//        cell.courseName.text = course.courseName
//        
//        if course.getAverage() != -1.0 {
//            cell.courseDescription.text = "Course Average: \(round(10*course.getAverage()*100)/10)%"
//        }
//        else {
//            cell.courseDescription.text = "Not enough information"
//        }
//        
//        cell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
//        
//        return cell
        
        //////////////////////////////////////////////////
        var course: Course
        
        if (dictionaryKey == "") {
            course = groups.courses[indexPath.row]
        }
        else {
            course = groups.group[dictionaryKey]![indexPath.row]
        }
        
        cell.courseName.text = course.courseName
            
        if course.getAverage() != -1.0 {
            cell.courseDescription.text = "Course Average: \(round(10*course.getAverage()*100)/10)%"
        }
        else {
            cell.courseDescription.text = "Not enough information"
        }
        
        cell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
        
        return cell
        //////////////////////////////////////////////////
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
//            self.courses.remove(at: (indexPath as NSIndexPath).row)
//            self.saveCourses()
//            self.tableView.deleteRows(at: [indexPath], with: .fade)
            
            ////////////////////////////////////////////////////////////////////
            if (self.dictionaryKey == "") {
                var course: [Course?] = []
                course.append(self.groups.courses[indexPath.row])
                self.groups.courses.remove(at: indexPath.row)
                self.groups.removeCourses(coursesToDelete: course)
            }
            else {
                self.groups.deleteFromCourseList(courseToDelete: self.groups.group[self.dictionaryKey]![indexPath.row])
                self.groups.group[self.dictionaryKey]!.remove(at: indexPath.row)
            }
            
            self.save()
            self.tableView.deleteRows(at: [indexPath], with: .fade)
            ////////////////////////////////////////////////////////////////////
        });
        
        let editCourseTitle = UITableViewRowAction(style: UITableViewRowActionStyle.normal, title: "Edit", handler: { action, indexPath in
            self.editCourseTitle(indexPath: indexPath)
        });
        
        return [deleteRowAction, editCourseTitle]
    }
    
    
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        print("CourseTable: tableView moveRowAt -> Entry")
//        var index = sourceIndexPath.row
//        let temp = courses[index]
//        
//        if sourceIndexPath.row < destinationIndexPath.row {
//            while (index < destinationIndexPath.row) {
//                courses[index] = courses[index+1]
//                index += 1
//            }
//        }
//        else {
//            while (index > destinationIndexPath.row) {
//                courses[index] = courses[index-1]
//                index -= 1
//            }
//        }
//        courses[destinationIndexPath.row] = temp
//        saveCourses()
//        print("CourseTable: tableView moveRowAt -> Exit")
//        
        ////////////////////////////////////////////////////////////////////
        //TODO: If the table is changed to have sections, than this method must be changed
        if (dictionaryKey == "") {
            var index = sourceIndexPath.row
            let temp = groups.courses[index]
            
            if sourceIndexPath.row < destinationIndexPath.row {
                while (index < destinationIndexPath.row) {
                    groups.courses[index] = groups.courses[index+1]
                    index += 1
                }
            }
            else {
                while (index > destinationIndexPath.row) {
                    groups.courses[index] = groups.courses[index-1]
                    index -= 1
                }
            }
            groups.courses[destinationIndexPath.row] = temp
        }
        else {
            var index = sourceIndexPath.row
            let temp = groups.group[dictionaryKey]![index]
            
            if sourceIndexPath.row < destinationIndexPath.row {
                while (index < destinationIndexPath.row) {
                    groups.group[dictionaryKey]![index] = groups.group[dictionaryKey]![index+1]
                    index += 1
                }
            }
            else {
                while (index > destinationIndexPath.row) {
                    groups.group[dictionaryKey]![index] = groups.group[dictionaryKey]![index-1]
                    index -= 1
                }
                groups.group[dictionaryKey]![destinationIndexPath.row] = temp
            }
        }
        save()
        ////////////////////////////////////////////////////////////////////
    }
    
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }

    
    // MARK: NSCoding
    // Save user information
//    func saveCourses() {
//        print("CourseTable: saveCourses: Saving courses.")
//        if (!NSKeyedArchiver.archiveRootObject(courses, toFile: Course.ArchiveURL.path)) {
//            print("CourseTable: Failed to save meals...")
//        }
//    }
    
//    func loadCourses() -> [Course]? {
//        print("CourseTable: Loading courses...")
//        return (NSKeyedUnarchiver.unarchiveObject(withFile: Course.ArchiveURL.path) as? [Course])
//    }
    
    func save() {
        print("CourseTable: save: Saving courses and groups.")
        if (!NSKeyedArchiver.archiveRootObject(self.groups, toFile: Group.ArchiveURL.path)) {
            print("CourseTable: save: Failed to save courses and groups.")
        }
    }
    
    func load() -> Group? {
        print("CourseTable: Load: Loading courses.")
        return (NSKeyedUnarchiver.unarchiveObject(withFile: Group.ArchiveURL.path) as! Group?)
    }
    
}
