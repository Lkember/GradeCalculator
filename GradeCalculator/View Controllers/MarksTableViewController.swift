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
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    @IBOutlet weak var averageLabel: UILabel!
    @IBOutlet weak var numMarks: UILabel!
    @IBOutlet weak var remainingWeight: UILabel!
    @IBOutlet weak var staticPotentialMark: UILabel!
    @IBOutlet weak var potentialMark: UILabel!
    
    var groupIndex = -1
    var courseIndex = -1
//    var groups: [Group] = []
    var course = Course(courseName: "")
    var courseName = ""
    
    // MARK: Views
    // When the view loads, perform the following
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("MarksTable: viewDidLoad -> Entry: courseName=\(courseName)")
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
        updateAttributes()
        tableView.rowHeight = 60.0
        tableView.setEditing(false, animated: false)
        
        //Add an edit button to the top right of the nav controller
        self.navigationItem.rightBarButtonItems?.append(self.editButtonItem)
        
        //Setting toolbar and nav bar to black, and setting the toolbar to always be viewable
        self.navigationController?.setToolbarHidden(false, animated: true)
        self.navigationController?.navigationBar.barStyle = UIBarStyle.black
        self.navigationController?.toolbar.barStyle = UIBarStyle.black
        
        if (self.navigationController?.isToolbarHidden)! {
            self.navigationController?.setToolbarHidden(false, animated: true)
        }
        
        updateLabels()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        print("MarksTable: viewDidAppear -> Entry: courseName=\(courseName)")
        
        tableView.isScrollEnabled = true
        tableView.setEditing(false, animated: false)
        
        if (self.navigationController?.isToolbarHidden)! {
            self.navigationController?.setToolbarHidden(false, animated: true)
        }
        
        updateAttributes()
        updateLabels()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    
    // MARK: Actions
    @IBAction func unwindToProjectList(_ sender: UIStoryboardSegue) {
        print("MarksTable: unwindToProjectList -> Entry")
        if let svc = sender.source as? AddProjectViewController {
            
            // Getting the date selected
            var date: Date? = nil
            if (svc.hasDueDateSwitch.isOn) {
                date = svc.dueDatePicker.date
            }
            else {
                date = nil
            }
            
            // If user is editing a row
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                
                print("MarksTable: unwindToProjectList: Editing a row")
                let i = selectedIndexPath.row
                
                if svc.projectIsComplete.isOn {
                    course!.setProjectName(index: i, value: svc.project.name)
                    course!.setProjectMark(index: i, value: svc.project.mark)
                    course!.setProjectWeight(index: i, value: svc.project.weight)
                    course!.setProjectOutOf(index: i, value: svc.project.outOf)
                    course!.setProjectDueDate(index: i, value: date)
                    course!.setIsComplete(index: i, value: true)
                    
                    tableView.reloadRows(at: [selectedIndexPath], with: .fade)
                }
                else {
                    course!.setProjectName(index: i, value: svc.project.name)
                    course!.setProjectMark(index: i, value: -1.0)
                    course!.setProjectWeight(index: i, value: svc.project.weight)
                    course!.setProjectOutOf(index: i, value: -1.0)
                    course!.setProjectDueDate(index: i, value: date)
                    course!.setIsComplete(index: i, value: false)
                    
                    tableView.reloadRows(at: [selectedIndexPath], with: .fade)
                }
                
            }
            // If user is adding a new row
            else {
                let newIndexPath = IndexPath(row: course!.projects.count, section: 0)
                
                if svc.project.mark == -1.0 {
                    course?.addProject(svc.project.name, grade: -1.0, outOf: -1.0, weight: svc.project.weight, newDueDate: date, isComplete: svc.projectIsComplete.isOn)
                }
                else {
                    course?.addProject(svc.project.name, grade: svc.project.mark, outOf: svc.project.outOf, weight: svc.project.weight, newDueDate: date, isComplete: svc.projectIsComplete.isOn)
                }
                
                tableView.insertRows(at: [newIndexPath], with: .bottom)
            }
            
            print("MarksTable: unwindToProjectList: Adding course to group.")
            appDelegate.groups[groupIndex].courses[courseIndex] = course!
        }
        
        appDelegate.save()
        updateLabels()
        print("MarksTable: unwindToProjectList -> Exit")
    }
    
    @IBAction func deleteFromProjectList(_ sender: UIStoryboardSegue) {
        print("MarksTable: deleteFromProjectList -> Entry")
        if let selectedIndexPath = tableView.indexPathForSelectedRow {
            print("MarksTable: deleteFromProjectList: deleting \(course!.projects[(selectedIndexPath as NSIndexPath).row])")
            course!.projects.remove(at: (selectedIndexPath as NSIndexPath).row)
        }
        tableView.reloadData()
        updateLabels()
        print("MarksTable: deleteFromProjectList -> Exit")
    }
    
    
    @IBAction func changeGroupAction(_ sender: AnyObject) {
        let popOverView = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PopUpView") as! PopUpViewController
        self.addChild(popOverView)
        
        tableView.isScrollEnabled = false
        
        popOverView.index = self.groupIndex
        popOverView.courseIndex = self.courseIndex
        
        popOverView.view.frame = self.view.frame
        self.view.addSubview(popOverView.view)
//        popOverView.didMove(toParentViewController: self)
    }
    
    
    @IBAction func renameGroupAction(_ sender: UIBarButtonItem) {
        editCourseTitle()
    }
    
    func editCourseTitle() {
        print("CourseTableView: editActionsForRowAt: User selected edit")
        var alertController: UIAlertController
        
        alertController = UIAlertController(title: "Editing Course: \(self.courseName)", message: "", preferredStyle: UIAlertController.Style.alert)
        
            let saveAction = UIAlertAction(title: "Save", style: UIAlertAction.Style.default, handler: {
                (action: UIAlertAction!) -> Void in
                
                let courseNameField = alertController.textFields![0] as UITextField
                
                if (courseNameField.text! != "") {
                    self.appDelegate.groups[self.groupIndex].courses[self.courseIndex].courseName = courseNameField.text!
                    self.courseName = courseNameField.text!
                    self.title = courseNameField.text!
                    self.appDelegate.save()
                }
                
                self.setEditing(false, animated: true)
            });
        
            let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: {
                (action: UIAlertAction!) -> Void in
                self.setEditing(false, animated: true)
                // do nothing
            });
        
            alertController.addTextField(configurationHandler: { (textField : UITextField!) -> Void in

            textField.text = self.courseName
            
        });
        
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }

    
    // A function which updates the index of the current course
    func updateAttributes() {
        print("MarksTable: updateAttributes -> Entry: Value of index=\(self.groupIndex): courseName=\(self.courseName)")
        if (self.groupIndex == -1) {
            for i in 0..<appDelegate.groups.count {
                courseIndex = appDelegate.groups[i].findIndexInCourseList(course: courseName)
                if courseIndex != -1 {
                    groupIndex = i
                    break
                }
            }
            
            self.course = appDelegate.groups[groupIndex].courses[courseIndex]
            print("MarksTable: updateAttributes: Found. User clicked \(appDelegate.groups[groupIndex].courses[courseIndex].courseName)")
        }
        else {
            courseIndex = appDelegate.groups[groupIndex].findIndexInCourseList(course: courseName)
            print("MarksTable: updateAttributes: course index is \(courseIndex)")
            self.course = appDelegate.groups[groupIndex].courses[courseIndex]
            self.navigationItem.title = courseName
            
            print("MarksTable: updateAttributes: index is \(groupIndex), courseIndex is \(courseIndex)")
        }
        print("MarksTableView: updateAttributes: Exit")
    }
    
    
    func updateLabels() {
        print("MarksTable: updateLabels: Updating Labels")
        let average = (course!.getAverage())
        if (average != -1.0) {
            averageLabel.text = "\(average)%"
        }
        else {
            averageLabel.text = "N/A"
        }
        
        numMarks.text = "\(course!.getNumMarks())"
        let weight = course!.getWeightTotal()
        let activeWeight = course!.getActiveWeightTotal()
        
        if (weight <= 100.0 && weight >= 0.0) {
            remainingWeight.textColor = UIColor.white
            remainingWeight.text = "\(100.0-weight)%"

            if activeWeight >= 100 {
                potentialMark.isHidden = true
                staticPotentialMark.isHidden = true
            }
            else if (activeWeight <= 0) {
                potentialMark.text = "100.0%"
                potentialMark.isHidden = false
                staticPotentialMark.isHidden = false
                }
            else {
                let potential = course?.getPotentialMark()
                potentialMark.text = "\(potential!)%"
                potentialMark.isHidden = false
                staticPotentialMark.isHidden = false
            }
        }
        else {
            remainingWeight.textColor = UIColor.red
            remainingWeight.text = "\(100.0-weight)"
        }
    }
    
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (course?.projects.count)!
    }
    
    //Setting the title of the section in the table
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if (section == 0) {
            return "Mark List"
        }
        return ""
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "MarksViewCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! MarksViewCell
        
        if (course?.projects.count != 0) {
            
            cell.projectNameLabel.text = course?.projects[(indexPath as NSIndexPath).row].name
            
            if (course!.getProjectMark(index: indexPath.row) != -1.0) {
                let mark = course!.getProjectMark(index: indexPath.row)
                cell.markLabel.text = "\(mark)%"
            }
            else {
                cell.markLabel.text = "N/A"
            }
            
            cell.weightLabel.text = "\(course!.getProjectWeight(index: indexPath.row))%"
            
            if (cell.markLabel.isHidden) {
                cell.markLabel.isHidden = false
                cell.weightLabel.isHidden = false
                cell.staticWeightLabel.isHidden = false
                cell.staticMarkLabel.isHidden = false
            }
        }
        
        cell.accessoryType = UITableViewCell.AccessoryType.disclosureIndicator
        
        let view = UIView()
        view.backgroundColor = UIColor.init(red: 0, green: 139/255, blue: 1, alpha: 1)
        cell.selectedBackgroundView = view
        
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        print("GroupsTable: commit editingStyle -> Entry")
        if editingStyle == .delete {
            
            course?.deleteAtRow(row: indexPath.row)
            appDelegate.groups[groupIndex].courses[courseIndex] = course!
            
            tableView.deleteRows(at: [indexPath], with: .fade)
            
            tableView.reloadData()
            updateLabels()
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
        appDelegate.save()
        print("GroupsTable: commit editingStyle -> Exit")
    }
    
    
    //Allow the rearranging of cells
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        print("MarksTable: tableView moveRowAt -> Entry: \nprojects = \(String(describing: course?.projects.count))")
        var index = sourceIndexPath.row
        let tempProject = course!.projects[index]
        
        if sourceIndexPath.row < destinationIndexPath.row {
            while (index < destinationIndexPath.row) {
                course!.projects[index] = course!.projects[index+1]
                index += 1
            }
        }
        else {
            while (index > destinationIndexPath.row) {
                course!.projects[index] = course!.projects[index-1]
                index -= 1
            }
        }
        
        course!.projects[destinationIndexPath.row] = tempProject
        
        appDelegate.groups[self.groupIndex].courses[courseIndex] = course!
        updateLabels()
        appDelegate.save()
        print("MarksTable: tableView moveRowAt -> Exit")
    }
    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "EditItem") {
            
            let courseDVC = segue.destination as! AddProjectViewController
            courseDVC.navigationItem.title = self.courseName
            courseDVC.saveButton.isEnabled = true
            
            self.navigationController?.setToolbarHidden(true, animated: true)
            
            if let selectedCell = sender as? MarksViewCell {
                let indexPath = tableView.indexPath(for: selectedCell)!
                let selectedProject = course?.projects[(indexPath as NSIndexPath).row]
                
                courseDVC.project = selectedProject!
            }
            
        } else if (segue.identifier == "AddItem") {
            let courseDVC = segue.destination.children[0] as! AddProjectViewController
            courseDVC.saveButton.isEnabled = false
            courseDVC.courseName = self.courseName
            
            self.navigationController?.setToolbarHidden(true, animated: true)
        }
    
    }
}
