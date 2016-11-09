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
    var groups: [Group] = []
    @IBOutlet weak var groupName: UITextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        groupName.delegate = self
        
        tableView.layer.cornerRadius = 10
        tableView.layer.borderColor = UIColor.black.cgColor
        tableView.layer.borderWidth = 1
        
        tableView.allowsSelectionDuringEditing = true
        tableView.allowsMultipleSelectionDuringEditing = true
        tableView.isEditing = true
        self.navigationController?.navigationBar.barStyle = UIBarStyle.black
        
        saveButton.isEnabled = false
        
        tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: - Functions
    
    @IBAction func cancelClicked(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }

    func checkTextFieldInput(input: String) {
        print("AddGroupView: checkInput -> Entry \(input)")
        
        if (input == "") {
            print("checkInput -> False: input is empty")
            saveButton.isEnabled = false
        }
        else if (!checkEntryHelper(input: input)) {
            print("AddGroupView: checkInput -> False a group with that name already exists")
            saveButton.isEnabled = false
        }
        else {
            print("AddGroupView: checkInput -> True")
            saveButton.isEnabled = true
        }
    }
    
    // Is used to check if a groupName already exists
    func checkEntryHelper(input: String) -> Bool {
        for group in groups {
            if (input == group.groupName) {
                return false
            }
        }
        return true
    }
    
    
    // Returns the index for a group with a given name
    func getIndexForGroup(withName: String) -> Int {
        for i in 0..<groups.count {
            if (groups[i].groupName == withName) {
                return i
            }
        }
        return -1
    }
    
    
    // MARK: - TableViewDelegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("AddGroupProject: numberOfRowsInSection = \(groups[getIndexForGroup(withName: "Ungrouped Courses")].courses.count)")
        return groups[getIndexForGroup(withName: "Ungrouped Courses")].courses.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "CoursesCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath as IndexPath)
        
        cell.textLabel?.text = groups[getIndexForGroup(withName: "Ungrouped Courses")].courses[indexPath.row].courseName
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // cell selected code here
    }

    // MARK: - TextFieldDelegate
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let text = (textField.text ?? "") as NSString
        let resultString = text.replacingCharacters(in: range, with: string)
        
        checkTextFieldInput(input: resultString)
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        // Get the new view controller using segue.destinationViewController.
//        // Pass the selected object to the new view controller.
//        print("AddGroup: prepare: Preparing for Segue")
//        save()
//    }

    
    // MARK: - NSCoding
//    func save() {
//        print("AddGroupView: save: Saving courses and groups.")
//        if (!NSKeyedArchiver.archiveRootObject(self.groups, toFile: Group.ArchiveURL.path)) {
//            print("AddGroupView: save: Failed to save courses and groups.")
//        }
//    }
    
}
