//
//  StartUpViewController.swift
//  GradeCalculator
//
//  Created by Logan Kember on 2016-09-29.
//  Copyright © 2016 Logan Kember. All rights reserved.
//

import UIKit

class StartUpViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    @IBOutlet weak var tableView: UITableView!
    var courses = [Course]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        self.navigationController?.setToolbarHidden(true, animated: true)
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.allowsSelection = true
        
        if let loadedData = appDelegate.load() {
            appDelegate.groups = loadedData
        }
        
        if appDelegate.groups.count == 0 {
            appDelegate.groups.append(Group.init(groupName: "Ungrouped Courses", courses: [Course]()))
        }
        
        // Used if data is lost from iPhone
        // Can be removed when ready for release
//        if let courseData = loadCourses() {
//            courses = courseData
//        }
//
//        print("courses.count = \(courses.count), appDelegate.groups.courses.count = \(appDelegate.groups.courses.count)")
//        if appDelegate.groups.courses.count < courses.count {
//            appDelegate.groups.courses = courses
//            appDelegate.groups.group["Ungrouped Courses"] = courses
//            save()
//        }
        
        getAllCourses()
        print("StartUpView: viewDidLoad: Number of courses \(courses.count)")
        
//        updateLabels()
        tableView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        print("StartUpView: viewDidAppear: reloading courses.")
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        self.navigationController?.setToolbarHidden(true, animated: true)
        
        if let loadedData = appDelegate.load() {
            appDelegate.groups = loadedData
        }
        
//        updateLabels()
        getAllCourses()
        tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    
    // MARK: Functions
    
    @IBAction func unwindToDetailViewController(storyboard: UIStoryboardSegue) {
        print("StartUpView: unwindToDetailViewController: -> Entry")
        let sourceVC = storyboard.source as? GroupsTableViewController
        
        self.appDelegate.groups = (sourceVC?.appDelegate.groups)!
        
        appDelegate.save()
    }

    
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
        if (courses.count == 0) {
            return []
        }
        
        var worst: Course = courses[0]
        var best: Course = courses[0]
        var worstGrade = 9999999.0
        var bestGrade = -1.0
        
        for course in courses {
            let average = course.getAverage()
            if ((average < worstGrade) && (average >= 0.0)) {
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
        for i in 0..<courses.count {
            let currMark = courses[i].getAverage()
            if (currMark != -1.0) {
                marks.append(courses[i].getAverage())
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
        
        for course in courses {
            courseMark = course.getAverage()
            if courseMark != -1.0 {
                average += courseMark
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
    
    func getAllCourses() {
        var tempCourses: [Course] = []
        for group in appDelegate.groups {
            tempCourses += group.courses
        }
        self.courses = tempCourses
    }
    
    func getIndexForGroup(nameOfGroup: String) -> Int {
        for i in 0..<appDelegate.groups.count {
            if appDelegate.groups[i].groupName == nameOfGroup {
                return i
            }
        }
        return -1
    }
    
    
    // MARK: - Navigation

    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if let cell = sender as? UITableViewCell {
            if (cell.selectionStyle == UITableViewCellSelectionStyle.none) {
                return false
            }
            else {
                return true
            }
            
        }
        else {
            return true
        }
    }
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if (segue.identifier == "groupViewSegue") {
            print("StartUpView: prepare: going to groupView")
            let destView = segue.destination as? GroupsTableViewController
            destView?.appDelegate.groups = self.appDelegate.groups
        }
        else if (segue.identifier == "allCoursesSegue" || segue.identifier == "ShowGroupSegue") {
            
            let destView = segue.destination as? CourseTableViewController
            print("StartUpView: prepare: Going to CourseView")
            
            destView?.appDelegate.groups = self.appDelegate.groups
            
            if let cell = sender as? UITableViewCell {
                let cellLabel = cell.textLabel?.text
                let nameOfGroup = cellLabel?.substring(to: (cellLabel?.index((cellLabel?.endIndex)!, offsetBy: -9))!)
                
                destView?.index = getIndexForGroup(nameOfGroup: nameOfGroup!)
                print("StartUpView: prepare: Sender is a UITableViewCell with groupName=\(String(describing: nameOfGroup)) and index=\(String(describing: destView?.index))")
            }
            else {
                print("StartupView: prepare: Sender is AllCourses button. Setting destView index to -1.")
                destView?.index = -1
            }
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
            print("StartUpView: numberOfRowsInSection: Section 1 has \(appDelegate.groups.count) rows")
            if appDelegate.groups[getIndexForGroup(nameOfGroup: "Ungrouped Courses")].courses.count == 0 {
                return appDelegate.groups.count-1
            }
            else {
                return appDelegate.groups.count
            }
        }
        print("StartUpView: numberOfRowsInSection: This print statement should never be printed.")
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = "RightDetailCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier)
        let average = getOverallAverage()
        
        if (indexPath.section == 0) {
            cell?.selectionStyle = UITableViewCellSelectionStyle.none
            
            switch indexPath.row {
            case 0:
                cell?.textLabel?.text = "Number of Courses:"
                cell?.detailTextLabel?.text = "\(courses.count)"
                break
                
            case 1:
                cell?.textLabel?.text = "Average:"
                
                if (average != -1.0) {
                    cell?.detailTextLabel?.text = "\(round(10*average*100)/10)%"
                }
                else {
                    cell?.detailTextLabel?.text = "N/A"
                }
                
            case 2:
                cell?.textLabel?.text = "Median:"
                
                if (average != -1.0) {
                    cell?.detailTextLabel?.text = "\(round(10*getMedian()*100)/10)%"
                }
                else {
                    cell?.detailTextLabel?.text = "N/A"
                }
                
            case 3:
                cell?.textLabel?.text = "GPA (Approximate):"
                
                if (average != -1.0) {
                    cell?.detailTextLabel?.text = "\(getGPA(average: average*100))"
                }
                else {
                    cell?.detailTextLabel?.text = "N/A"
                }
                
            case 4:
                cell?.textLabel?.text = "Best Mark:"
                if (average == -1.0) {
                    cell?.detailTextLabel?.text = "N/A"
                    break
                }
                
                let bestAndWorst = getBestAndWorstMarks()
                cell?.detailTextLabel?.text = "\(round(10*bestAndWorst[0].getAverage()*100)/10)%"
                
            case 5:
                cell?.textLabel?.text = "Worst Mark:"
                
                if (average == -1.0) {
                    cell?.detailTextLabel?.text = "N/A"
                    break
                }
                
                let bestAndWorst = getBestAndWorstMarks()
                cell?.detailTextLabel?.text = "\(round(10*bestAndWorst[1].getAverage()*100)/10)%"
                
            default:
                break
            }
        }
        else {
            print("StartUpView: cellForRowAt: Currently looking at row: \(indexPath.row)")
            var index = 0
            if (appDelegate.groups[getIndexForGroup(nameOfGroup: "Ungrouped Courses")].courses.count == 0) {
                index = indexPath.row + 1
            }
            else {
                index = indexPath.row
            }
            
            // If the current cell is for Ungrouped Courses, then only put "Ungrouped Average"
            if (appDelegate.groups[index].groupName == "Ungrouped Courses") {
                cell?.textLabel?.text = "Ungrouped Average:"
            }
            else {
                cell?.textLabel?.text = "\(appDelegate.groups[index].groupName) Average:"
            }
            
            cell?.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
            cell?.selectionStyle = UITableViewCellSelectionStyle.blue
            
            let groupAverage = round(10*appDelegate.groups[index].getGroupAverage()*100)/10
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
}
