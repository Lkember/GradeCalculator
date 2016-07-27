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
    
    func loadSampleCourses() {
        let calculus = Course(courseName: "Calculus 1000")
        let physics = Course(courseName: "Physics 1026")
        let compSci = Course(courseName: "CompSci 1027")
        calculus?.addProject("Midterm", grade: 0.86)
        calculus?.addProject("Assignment 1", grade: 0.95)
        calculus?.addProject("Assignment 2", grade: 0.82)
        physics?.addProject("Midterm", grade: 0.78)
        physics?.addProject("Assignment 1", grade: 0.67)
        physics?.addProject("Assignment 2", grade: 1.0)
        courses.append(calculus!)
        courses.append(physics!)
        courses.append(compSci!)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Load sample data
        loadSampleCourses()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier=="addNewCourseSegue" {
            let destinationViewController = segue.destinationViewController as? NewCoursesViewController
            destinationViewController?.courses = courses;
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return courses.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = "CourseTableViewCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! CourseTableViewCell
        
        let course = courses[indexPath.row]
        cell.courseName.text = course.courseName
        
        if course.getAverage() != -1.0 {
            cell.courseDescription.text = "Course Average: \(round(10*course.getAverage()*100)/10)%"
        }
        else {
            cell.courseDescription.text = "Not enough information"
        }

        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
