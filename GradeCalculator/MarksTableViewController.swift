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
    @IBOutlet weak var numMarks: UILabel!
    var courses = [Course]()
    var course = Course(courseName: "")
    var courseName = ""
    
    // MARK: Actions
    @IBAction func unwindToProjectList(_ sender: UIStoryboardSegue) {
        print("MarksTable: Starting unwind to project list method.")
        if let svc = sender.source as? AddProjectViewController {
            
            // If user is editing a row
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                
                print("MarksTable: Editing a row")
                let i = (selectedIndexPath as NSIndexPath).row
                
                if svc.projectIsComplete.isOn == true {
                
                    print("MarksTable: projectName: \(svc.projectName), grade: \(svc.projectGrade), out of: \(svc.projectOutOf), weight: \(svc.projectWeight)")
                    course!.projects[i] = svc.projectName
                    course!.projectMarks[i] = svc.projectGrade
                    course!.projectWeights[i] = svc.projectWeight
                    course!.projectOutOf[i] = svc.projectOutOf
                    tableView.reloadRows(at: [selectedIndexPath], with: .fade)
                }
                else {
                    print("MarksTable: projectName: \(svc.projectName), grade: -1.0, out of: -1.0, weight: \(svc.projectWeight)")
                    course!.projects[i] = svc.projectName
                    course!.projectMarks[i] = -1.0
                    course!.projectWeights[i] = svc.projectWeight
                    course!.projectOutOf[i] = -1.0
                    tableView.reloadRows(at: [selectedIndexPath], with: .fade)
                }
            }
            // If user is adding a new row
            else {
                print("MarksTable: Adding a new row")
                
                let newIndexPath = IndexPath(row: course!.projects.count, section: 0)
                
                if svc.projectGrade == -1.0 {
                    print("MarksTable: Adding project \(svc.projectName), grade: -1.0, outOf: -1.0, weight: \(svc.projectWeight)")
                    course?.addProject(svc.projectName, grade: -1.0, outOf: -1.0, weight: svc.projectWeight)
                }
                else {
                    print("MarksTable: Adding project \(svc.projectName), grade \(svc.projectGrade), outOf \(svc.projectOutOf), weight \(svc.projectWeight)")
                    course?.addProject(svc.projectName, grade: svc.projectGrade, outOf: svc.projectOutOf, weight: svc.projectWeight)
                }
                tableView.insertRows(at: [newIndexPath], with: .bottom)
            }
        }	
        saveCourses()
        updateLabels()
    }
    
    @IBAction func deleteFromProjectList(_ sender: UIStoryboardSegue) {
        if let selectedIndexPath = tableView.indexPathForSelectedRow {
            course!.projects.remove(at: (selectedIndexPath as NSIndexPath).row)
            course!.projectWeights.remove(at: (selectedIndexPath as NSIndexPath).row)
            course!.projectMarks.remove(at: (selectedIndexPath as NSIndexPath).row)
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
        
        updateLabels()
        saveCourses()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - Functions
    func updateLabels() {
        if ((10*course!.getAverage()*100)/10 != -100.0) {
            averageLabel.text = "\(round(10*course!.getAverage()*100)/10)%"
        }
        else {
            averageLabel.text = "N/A"
        }
        
        numMarks.text = "\(course!.getNumMarks())"
    }
    
    // save course information
    func saveCourses() {
        print("MarksTable: Saving courses...")
        if (!NSKeyedArchiver.archiveRootObject(courses, toFile: Course.ArchiveURL.path)) {
            print("MarksTable: Failed to save meals...")
        }
    }
    
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (course?.projects.count != 0) {
            return (course?.projects.count)!
        }
        else {
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        tableView.registerClass(MarksViewCell.self, forCellReuseIdentifier: "MarksViewCell")
        let cellIdentifier = "MarksViewCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! MarksViewCell
        
        if (course?.projects.count != 0) {
            
            cell.projectNameLabel.text = course?.projects[(indexPath as NSIndexPath).row]
            
            if (course!.projectMarks[(indexPath as NSIndexPath).row] != -1.0) {
                let mark = course!.projectMarks[(indexPath as NSIndexPath).row]/course!.projectOutOf[(indexPath as NSIndexPath).row]
                cell.markLabel.text = "\(round(10*(mark)*100)/10)%"
            }
            else {
                cell.markLabel.text = "Incomplete"
            }
            
            cell.weightLabel.text = "\(round(10*course!.projectWeights[(indexPath as NSIndexPath).row])*100/1000)%"
            
            if (cell.markLabel.isHidden) {
                cell.markLabel.isHidden = false
                cell.weightLabel.isHidden = false
                cell.staticWeightLabel.isHidden = false
                cell.staticMarkLabel.isHidden = false
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
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "EditItem") {
            print("MarksTable: User selected a cell.")
            let courseDVC = segue.destination as! AddProjectViewController
            
            if let selectedCell = sender as? MarksViewCell {
                let indexPath = tableView.indexPath(for: selectedCell)!
                let selectedProject = course?.projects[(indexPath as NSIndexPath).row]
                
                print("MarksTable: User selected \(selectedProject!)")
                print("MarksTable: project grade: \(course?.projectMarks[(indexPath as NSIndexPath).row]) out of \(course?.projectOutOf[(indexPath as NSIndexPath).row])")
                
                courseDVC.projectName = selectedProject!
                courseDVC.projectWeight = (course?.projectWeights[(indexPath as NSIndexPath).row])!
                courseDVC.projectGrade = (course?.projectMarks[(indexPath as NSIndexPath).row])!
                courseDVC.projectOutOf = (course?.projectOutOf[(indexPath as NSIndexPath).row])!
            }
            
        } else if (segue.identifier == "AddItem") {
            print("MarksTable: User selected add button.")
        }
        
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    
    
}
