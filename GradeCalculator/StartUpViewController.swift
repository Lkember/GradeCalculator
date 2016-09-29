//
//  StartUpViewController.swift
//  GradeCalculator
//
//  Created by Logan Kember on 2016-09-29.
//  Copyright © 2016 Logan Kember. All rights reserved.
//

import UIKit

class StartUpViewController: UIViewController {

    var courses: [Course] = []
    @IBOutlet weak var numCourses: UILabel!
    @IBOutlet weak var overallAverage: UILabel!
    @IBOutlet weak var median: UILabel!
    @IBOutlet weak var gpaLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if let savedCourses = loadCourses() {
            courses += savedCourses
        }
        updateLabels()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Functions
    
    func loadCourses() -> [Course]? {
        print("StartUpViewController: Loading courses...")
        return (NSKeyedUnarchiver.unarchiveObject(withFile: Course.ArchiveURL.path) as? [Course])
    }
    
    func updateLabels() {
        numCourses.text = "\(courses.count)"
        let average = getOverallAverage()
        if (average != -1.0) {
            overallAverage.text = "\(round(10*average*100)/10)%"
            gpaLabel.text = getGPA(average: average*100)
        }
        else {
            overallAverage.text = "N/A"
            gpaLabel.text = "N/A"
        }
    }
    
    func getGPA(average: Double) -> String {
        print("")
        if (average > 100.0) {
            return "4.00"
        }
        else if (average <= 100.0 && average >= 90.0) {
            return "4.00"
        }
        else if (average < 90.0 && average >= 85.0) {
            return "3.90"
        }
        else if (average < 85.0 && average >= 80.0) {
            return "3.70"
        }
        else if (average < 80.0 && average >= 77.0) {
            return "3.30"
        }
        else if (average < 77.0 && average >= 73.0) {
            return "3.00"
        }
        else if (average < 73.0 && average >= 70.0) {
            return "2.70"
        }
        else if (average < 70.0 && average >= 67.0) {
            return "2.30"
        }
        else if (average < 67.0 && average >= 63.0) {
            return "2.00"
        }
        else if (average < 63.0 && average >= 60.0) {
            return "1.70"
        }
        else if (average < 60.0 && average >= 57.0) {
            return "1.30"
        }
        else if (average < 57.0 && average >= 53.0) {
            return "1.00"
        }
        else if (average < 53.0 && average >= 50.0) {
            return "0.70"
        }
        else {
            return "0.00"
        }
    }
    
    func getMedian() {
        
    }
    
    func getOverallAverage() -> Double {
        print("StartUpViewController: getOverallAverage -> Entry")
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
        if (average <= 100.0) {
            return average
        }
        else {
            return 1
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
