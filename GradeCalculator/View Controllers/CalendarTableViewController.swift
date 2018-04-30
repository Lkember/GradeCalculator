//
//  CalendarTableViewController.swift
//  GradeCalculator
//
//  Created by Logan Kember on 2018-01-11.
//  Copyright © 2018 Logan Kember. All rights reserved.
//

import UIKit

struct CourseInfo {
    var course : Course
    var groupIndex : Int
    var courseIndex : Int
    var projectIndex : Int
    
    init(course: Course, g: Int, c: Int, p: Int) {
        self.course = course
        groupIndex = g
        courseIndex = c
        projectIndex = p
    }
}

// A structure to hold the indexes of each project
struct UpcomingDates {
    
    var sortedKeys: [Date] = []
    var dates: Dictionary<Date,[CourseInfo]> = [:]
    
    // Adds the given data to the structure
    mutating func addDate(courseInfo: CourseInfo, date: Date) {
        
        // We want dates to be grouped by only year, month and day, not by time
        let calendar = Calendar.current
        var dComp = DateComponents()
        
        dComp.year = calendar.component(.year, from: date)
        dComp.month = calendar.component(.month, from: date)
        dComp.day = calendar.component(.day, from: date)
        
        let tempDate = Calendar.init(identifier: Calendar.Identifier.gregorian).date(from: dComp)
        
        if (!dates.keys.contains(tempDate!)) {
            dates[tempDate!] = [courseInfo]
        }
        else {
            dates[tempDate!]!.append(courseInfo)
        }
    }
    
    mutating func sortDates() {
        
        // Sort the keys by their dates
        sortedKeys = dates.keys.sorted(by: { date1,date2 in
            return date1 < date2
        })
    }
}


class CalendarTableViewController: UITableViewController {

    // MARK: - Properties
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var upcomingProjectIndexes: UpcomingDates = UpcomingDates.init()
    
    // MARK: - View
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationController?.navigationBar.barStyle = UIBarStyle.black
        
        getUpcomingDueDates()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        let views = self.navigationController!.viewControllers
        
        if (views.count > 2 && views[views.count-2] == self.navigationController) {
            // Nothing to do
        }
        else if (!views.contains(self) && !(views[views.count-1] is GroupsTableViewController)) {
            // If the current view is being removed
            self.navigationController?.setNavigationBarHidden(true, animated: true)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Calendar
    
    // Gets all the upcoming due dates and sorts them
    func getUpcomingDueDates() {
        
        // Loop through the groups
        let groups = appDelegate.groups
        
        for groupIndex in 0..<groups.count {

            // Loop through the courses within the group
            let course = groups[groupIndex].courses
            for courseIndex in 0..<course.count {

                // Loop through the projects within the course
                let project = course[courseIndex]
                for projectIndex in 0..<project.projects.count {

                    // If the project has a given due date, add it to the list
                    if (project.dueDate[projectIndex] != nil) {
                        
                        let courseInfo = CourseInfo.init(course: project, g: groupIndex, c: courseIndex, p: projectIndex)
                        
                        upcomingProjectIndexes.addDate(courseInfo: courseInfo, date: project.dueDate[projectIndex]!)
                    }
                }
            }
        }
        
        upcomingProjectIndexes.sortDates()
    }
    
    // MARK: - Table view data source

    // Gets the number of sections in the table
    override func numberOfSections(in tableView: UITableView) -> Int {
        return upcomingProjectIndexes.sortedKeys.count
    }
    
    // Gets the number of cells in a given section
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let dates = upcomingProjectIndexes.sortedKeys
        return upcomingProjectIndexes.dates[dates[section]]!.count
    }
    
    // Gets the cell for the current row
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UpcomingProjectCell", for: indexPath)
        
        let section = indexPath.section
        let row = indexPath.row
        
        let currDate = upcomingProjectIndexes.sortedKeys[section]
        let currCourse = upcomingProjectIndexes.dates[currDate]![row]
        
        let courseName = currCourse.course.courseName
        let projectName = currCourse.course.projects[currCourse.projectIndex]
        
        cell.textLabel!.text = "\(courseName) - \(projectName)"
        cell.detailTextLabel!.text = "Weight : \(currCourse.course.projectWeights[currCourse.projectIndex])%"

        return cell
    }
    
    // Gets the title for the header
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let date = DateFormatter()
        date.dateStyle = .full
        date.timeStyle = .none
        
        return date.string(from: upcomingProjectIndexes.sortedKeys[section])
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        
    }
 

}
