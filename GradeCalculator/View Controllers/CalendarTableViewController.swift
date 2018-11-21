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
    
    mutating func resetObject() {
        sortedKeys = []
        dates = [:]
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
    @IBOutlet weak var toggleCompletedProjectsButton: UIBarButtonItem!
    
    // MARK: - View
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        let views = self.navigationController!.viewControllers
        
        if (!views.contains(self) && !(views[views.count-1] is GroupsTableViewController)) {
            // If the current view is being removed
            self.navigationController?.setNavigationBarHidden(true, animated: true)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        displayData()
        tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func displayData() {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationController?.navigationBar.barStyle = UIBarStyle.black
        
        getUpcomingDueDates()
        
        if (allProjects.sortedKeys.count == upcomingProjectIndexes.sortedKeys.count) {
            self.navigationController?.setToolbarHidden(true, animated: true)
            toggleCompletedProjectsButton.isEnabled = false
        }
        else {
            toggleCompletedProjectsButton.isEnabled = true
            self.navigationController?.setToolbarHidden(false, animated: true)
        }
    }
    
    // MARK: - Calendar
    
    // Gets all the upcoming due dates and sorts them
    func getUpcomingDueDates() {
        
        // Need to reset the objects, otherwise dates will continue to be added on every reload
        upcomingProjectIndexes.resetObject()
        allProjects.resetObject()
        
        // Loop through the groups
        let groups = appDelegate.groups
        
        for groupIndex in 0..<groups.count {

            // Loop through the courses within the group
            let courses = groups[groupIndex].courses
            for courseIndex in 0..<courses.count {

                // Loop through the projects within the course
                let course = courses[courseIndex]
                for projectIndex in 0..<course.projects.count {

                    // If the project has a given due date, add it to the list
                    if (course.projects[projectIndex].dueDate != nil) {
                        
                        let courseInfo = CourseInfo.init(course: course, g: groupIndex, c: courseIndex, p: projectIndex)
                        allProjects.addDate(courseInfo: courseInfo, date: course.projects[projectIndex].dueDate!)
                        
                        // If the course is complete, add it to the upcoming projects
                        if (!course.projectIsComplete(index: projectIndex)) {
                            upcomingProjectIndexes.addDate(courseInfo: courseInfo, date: course.projects[projectIndex].dueDate!)
                        }
                    }
                }
            }
        }
        
        upcomingProjectIndexes.sortDates()
        allProjects.sortDates()
    }
    
    @IBAction func toggleCompletedProjects(_ sender: Any) {
        if let button = sender as? UIBarButtonItem {
            if (showCompletedProjects) {
                button.title = "Show Completed Projects"
                showCompletedProjects = false
            }
            else {
                button.title = "Hide Completed Projects"
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
        let currDate = Date.init(timeIntervalSinceNow: 0)
        
        if (allProjects.sortedKeys.count > upcomingProjectIndexes.sortedKeys.count) {
            if (showCompletedProjects) {
                let projectDueDate = allProjects.sortedKeys[section]
                let currCourse = allProjects.dates[projectDueDate]![row]
                
                let courseName = currCourse.course.courseName
                let projectName = currCourse.course.projects[currCourse.projectIndex].name
                
                if (currCourse.course.projectIsComplete(index: currCourse.projectIndex)) {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "CompletedProjectCell") as! CompletedProjectTableViewCell
                    
                    let mark = currCourse.course.getProjectMark(index: currCourse.projectIndex)
                    let weight = currCourse.course.projects[currCourse.projectIndex].weight
                    cell.updateCell(projectName: "\(courseName): \(projectName)", mark: mark, weight: weight)
                    cell.setDisabled()
                    
                    let view = UIView()
                    view.backgroundColor = UIColor.init(red: 0, green: 139/255, blue: 1, alpha: 1)
                    cell.selectedBackgroundView = view
                    
                    return cell
                }
                else {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "UpcomingProjectCell", for: indexPath)
                    cell.textLabel!.text = "\(courseName) - \(projectName)"
                    cell.detailTextLabel!.text = "Weight : \(currCourse.course.getProjectWeight(index: currCourse.projectIndex))%"
                    
                    let view = UIView()
                    view.backgroundColor = UIColor.init(red: 0, green: 139/255, blue: 1, alpha: 1)
                    cell.selectedBackgroundView = view
                    
                    // Setting text colour to red
                    var isOverdue = false
                    if (projectDueDate < currDate) {
                        isOverdue = true
                    }
                    if (isOverdue && !currCourse.course.projectIsComplete(index: currCourse.projectIndex)) {
                        cell.textLabel?.textColor = UIColor.red
                        cell.detailTextLabel?.textColor = UIColor.red
                    }
                    
                    return cell
                }
            }
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "UpcomingProjectCell", for: indexPath)
        let projectDueDate = upcomingProjectIndexes.sortedKeys[section]
        let currCourse = upcomingProjectIndexes.dates[projectDueDate]![row]
        let courseName = currCourse.course.courseName
        let projectName = currCourse.course.projects[currCourse.projectIndex].name
        
        cell.textLabel!.text = "\(courseName) - \(projectName)"
        cell.detailTextLabel!.text = "Weight : \(currCourse.course.getProjectWeight(index: currCourse.projectIndex))%"
        
        let view = UIView()
        view.backgroundColor = UIColor.init(red: 0, green: 139/255, blue: 1, alpha: 1)
        cell.selectedBackgroundView = view
        
        // Setting text colour to red
        var isOverdue = false
        if (projectDueDate < currDate) {
            isOverdue = true
        }
        if (isOverdue && !currCourse.course.projectIsComplete(index: currCourse.projectIndex)) {
            cell.textLabel?.textColor = UIColor.red
            cell.detailTextLabel?.textColor = UIColor.red
        }
        
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
                selectedProject!.course.setProjectName(index: selectedProject!.projectIndex, value: svc.project.name)
                selectedProject!.course.setProjectWeight(index: selectedProject!.projectIndex, value: svc.project.weight)
                
                if (svc.hasDueDateSwitch.isOn) {
                    selectedProject!.course.setProjectDueDate(index: selectedProject!.projectIndex, value: svc.dueDatePicker.date)
                }
                else {
                    selectedProject!.course.setProjectDueDate(index: selectedProject!.projectIndex, value: nil)
                }
                
                // If the project is complete
                if svc.projectIsComplete.isOn {
                    selectedProject!.course.setProjectMark(index: selectedProject!.projectIndex, value: svc.project.mark)
                    selectedProject!.course.setProjectOutOf(index: selectedProject!.projectIndex, value: svc.project.outOf)
                }
                else {
                    selectedProject!.course.setProjectMark(index: selectedProject!.projectIndex, value: -1.0)
                    selectedProject!.course.setProjectOutOf(index: selectedProject!.projectIndex, value: -1.0)
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
        
        if (segue.identifier == "ViewDueProjectSegue" || segue.identifier == "ViewCompletedProjectSegue") {
            
            let destView = segue.destination as! AddProjectViewController
            var index = self.tableView.indexPath(for: sender as! UITableViewCell)
            var currDate: Date
            
            if (allProjects.sortedKeys.count > upcomingProjectIndexes.sortedKeys.count && showCompletedProjects) {
                currDate = allProjects.sortedKeys[index!.section]
                selectedProject = allProjects.dates[currDate]![index!.row]
            }
            else {
                currDate = upcomingProjectIndexes.sortedKeys[index!.section]
                selectedProject = upcomingProjectIndexes.dates[currDate]![index!.row]
            }
            
            let course = appDelegate.groups[selectedProject!.groupIndex].courses[selectedProject!.courseIndex]
            destView.courseName = course.courseName
            destView.project = course.projects[selectedProject!.projectIndex]
        }
    }
}
