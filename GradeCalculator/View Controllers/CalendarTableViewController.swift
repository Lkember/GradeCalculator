//
//  CalendarTableViewController.swift
//  GradeCalculator
//
//  Created by Logan Kember on 2018-01-11.
//  Copyright © 2018 Logan Kember. All rights reserved.
//

import UIKit

// MARK: - Structures

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


// MARK: - Class

class CalendarTableViewController: UITableViewController {

    // MARK: - Properties
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var allProjects: UpcomingDates = UpcomingDates.init()
    var upcomingProjectIndexes: UpcomingDates = UpcomingDates.init()
    var selectedProject: CourseInfo? = nil
    var selectedProjectCompletion: Bool = false
    var showCompletedProjects: Bool = false
    @IBOutlet weak var toggleCompletedProjectsButton: UIButton!
    
    // MARK: - View
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationController?.navigationBar.barStyle = UIBarStyle.black
        
        getUpcomingDueDates()
        
        if (allProjects.sortedKeys.count == upcomingProjectIndexes.sortedKeys.count) {
            toggleCompletedProjectsButton.isEnabled = false
        }
        else {
            toggleCompletedProjectsButton.isEnabled = true
        }
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
                        allProjects.addDate(courseInfo: courseInfo, date: project.dueDate[projectIndex]!)
                        
                        // If the course is complete, add it to the upcoming projects
                        if (!course[courseIndex].projectIsComplete(index: projectIndex)) {
                            upcomingProjectIndexes.addDate(courseInfo: courseInfo, date: project.dueDate[projectIndex]!)
                        }
                    }
                }
            }
        }
        
        upcomingProjectIndexes.sortDates()
        allProjects.sortDates()
    }
    
    @IBAction func toggleCompletedProjects(_ sender: Any) {
        if let button = sender as? UIButton {
            if (showCompletedProjects) {
                button.setTitle("Show Completed Projects", for: .normal)
                showCompletedProjects = false
            }
            else {
                button.setTitle("Hide Completed Projects", for: .normal)
                showCompletedProjects = true
            }
            
            tableView.reloadData()
        }
    }
    
    // MARK: - Table view data source

    // Gets the number of sections in the table
    override func numberOfSections(in tableView: UITableView) -> Int {
        if (allProjects.sortedKeys.count > upcomingProjectIndexes.sortedKeys.count) {
            if (showCompletedProjects) {
                return allProjects.sortedKeys.count
            }
        }
        
        return upcomingProjectIndexes.sortedKeys.count
    }
    
    // Gets the number of cells in a given section
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (allProjects.sortedKeys.count > upcomingProjectIndexes.sortedKeys.count) {
            if (showCompletedProjects) {
                let dates = allProjects.sortedKeys
                return allProjects.dates[dates[section]]!.count
            }
        }
        
        let dates = upcomingProjectIndexes.sortedKeys
        return upcomingProjectIndexes.dates[dates[section]]!.count
    }
    
    // Gets the cell for the current row
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = indexPath.section
        let row = indexPath.row
        let cell = tableView.dequeueReusableCell(withIdentifier: "UpcomingProjectCell", for: indexPath)
        
        if (allProjects.sortedKeys.count > upcomingProjectIndexes.sortedKeys.count) {
            if (showCompletedProjects) {
                let currDate = allProjects.sortedKeys[section]
                let currCourse = allProjects.dates[currDate]![row]
                
                let courseName = currCourse.course.courseName
                let projectName = currCourse.course.projects[currCourse.projectIndex]
                
                cell.textLabel!.text = "\(courseName) - \(projectName)"
                cell.detailTextLabel!.text = "Weight : \(currCourse.course.projectWeights[currCourse.projectIndex])%"
                
                // TODO: Set cell transparency to show the project is complete
                return cell
            }
        }
        
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
        
        if (allProjects.sortedKeys.count > upcomingProjectIndexes.sortedKeys.count) {
            if (showCompletedProjects) {
                return date.string(from: allProjects.sortedKeys[section])
            }
        }
        
        return date.string(from: upcomingProjectIndexes.sortedKeys[section])
    }

    
    // MARK: - Navigation
    
    @IBAction func unwindToProjectList(_ sender: UIStoryboardSegue) {
        print("\(String(describing: self)): \(#function): Editing a row")
        if let svc = sender.source as? AddProjectViewController {
            if selectedProject != nil {
                
                let index = self.tableView.indexPathForSelectedRow
                
                // Update any data that is required to be set
                selectedProject!.course.projects[selectedProject!.projectIndex] = svc.projectName
                selectedProject!.course.projectWeights[selectedProject!.projectIndex] = svc.projectWeight
                if (svc.hasDueDateSwitch.isOn) {
                    selectedProject!.course.dueDate[selectedProject!.projectIndex] = svc.dueDatePicker.date
                }
                else {
                    selectedProject!.course.dueDate[selectedProject!.projectIndex] = nil
                }
                
                // If the project is complete
                if svc.projectIsComplete.isOn {
                    selectedProject!.course.projectMarks[selectedProject!.projectIndex] = svc.projectGrade
                    selectedProject!.course.projectOutOf[selectedProject!.projectIndex] = svc.projectOutOf
                }
                else {
                    selectedProject!.course.projectMarks[selectedProject!.projectIndex] = -1.0
                    selectedProject!.course.projectOutOf[selectedProject!.projectIndex] = -1.0
                }
                
                // Update tableView
                if (index != nil) {
                    tableView.reloadRows(at: [index!], with: .fade)
                }
                else {
                    tableView.reloadData()
                }
                
                appDelegate.groups[selectedProject!.groupIndex].courses[selectedProject!.courseIndex] = selectedProject!.course
                appDelegate.save()
            }
        }
        print("\(String(describing: self)): \(#function): Exit")
    }
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if (segue.identifier == "ViewDueProjectSegue") {
            let destView = segue.destination as! AddProjectViewController
            var index = self.tableView.indexPath(for: sender as! UITableViewCell)
            var currDate = upcomingProjectIndexes.sortedKeys[index!.section]
            
            if (allProjects.sortedKeys.count > upcomingProjectIndexes.sortedKeys.count && showCompletedProjects) {
                currDate = allProjects.sortedKeys[index!.section]
                selectedProject = allProjects.dates[currDate]![index!.row]
            }
            else {
                selectedProject = upcomingProjectIndexes.dates[currDate]![index!.row]
            }
            
            let course = appDelegate.groups[selectedProject!.groupIndex].courses[selectedProject!.courseIndex]
            destView.courseName = course.courseName
            destView.projectName = course.projects[selectedProject!.projectIndex]
            destView.projectWeight = course.projectWeights[selectedProject!.projectIndex]
            destView.projectGrade = course.projectMarks[selectedProject!.projectIndex]
            destView.projectOutOf = course.projectOutOf[selectedProject!.projectIndex]
            destView.dueDateSelected = course.dueDate[selectedProject!.projectIndex]
            destView.isDateSet = true
        }
    }
}
