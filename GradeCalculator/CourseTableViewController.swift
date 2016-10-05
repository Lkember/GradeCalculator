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
    
    var courses = [Course]()
    @IBOutlet weak var overallAverage: UILabel!
    @IBOutlet weak var numCourses: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Add an edit button
        navigationItem.leftBarButtonItem = editButtonItem
        self.tableView.allowsSelectionDuringEditing = true
        if let savedCourses = loadCourses() {
            courses += savedCourses
        }
        else {
            loadSampleCourses()
        }
        
        updateLabels()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        print("CourseTable: viewDidAppear")
        tableView.reloadData()
        updateLabels()
        saveCourses()
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
            print("CourseTable: Setting courses to courseView")
            let selectedCourse = sender as? CourseTableViewCell
            let destVC = segue.destination as? MarksTableViewController
            destVC?.courses = self.courses
            destVC?.courseName = (selectedCourse?.courseName.text)!
        }
            
        else if segue.identifier=="AddItem" {
            print("CourseTable: Setting courses to view.")
            let destinationViewController = segue.destination.childViewControllers[0] as? NewCoursesViewController
            destinationViewController?.courses = courses;
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    // MARK: Functions
    
    func updateLabels() {
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
        
        for course in courses {
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
    
    
    func getNumCourses() -> Int {
        return courses.count
    }
    
    
    @IBAction func unwindToCourseList(_ sender: UIStoryboardSegue) {
        print("CourseTable: Adding course to course list.")
        if let sourceViewController = sender.source as? NewCoursesViewController, let course = sourceViewController.course {
            print("CourseTable: New course: \(course.courseName)")
            let newIndexPath = IndexPath(row: courses.count, section: 0)
            self.courses.append(course)
            tableView.insertRows(at: [newIndexPath], with: .bottom)
            
            tableView.reloadData()
            
            // save courses
            saveCourses()
        }
        else {
            print("CourseTable: Failed to add course.")
        }
    }
    
    
    func loadSampleCourses() {
        let calculus = Course(courseName: "Calculus 1000")
        let physics = Course(courseName: "Physics 1026")
        let compSci = Course(courseName: "CompSci 1027")
        calculus?.addProject("Midterm", grade: 0.86, outOf: 1, weight: 0.25)
        calculus?.addProject("Assignment 1", grade: 0.95, outOf: 1, weight: 0.12)
        calculus?.addProject("Assignment 2", grade: 0.82, outOf: 1, weight: 0.13)
        physics?.addProject("Midterm", grade: 0.78, outOf: 1, weight: 0.35)
        physics?.addProject("Assignment 1", grade: 0.67, outOf: 1, weight: 0.1)
        physics?.addProject("Assignment 2", grade: 1.0, outOf: 1, weight: 0.1)
        courses.append(calculus!)
        courses.append(physics!)
        courses.append(compSci!)
    }
    

    // MARK: - Table view data source
    
    // Returns the number of sections in the table
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    // Returns the number of rows per section
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return courses.count
    }

    // Setting the data of each cell
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "CourseTableViewCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! CourseTableViewCell
        
        let course = courses[(indexPath as NSIndexPath).row]
        cell.courseName.text = course.courseName
        
        if course.getAverage() != -1.0 {
            cell.courseDescription.text = "Course Average: \(round(10*course.getAverage()*100)/10)%"
        }
        else {
            cell.courseDescription.text = "Not enough information"
        }

        return cell
    }

    
    // Override to support conditional editing of the table view.
    // Sets all cells to be editable
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    // Checks a cell when in edit mode
//    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        if (tableView.isEditing == true) {
//            let check = tableView.cellForRow(at: indexPath)?.accessoryType
//            
//            if check == UITableViewCellAccessoryType.checkmark {
//                print("Deselected")
//                tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCellAccessoryType.none
//            }
//            else {
//                print("Selected")
//                tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCellAccessoryType.checkmark
//            }
//        }
//    }
    
    // Override to support editing the table view.
//    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
//        if editingStyle == .delete {
//            // Delete the row from the data source
//            courses.remove(at: (indexPath as NSIndexPath).row)
//            saveCourses()
//            tableView.deleteRows(at: [indexPath], with: .fade)
//        } else if editingStyle == .insert {
//            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
//        }    
//    }
    
    // Sets the style of editing when the edit button is selected
//    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
//        return UITableViewCellEditingStyle.delete
//    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        print("CourseTable: Setting buttons")
        let deleteRowAction = UITableViewRowAction(style: UITableViewRowActionStyle.destructive, title: "Delete", handler:{action, indexPath in
            self.courses.remove(at: (indexPath as NSIndexPath).row)
            self.saveCourses()
            self.tableView.deleteRows(at: [indexPath], with: .fade)
        });
        
        let editCourseTitle = UITableViewRowAction(style: UITableViewRowActionStyle.normal, title: "Edit", handler: { action, indexPath in
            print("Edit was selected.")
            
            let alertController = UIAlertController(title: "Edit Course: \(self.courses[indexPath.row].courseName)", message: "", preferredStyle: UIAlertControllerStyle.alert)
            
            let saveAction = UIAlertAction(title: "Save", style: UIAlertActionStyle.default, handler: {
                (action: UIAlertAction!) -> Void in
                
                let courseNameField = alertController.textFields![0] as UITextField
                
                self.courses[indexPath.row].courseName = courseNameField.text!
                self.saveCourses()
                self.tableView.reloadRows(at: [indexPath], with: UITableViewRowAnimation.fade)
            });
            
            let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: {
                (action: UIAlertAction!) -> Void in
                // do nothing
            });
            
            alertController.addTextField(configurationHandler: { (textField : UITextField!) -> Void in
                textField.text = self.courses[indexPath.row].courseName
            });
            
            alertController.addAction(saveAction)
            alertController.addAction(cancelAction)
            
            self.present(alertController, animated: true, completion: nil)
        });
    
        return [deleteRowAction, editCourseTitle]
    }
    
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        print("CourseTable: tableView moveRowAt -> Entry")
        var index = sourceIndexPath.row
        let temp = courses[index]
        
        if sourceIndexPath.row < destinationIndexPath.row {
            while (index < destinationIndexPath.row) {
                courses[index] = courses[index+1]
                index += 1
            }
        }
        else {
            while (index > destinationIndexPath.row) {
                courses[index] = courses[index-1]
                index -= 1
            }
        }
        courses[destinationIndexPath.row] = temp
        saveCourses()
        print("CourseTable: tableView moveRowAt -> Exit")
    }
    
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }

    
    // MARK: NSCoding
    // Save user information
    func saveCourses() {
        print("CourseTable: Saving courses.")
        if (!NSKeyedArchiver.archiveRootObject(courses, toFile: Course.ArchiveURL.path)) {
            print("CourseTable: Failed to save meals...")
        }
    }
    
    func loadCourses() -> [Course]? {
        print("CourseTable: Loading courses...")
        return (NSKeyedUnarchiver.unarchiveObject(withFile: Course.ArchiveURL.path) as? [Course])
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
