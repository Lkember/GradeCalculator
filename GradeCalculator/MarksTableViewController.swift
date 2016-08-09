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
    @IBOutlet weak var average: UILabel!
    var courses = [Course]()
    var course = Course(courseName: "")
    var courseName = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for course in courses {
            if course.courseName == courseName {
                self.course = course
            }
        }
        
        let averageMark = round(10*course!.getAverage()*10)
        if averageMark != -1.0 {
            average.text = String(averageMark)
        }
        else {
            average.text = "Unavailable"
        }
        print("1")
        // Do any additional setup after loading the view.
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
        print("Number of rows: \((course?.projects.count)!/2)")
        return (course?.projects.count)!/2
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = "MarksViewCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! MarksViewCell
        
        cell.projectNameLabel.text = course?.projects[indexPath.row]
        cell.markLabel.text = String(course?.projectMarks[indexPath.row])
        cell.weightLabel.text = String(course?.projectWeights[indexPath.row])
        
        
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
