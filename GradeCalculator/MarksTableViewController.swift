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
    @IBOutlet weak var remainingWeight: UILabel!
    @IBOutlet weak var staticPotentialMark: UILabel!
    @IBOutlet weak var potentialMark: UILabel!

    var index = -1
    var courseIndex = -1
    var groups: [Group] = []
    var course = Course(courseName: "")
    var courseName = ""
    
    // MARK: Views
    // When the view loads, perform the following
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("MarksTable: viewDidLoad -> Entry: courseName=\(courseName)")
        
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
            
            // If user is editing a row
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                
                print("MarksTable: unwindToProjectList: Editing a row")
                let i = selectedIndexPath.row
                
                if svc.projectIsComplete.isOn == true {
                
                    print("MarksTable: undwindToProjectList: projectName: \(svc.projectName), grade: \(svc.projectGrade), out of: \(svc.projectOutOf), weight: \(svc.projectWeight)")
                    course!.projects[i] = svc.projectName
                    course!.projectMarks[i] = svc.projectGrade
                    course!.projectWeights[i] = svc.projectWeight
                    course!.projectOutOf[i] = svc.projectOutOf
                    tableView.reloadRows(at: [selectedIndexPath], with: .fade)
                }
                else {
                    print("MarksTable: undwindToProjectList: projectName: \(svc.projectName), grade: -1.0, out of: -1.0, weight: \(svc.projectWeight)")
                    course!.projects[i] = svc.projectName
                    course!.projectMarks[i] = -1.0
                    course!.projectWeights[i] = svc.projectWeight
                    course!.projectOutOf[i] = -1.0
                    tableView.reloadRows(at: [selectedIndexPath], with: .fade)
                }
                
            }
            // If user is adding a new row
            else {
                print("MarksTable: undwindToProjectList: Adding a new row")
                
                let newIndexPath = IndexPath(row: course!.projects.count, section: 0)
                
                if svc.projectGrade == -1.0 {
                    print("MarksTable: undwindToProjectList: Adding project \(svc.projectName), grade: -1.0, outOf: -1.0, weight: \(svc.projectWeight)")
                    course?.addProject(svc.projectName, grade: -1.0, outOf: -1.0, weight: svc.projectWeight)
                }
                else {
                    print("MarksTable: undwindToProjectList: Adding project \(svc.projectName), grade \(svc.projectGrade), outOf \(svc.projectOutOf), weight \(svc.projectWeight)")
                    course?.addProject(svc.projectName, grade: svc.projectGrade, outOf: svc.projectOutOf, weight: svc.projectWeight)
                }
                
                tableView.insertRows(at: [newIndexPath], with: .bottom)
            }
            
            print("MarksTable: unwindToProjectList: Adding course to group.")
            groups[index].courses[courseIndex] = course!
        }
        
        save()
        updateLabels()
        print("MarksTable: unwindToProjectList -> Exit")
    }
    
    @IBAction func deleteFromProjectList(_ sender: UIStoryboardSegue) {
        print("MarksTable: deleteFromProjectList -> Entry")
        if let selectedIndexPath = tableView.indexPathForSelectedRow {
            print("MarksTable: deleteFromProjectList: deleting \(course!.projects[(selectedIndexPath as NSIndexPath).row])")
            course!.projects.remove(at: (selectedIndexPath as NSIndexPath).row)
            course!.projectWeights.remove(at: (selectedIndexPath as NSIndexPath).row)
            course!.projectMarks.remove(at: (selectedIndexPath as NSIndexPath).row)
        }
        tableView.reloadData()
        updateLabels()
        print("MarksTable: deleteFromProjectList -> Exit")
    }
    
    
    @IBAction func changeGroupAction(_ sender: AnyObject) {
        let popOverView = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PopUpView") as! PopUpViewController
        self.addChildViewController(popOverView)
        
        popOverView.groups = self.groups
        popOverView.index = self.index
        popOverView.courseIndex = self.courseIndex
        
        popOverView.view.frame = self.view.frame
        self.view.addSubview(popOverView.view)
        popOverView.didMove(toParentViewController: self)
    }
    
    
    @IBAction func renameGroupAction(_ sender: UIBarButtonItem) {
        editCourseTitle()
    }
    
    func editCourseTitle() {
        print("CourseTableView: editActionsForRowAt: User selected edit")
        var alertController: UIAlertController
        
        alertController = UIAlertController(title: "Editing Course: \(self.courseName)", message: "", preferredStyle: UIAlertControllerStyle.alert)
        
            let saveAction = UIAlertAction(title: "Save", style: UIAlertActionStyle.default, handler: {
                (action: UIAlertAction!) -> Void in
                
                let courseNameField = alertController.textFields![0] as UITextField
                
                if (courseNameField.text! != "") {
                    self.groups[self.index].courses[self.courseIndex].courseName = courseNameField.text!
                    self.save()
                    self.title = courseNameField.text!
                }
                
                self.setEditing(false, animated: true)
            });
        
            let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: {
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
        if (self.index == -1) {
            print("MarksTable: viewDidLoad: index is -1")
            for i in 0..<groups.count {
                courseIndex = groups[i].findIndexInCourseList(course: courseName)
                if courseIndex != -1 {
                    index = i
                    break
                }
            }
            
            self.course = groups[index].courses[courseIndex]
            print("MarksTable: viewDidLoad: Found. User clicked \(groups[index].courses[courseIndex].courseName)")
        }
        else {
            courseIndex = groups[index].findIndexInCourseList(course: courseName)
            self.course = groups[index].courses[courseIndex]
            self.navigationItem.title = courseName
            
            print("MarksTable: viewDidLoad: index is \(index), courseIndex is \(courseIndex)")
            print("MarksTableView: viewDidLoad: Exit")
        }
    }
    
    
    func updateLabels() {
        print("MarksTable: updateLabels: Updating Labels")
        let average = (round(10*course!.getAverage()*100)/10)
        if (average != -100.0) {
            averageLabel.text = "\(average)%"
        }
        else {
            averageLabel.text = "N/A"
        }
        
        numMarks.text = "\(course!.getNumMarks())"
        let weight = course!.getWeightTotal()
        let activeWeight = course!.getActiveWeightTotal()
        
        if (weight <= 100 && weight >= 0) {
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
                potentialMark.text = "\((round(10*potential!*100)/10))%"
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
        
        cell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
        
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        print("GroupsTable: commit editingStyle -> Entry")
        if editingStyle == .delete {
            
            course?.deleteAtRow(row: indexPath.row)
            groups[index].courses[courseIndex] = course!
            
            tableView.deleteRows(at: [indexPath], with: .fade)
            
            tableView.reloadData()
            updateLabels()
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
        save()
        print("GroupsTable: commit editingStyle -> Exit")
    }
    
    
    //Allow the rearranging of cells
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        print("MarksTable: tableView moveRowAt -> Entry: \nprojects = \(course?.projects.count)\nprojectMarks = \(course?.projectMarks.count)\nprojectOutOf = \(course?.projectOutOf.count)\nprojectWeight = \(course?.projectWeights.count)")
        var index = sourceIndexPath.row
        let tempProject = course?.projects[index]
        let tempProjectMark = course?.projectMarks[index]
        let tempProjectOutOf = course?.projectOutOf[index]
        let tempProjectWeight = course?.projectWeights[index]
        
        
        if sourceIndexPath.row < destinationIndexPath.row {
            while (index < destinationIndexPath.row) {
                course!.projects[index] = course!.projects[index+1]
                course!.projectMarks[index] = course!.projectMarks[index+1]
                course!.projectOutOf[index] = course!.projectOutOf[index+1]
                course!.projectWeights[index] = course!.projectWeights[index+1]
                index += 1
            }
        }
        else {
            while (index > destinationIndexPath.row) {
                course!.projects[index] = course!.projects[index-1]
                course!.projectMarks[index] = course!.projectMarks[index-1]
                course!.projectOutOf[index] = course!.projectOutOf[index-1]
                course!.projectWeights[index] = course!.projectWeights[index-1]
                index -= 1
            }
        }
        
        course!.projects[destinationIndexPath.row] = tempProject!
        course!.projectMarks[destinationIndexPath.row] = tempProjectMark!
        course!.projectOutOf[destinationIndexPath.row] = tempProjectOutOf!
        course!.projectWeights[destinationIndexPath.row] = tempProjectWeight!
        
        print("index=\(index), courseIndex=\(courseIndex)")
        groups[self.index].courses[courseIndex] = course!
        updateLabels()
        save()
        print("MarksTable: tableView moveRowAt -> Exit")
    }
    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "EditItem") {
            print("MarksTable: User selected a cell.")
            let courseDVC = segue.destination as! AddProjectViewController
            courseDVC.navigationItem.title = self.courseName
            courseDVC.saveButton.isEnabled = true
            
            self.navigationController?.setToolbarHidden(true, animated: true)
            
            if let selectedCell = sender as? MarksViewCell {
                let indexPath = tableView.indexPath(for: selectedCell)!
                let selectedProject = course?.projects[(indexPath as NSIndexPath).row]
                
                print("MarksTable: User selected \(selectedProject!)")
                print("MarksTable: project grade: \(course?.projectMarks[indexPath.row]) out of \(course?.projectOutOf[indexPath.row])")
                
                courseDVC.projectName = selectedProject!
                courseDVC.projectWeight = (course?.projectWeights[(indexPath as NSIndexPath).row])!
                courseDVC.projectGrade = (course?.projectMarks[(indexPath as NSIndexPath).row])!
                courseDVC.projectOutOf = (course?.projectOutOf[(indexPath as NSIndexPath).row])!
            }
            
        } else if (segue.identifier == "AddItem") {
            print("MarksTable: User selected add button.")
            print("MarksTable: Setting title to \(self.courseName)")
            let courseDVC = segue.destination.childViewControllers[0] as! AddProjectViewController
            courseDVC.saveButton.isEnabled = false
            courseDVC.courseName = self.courseName
            
            self.navigationController?.setToolbarHidden(true, animated: true)
        }
    
    }
    
    // MARK: NSCoding
    
    func save() {
        print("MarksTabe: save: Saving courses and groups.")
        if (!NSKeyedArchiver.archiveRootObject(self.groups, toFile: Group.ArchiveURL.path)) {
            print("CourseTable: save: Failed to save courses and groups.")
        }
    }
    
    // Load user information
    func load() -> [Group] {
        print("MarksTable: Load: Loading courses.")
        return (NSKeyedUnarchiver.unarchiveObject(withFile: Group.ArchiveURL.path) as! [Group])
    }
}
