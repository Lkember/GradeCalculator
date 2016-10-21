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
    var dictionaryKey = ""
    var indexInDictionary = -1
    var indexInCourseList = -1
    var groups: Group = Group()
    var course = Course(courseName: "")
    var courseName = ""
    
    // MARK: Views
    // When the view loads, perform the following
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("MarksTable: viewDidLoad -> Entry: Courses.count=\(groups.courses.count), courseName=\(courseName)")
        
        if (self.dictionaryKey == "") {
            for i in 0..<groups.courses.count {
                if groups.courses[i].courseName == courseName {
                    print("MarksTable: viewDidLoad: Course found at index \(i)")
                    self.course = groups.courses[i]
                    self.indexInCourseList = i
                    self.navigationItem.title = groups.courses[i].courseName
                    break
                }
            }
            var dictAndIndex = groups.getDictionaryAndIndex(course: course!.courseName)
            if (dictAndIndex.count == 1) {
                print("MarksTableView: viewDidLoad: FAILURE THE GROUP/COURSE WAS NOT FOUND.")
            }
            
            dictionaryKey = groups.keys[dictAndIndex[0]]
            indexInDictionary = dictAndIndex[1]
            
            print("MarksTableView: viewDidLoad: The dictionaryKey is \(dictionaryKey) and the indexInDictionary is \(indexInDictionary)")
        }
        else {
            for i in 0..<groups.group[dictionaryKey]!.count {
                if groups.group[dictionaryKey]![i].courseName == courseName {
                    print("MarksTable: Found. User clicked \(groups.group[dictionaryKey]![i].courseName)")
                    self.course = groups.group[dictionaryKey]![i]
                    self.indexInDictionary = i
                    self.navigationItem.title = course!.courseName
                    break
                }
            }
            
            indexInCourseList = groups.findIndexInCourseList(course: course!.courseName)
            
            print("MarksTableView: viewDidLoad: The indexInCourseList is \(indexInCourseList)")
        }
        
        tableView.rowHeight = 60.0
        
        self.navigationController?.setToolbarHidden(false, animated: true)
        self.navigationController?.navigationBar.barStyle = UIBarStyle.black
        self.navigationController?.toolbar.barStyle = UIBarStyle.black
        
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
            
            print("MarksTable: unwindToProjectList: Putting course in course list and dictionary. These values should be equal: \(groups.courses[indexInCourseList].getNumMarks())=\(course?.getNumMarks())")
            groups.courses[indexInCourseList] = course!
            groups.group[dictionaryKey]![indexInDictionary] = course!
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
    
    
    // MARK: - Functions
    @IBAction func editButtonIsClicked(_ sender: UIBarButtonItem) {
        if (self.tableView.isEditing) {
            tableView.setEditing(false, animated: true)
        }
        else {
            tableView.setEditing(true, animated: true)
        }
    }
    
    
    func updateLabels() {
        print("MarksTable: updateLabels")
        let average = (round(10*course!.getAverage()*100)/10)
        if (average != -100.0) {
            averageLabel.text = "\(average)%"
        }
        else {
            averageLabel.text = "N/A"
        }
        
        numMarks.text = "\(course!.getNumMarks())"
        let weight = course!.getWeightTotal()
        
        if (weight <= 100 && weight >= 0) {
            remainingWeight.textColor = UIColor.white
            remainingWeight.text = "\(100.0-weight)%"
            if weight == 100 {
                potentialMark.isHidden = true
                staticPotentialMark.isHidden = true
            }
            else {
                if (average < 0) {
                    potentialMark.text = "100.0%"
                }
                else {
                    let potential = course?.getPotentialMark(currAverage: average/100, weightRemaining: (100-weight)/100)
                    potentialMark.text = "\((round(10*potential!*100)/10))%"
                }
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
        
        cell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
        
        return cell
    }
    
    //Allow the rearranging of cells
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        print("MarksTable: tableView moveRowAt -> Entry")
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
        
        groups.courses[indexInCourseList] = course!
        groups.group[dictionaryKey]![indexInDictionary] = course!
        
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
            let navDVC = segue.destination as! UINavigationController
            print("MarksTable: Setting title to \(self.courseName)")
            let courseDVC = navDVC.visibleViewController as! AddProjectViewController
            courseDVC.courseName = self.courseName
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
    func load() -> Group? {
        print("MarksTable: Load: Loading courses.")
        return (NSKeyedUnarchiver.unarchiveObject(withFile: Group.ArchiveURL.path) as! Group?)
    }
}
