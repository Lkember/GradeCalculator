//
//  MarksViewController.swift
//  GradeCalculator
//
//  Created by Logan Kember on 2016-08-09.
//  Copyright © 2016 Logan Kember. All rights reserved.
//

import UIKit

class MarksTableViewController: UITableViewController {

    // MARK: Attributes
    @IBOutlet weak var averageLabel: UILabel!
    var courses = [Course]()
    var course = Course(courseName: "")
    var courseName = ""
    
    // When the view loads, perform the following
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("Starting.. Courses.count=\(courses.count)")
        for course in courses {
            if course.courseName == courseName {
                print("Found. User clicked \(course.courseName)")
                self.course = course
            }
        }
        
        let averageMark = round(10*(course?.getAverage())!*10)
        if averageMark != -100.0 {
            averageLabel.text = String(averageMark)
        }
        else {
            averageLabel.text = "Unavailable"
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
        if (course?.projects.count != 0) {
            return (course?.projects.count)!
        }
        else {
            return 1
        }
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
//        tableView.registerClass(MarksViewCell.self, forCellReuseIdentifier: "MarksViewCell")
        let cellIdentifier = "MarksViewCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! MarksViewCell
        
        if (course?.projects.count != 0) {
            cell.projectNameLabel.text = course?.projects[indexPath.row]
            cell.markLabel.text = String(course!.projectMarks[indexPath.row])
            cell.weightLabel.text = String(course!.projectWeights[indexPath.row])
            if (cell.markLabel.hidden) {
                cell.markLabel.hidden = false
                cell.weightLabel.hidden = false
                cell.staticWeightLabel.hidden = false
                cell.staticMarkLabel.hidden = false
            }
        }
        else {
            cell.projectNameLabel.text = "Not enough information."
            cell.markLabel.hidden = true
            cell.weightLabel.hidden = true
            cell.staticMarkLabel.hidden = true
            cell.staticWeightLabel.hidden = true
        }
        
        return cell
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
