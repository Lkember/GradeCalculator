//
//  StartUpViewController.swift
//  GradeCalculator
//
//  Created by Logan Kember on 2016-09-29.
//  Copyright © 2016 Logan Kember. All rights reserved.
//

import UIKit

class StartUpViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var groups = Group()
    var courses: [Course] = []
    @IBOutlet weak var numCourses: UILabel!
    @IBOutlet weak var overallAverage: UILabel!
    @IBOutlet weak var median: UILabel!
    @IBOutlet weak var gpaLabel: UILabel!
    @IBOutlet weak var bestClass: UILabel!
    @IBOutlet weak var bestClassMark: UILabel!
    @IBOutlet weak var worstClass: UILabel!
    @IBOutlet weak var worstClassMark: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.allowsSelection = false
        
        if let loadedData = load() {
            groups = loadedData
        }
        
        if let courseData = loadCourses() {
            courses = courseData
        }
        
        // Used if data is lost from iPhone
//        print("courses.count = \(courses.count), groups.courses.count = \(groups.courses.count)")
//        if groups.courses.count < courses.count {
//            groups.courses = courses
//            groups.group["Ungrouped Courses"] = courses
//            save()
//        }
        
        print("StartUpView: viewDidLoad: # keys \(groups.keys.count), # courses \(groups.courses.count)")
        
//        updateLabels()
        tableView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        print("StartUpView: viewDidAppear: loading courses again.")
        
        if let loadedData = load() {
            groups = loadedData
        }
        
//        updateLabels()
        tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Functions
    
    func load() -> Group? {
        print("StartUpViewController: load: Loading groups and courses.")
        return (NSKeyedUnarchiver.unarchiveObject(withFile: Group.ArchiveURL.path) as? Group)
    }
    
    @IBAction func unwindToDetailViewController(storyboard: UIStoryboardSegue) {
        print("StartUpView: unwindToDetailViewController: -> Entry")
        let sourceVC = storyboard.source as? GroupsTableViewController
        
        self.groups = (sourceVC?.groups)!
        
        save()
    }
    
//    func updateLabels() {
//        numCourses.text = "\(groups.courses.count)"
//        let average = getOverallAverage()
//        let median = getMedian()
//        let bestworstclasses = getBestAndWorstMarks()
//        if (average != -1.0) {
//            bestClass.text = bestworstclasses[0].courseName
//            bestClassMark.text = "\(round(10*bestworstclasses[0].getAverage()*100)/10)%"
//            worstClass.text = bestworstclasses[1].courseName
//            worstClassMark.text = "\(round(10*bestworstclasses[1].getAverage()*100)/10)%"
//            overallAverage.text = "\(round(10*average*100)/10)%"
//            gpaLabel.text = getGPA(average: average*100)
//            self.median.text = "\(round(10*median*100)/10)%"
//        }
//        else {
//            bestClassMark.text = "N/A"
//            bestClass.text = "N/A"
//            worstClass.text = "N/A"
//            worstClassMark.text = "N/A"
//            overallAverage.text = "N/A"
//            gpaLabel.text = "N/A"
//            self.median.text = "N/A"
//        }
//    }
    
    func getGPA(average: Double) -> String {
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
    
    func getBestAndWorstMarks() -> [Course] {
        print("StartUpViewController: getBestAndWorstMarks -> Entry")
        if (groups.courses.count == 0) {
            return []
        }
        
        var worst: Course = groups.courses[0]
        var best: Course = groups.courses[0]
        var worstGrade = groups.courses[0].getAverage()
        var bestGrade = groups.courses[0].getAverage()
        
        for course in groups.courses {
            let average = course.getAverage()
            if ((average < worstGrade) && (average != -1.0)) {
                worstGrade = average
                worst = course
            }
            if (average > bestGrade) {
                bestGrade = average
                best = course
            }
        }
        print("StartUpViewController: getBestAndWorstMarks -> Exit")
        return [best, worst]
    }
    
    func getMedian() -> Double {
        print("StartUpViewController: getMedian -> Entry")
        var marks: [Double] = []
        for i in 0..<groups.courses.count {
            let currMark = groups.courses[i].getAverage()
            if (currMark != -1.0) {
                marks.append(groups.courses[i].getAverage())
            }
        }
        
        if marks.count == 0 {
            print("StartUpViewController: getMedian -> Exit marks.count=0")
            return -1.0
        }
        
        marks.sort()
        print("StartUpViewController: getMedian size of marks array \(marks.count)")
        
        // if marks.count is even
        if (marks.count % 2 == 0) {
            let mid = marks.count/2
            print("StartUpViewController: getMedian -> Exit marks.count even. At index \(mid)")
            return (marks[mid] + marks[mid-1])/2
        }
        //marks.count is odd
        else {
            print("StartUpViewController: getMedian -> Exit marks.count odd. At index \(marks.count/2)")
            return marks[marks.count/2]
        }
    }
    
    func getOverallAverage() -> Double {
        print("StartUpViewController: getOverallAverage -> Entry")
        var average = 0.0
        var courseMark = 0.0
        var numCourses = 0
        
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
        if (average <= 100.0) {
            return average
        }
        else {
            return 1
        }
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if (segue.identifier == "groupViewSegue") {
            print("StartUpView: prepare: going to groupView")
            let destView = segue.destination.childViewControllers[0] as? GroupsTableViewController
            destView?.groups = self.groups
        }
        else if (segue.identifier == "allCoursesSegue") {
            let destView = segue.destination.childViewControllers[0] as? CourseTableViewController
            destView?.dictionaryKey = ""
        }
    }
    
    // MARK: - TableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //TODO
        if section == 0 {
            print("StartUpView: numberOfRowsInSection: Section 0 has 6 rows")
            return 6
        }
        else if section == 1 {
            print("StartUpView: numberOfRowsInSection: Section 1 has \(groups.keys.count) rows")
            return groups.keys.count
        }
        print("StartUpView: numberOfRowsInSection: This print statement should not be printed.")
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //TODO
        let identifier = "RightDetailCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier)
        let average = getOverallAverage()
        
        if (indexPath.section == 0) {
            switch indexPath.row {
            case 0:
                cell?.textLabel?.text = "Number of Courses:"
                cell?.detailTextLabel?.text = "\(groups.courses.count)"
                break
                
            case 1:
                cell?.textLabel?.text = "Average:"
                
                if (average != -1.0) {
                    cell?.detailTextLabel?.text = "\(round(10*average*100)/10)%"
                }
                else {
                    cell?.detailTextLabel?.text = "N/A"
                }
                break
                
            case 2:
                cell?.textLabel?.text = "Median:"
                
                if (average != -1.0) {
                    cell?.detailTextLabel?.text = "\(round(10*getMedian()*100)/10)%"
                }
                else {
                    cell?.detailTextLabel?.text = "N/A"
                }
                
                break
                
            case 3:
                cell?.textLabel?.text = "GPA (Approximate):"
                
                if (average != -1.0) {
                    cell?.detailTextLabel?.text = "\(getGPA(average: average*100))"
                }
                else {
                    cell?.detailTextLabel?.text = "N/A"
                }
                
                break
                
            case 4:
                cell?.textLabel?.text = "Best Mark:"
                if (average == -1.0) {
                    cell?.detailTextLabel?.text = "N/A"
                }
                
                let bestAndWorst = getBestAndWorstMarks()
                cell?.detailTextLabel?.text = "\(round(10*bestAndWorst[0].getAverage()*100)/10)%"
                break
                
            case 5:
                let bestAndWorst = getBestAndWorstMarks()
                cell?.textLabel?.text = "Worst Class:"
                cell?.detailTextLabel?.text = "\(round(10*bestAndWorst[1].getAverage()*100)/10)%"
                break
            default:
                break
            }
        }
        else {
            print("StartUpView: cellForRowAt: Currently looking at row: \(indexPath.row)")
            cell?.textLabel?.text = "\(groups.keys[indexPath.row]) Average:"
            let groupAverage = round(10*groups.getGroupAverage(key: groups.keys[indexPath.row])*100)/10
            if groupAverage == -100.0 {
                cell?.detailTextLabel?.text = "N/A"
            }
            else {
                cell?.detailTextLabel?.text = "\(groupAverage)%"
            }
        }
        return cell!
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if (section == 0) {
            return "All Courses"
        }
        else {
            return "Group Details"
        }
    }
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        // cell selected code here
//    }

    
    // MARK: - NSCoding
    func save() {
        print("StartUpView: save: Saving courses and groups.")
        if (!NSKeyedArchiver.archiveRootObject(self.groups, toFile: Group.ArchiveURL.path)) {
            print("StartUpView: save: Failed to save courses and groups.")
        }
    }
    
    func loadCourses() -> [Course]? {
        print("GroupsTable: load: Loading courses.")
        return (NSKeyedUnarchiver.unarchiveObject(withFile: Course.ArchiveURL.path) as! [Course])
    }
}
