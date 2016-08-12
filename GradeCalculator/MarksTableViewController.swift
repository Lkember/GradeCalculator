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
    
    // MARK: Actions
    @IBAction func unwindToProjectList(sender: UIStoryboardSegue) {
        if let svc = sender.sourceViewController as? AddProjectViewController {
            
            let newIndexPath = NSIndexPath(forRow: course!.projects.count, inSection: 0)
            
            if svc.projectGrade == -1.0 {
                course?.addProject(svc.projectName, grade: -1.0, weight: svc.projectWeight)
            }
            else {
                course?.addProject(svc.projectName, grade: svc.projectGrade/svc.projectOutOf, weight: svc.projectWeight)
            }
            tableView.insertRowsAtIndexPaths([newIndexPath], withRowAnimation: .Bottom)
        }
        updateAverageLabel()
    }
    
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
        
        updateAverageLabel()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - Functions
    func updateAverageLabel() {
        if ((10*course!.getAverage()*100)/10 != -100.0) {
            averageLabel.text = "\(round(10*course!.getAverage()*100)/10)%"
        }
        else {
            averageLabel.text = "Unavailable"
        }
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
            return 0
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
//        tableView.registerClass(MarksViewCell.self, forCellReuseIdentifier: "MarksViewCell")
        let cellIdentifier = "MarksViewCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! MarksViewCell
        
        if (course?.projects.count != 0) {
            
            cell.projectNameLabel.text = course?.projects[indexPath.row]
            
            if (course!.projectMarks[indexPath.row] != -1.0) {
                cell.markLabel.text = "\(round(10*course!.projectMarks[indexPath.row])*100/10)%"
            }
            else {
                cell.markLabel.text = "Incomplete"
            }
            
            cell.weightLabel.text = "\(round(10*course!.projectWeights[indexPath.row])*100/1000)%"
            
            if (cell.markLabel.hidden) {
                cell.markLabel.hidden = false
                cell.weightLabel.hidden = false
                cell.staticWeightLabel.hidden = false
                cell.staticMarkLabel.hidden = false
            }
        }
//        else {
//            cell.projectNameLabel.text = "Not enough information."
//            cell.markLabel.hidden = true
//            cell.weightLabel.hidden = true
//            cell.staticMarkLabel.hidden = true
//            cell.staticWeightLabel.hidden = true
//        }
        
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
