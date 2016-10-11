//
//  AddGroupViewController.swift
//  GradeCalculator
//
//  Created by Logan Kember on 2016-10-07.
//  Copyright © 2016 Logan Kember. All rights reserved.
//

import UIKit

class AddGroupViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {

    // MARK: - Attributes
    var groups: [String: [Course]] = [:]
    var courses: [Course] = []
    @IBOutlet weak var groupName: UITextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var doneButton: UIBarButtonItem!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        groupName.delegate = self
        
        tableView.allowsSelectionDuringEditing = true
        tableView.allowsMultipleSelectionDuringEditing = true
        tableView.isEditing = true
        
        doneButton.isEnabled = false
        
        for course in groups["Ungrouped Courses"]! {
            print("Appending \(course.courseName)")
            courses.append(course)
        }
        
        tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - Functions
    @IBAction func doneClicked(_ sender: UIBarButtonItem) {
        
    }
    
    @IBAction func cancelClicked(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }

    func checkTextFieldInput(input: String) {
        print("checkInput -> Entry")
        let input = groupName.text! + input
        
        print("input == \(input)")
        if (input == "") {
            print("checkInput -> False")
            doneButton.isEnabled = false
        }
        else if (groups[input]?.count != nil) {
            doneButton.isEnabled = false
        }
        else {
            print("checkInput -> True")
            doneButton.isEnabled = true
        }
        
    }
    
    // MARK: - TableViewDelegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("AddGroupProject: numberOfRowsInSection = \(courses.count)")
        return courses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "CoursesCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath as IndexPath)
        
        cell.textLabel?.text = courses[indexPath.row].courseName
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // cell selected code here
    }
    
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cellIdentifier = "GroupCell"
//        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
//
//        let groupName = groupNames[indexPath.row]
//        
//        cell.textLabel?.text = groupName
//        cell.detailTextLabel?.text = "Number of courses in group: \(groups[groupName]!.count)"
//        
//        cell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
//        
//        return cell
//    }

    // MARK: - TextFieldDelegate
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        checkTextFieldInput(input: string)
        return true
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
