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
        tableView.reloadData()
        updateLabels()
        saveCourses()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier=="AddItem" {
            print("CourseTable: Setting courses to view.")
            let destinationViewController = segue.destination.childViewControllers[0] as? NewCoursesViewController
            destinationViewController?.courses = courses;
        }
        else if segue.identifier=="CourseView" {
            print("CourseTable: Setting courses to courseView")
            let selectedCourse = sender as? CourseTableViewCell
            let destVC = segue.destination as? MarksTableViewController
            destVC?.courses = self.courses
            destVC?.courseName = (selectedCourse?.courseName.text)!
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return courses.count
    }

    
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
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            courses.remove(at: (indexPath as NSIndexPath).row)
            saveCourses()
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
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
//    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
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
