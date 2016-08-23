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
        print("MarksTable: Starting unwind to project list method.")
        if let svc = sender.sourceViewController as? AddProjectViewController {
            
            // If user is editing a row
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                
                print("MarksTable: Editing a row")
                let i = selectedIndexPath.row
                
                if svc.projectIsComplete.on == true {
                
                    print("MarksTable: projectName: \(svc.projectName), grade: \(svc.projectGrade), out of: \(svc.projectOutOf), weight: \(svc.projectWeight)")
                    course!.projects[i] = svc.projectName
                    course!.projectMarks[i] = svc.projectGrade
                    course!.projectWeights[i] = svc.projectWeight
                    course!.projectOutOf[i] = svc.projectOutOf
                    tableView.reloadRowsAtIndexPaths([selectedIndexPath], withRowAnimation: .Fade)
                }
                else {
                    print("MarksTable: projectName: \(svc.projectName), grade: -1.0, out of: -1.0, weight: \(svc.projectWeight)")
                    course!.projects[i] = svc.projectName
                    course!.projectMarks[i] = -1.0
                    course!.projectWeights[i] = svc.projectWeight
                    course!.projectOutOf[i] = -1.0
                    tableView.reloadRowsAtIndexPaths([selectedIndexPath], withRowAnimation: .Fade)
                }
            }
            // If user is adding a new row
            else {
                print("MarksTable: Adding a new row")
                
                let newIndexPath = NSIndexPath(forRow: course!.projects.count, inSection: 0)
                
                if svc.projectGrade == -1.0 {
                    print("MarksTable: Adding project \(svc.projectName), grade: -1.0, outOf: -1.0, weight: \(svc.projectWeight)")
                    course?.addProject(svc.projectName, grade: -1.0, outOf: -1.0, weight: svc.projectWeight)
                }
                else {
                    print("MarksTable: Adding project \(svc.projectName), grade \(svc.projectGrade), outOf \(svc.projectOutOf), weight \(svc.projectWeight)")
                    course?.addProject(svc.projectName, grade: svc.projectGrade, outOf: svc.projectOutOf, weight: svc.projectWeight)
                }
                tableView.insertRowsAtIndexPaths([newIndexPath], withRowAnimation: .Bottom)
            }
        }	
        saveCourses()
        updateAverageLabel()
    }
    
    @IBAction func deleteFromProjectList(sender: UIStoryboardSegue) {
        if let selectedIndexPath = tableView.indexPathForSelectedRow {
            course!.projects.removeAtIndex(selectedIndexPath.row)
            course!.projectWeights.removeAtIndex(selectedIndexPath.row)
            course!.projectMarks.removeAtIndex(selectedIndexPath.row)
        }
        tableView.reloadData()
    }
    
    
    // When the view loads, perform the following
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("Starting.. Courses.count=\(courses.count)")
        for course in courses {
            if course.courseName == courseName {
                print("MarksTable: Found. User clicked \(course.courseName)")
                self.course = course
            }
        }
        print("MarksTable: Setting title to \(course!.courseName)")
        self.navigationItem.title = course!.courseName
        tableView.rowHeight = 60.0
        
        updateAverageLabel()
        saveCourses()
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
    
    // save course information
    func saveCourses() {
        print("MarksTable: Saving courses...")
        if (!NSKeyedArchiver.archiveRootObject(courses, toFile: Course.ArchiveURL.path!)) {
            print("MarksTable: Failed to save meals...")
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
                let mark = course!.projectMarks[indexPath.row]/course!.projectOutOf[indexPath.row]
                cell.markLabel.text = "\(round(10*(mark)*100)/10)%"
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
    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "EditItem") {
            print("MarksTable: User selected a cell.")
            let courseDVC = segue.destinationViewController as! AddProjectViewController
            
            if let selectedCell = sender as? MarksViewCell {
                let indexPath = tableView.indexPathForCell(selectedCell)!
                let selectedProject = course?.projects[indexPath.row]
                
                print("MarksTable: User selected \(selectedProject!)")
                print("MarksTable: project grade: \(course?.projectMarks[indexPath.row]) out of \(course?.projectOutOf[indexPath.row])")
                
                courseDVC.projectName = selectedProject!
                courseDVC.projectWeight = (course?.projectWeights[indexPath.row])!
                courseDVC.projectGrade = (course?.projectMarks[indexPath.row])!
                courseDVC.projectOutOf = (course?.projectOutOf[indexPath.row])!
            }
            
        } else if (segue.identifier == "AddItem") {
            print("MarksTable: User selected add button.")
        }
        
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    
    
}
