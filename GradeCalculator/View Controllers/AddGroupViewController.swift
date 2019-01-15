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
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    @IBOutlet weak var groupName: UITextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var tableViewBottomConstraint: NSLayoutConstraint!
    
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
        
        // Adding listeners for when the keyboard shows or hides
        NotificationCenter.default.addObserver(self, selector: #selector(AddGroupViewController.keyboardOpened(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(AddGroupViewController.keyboardClosed(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        saveButton.isEnabled = false
        tableView.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        // Remove observer for keyboard
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        
        view.endEditing(true)
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
        if (input == "") {
            saveButton.isEnabled = false
        }
        else if (!checkEntryHelper(input: input)) {
            saveButton.isEnabled = false
        }
        else {
            saveButton.isEnabled = true
        }
    }
    
    // Is used to check if a groupName already exists
    func checkEntryHelper(input: String) -> Bool {
        for group in appDelegate.groups {
            if (input == group.groupName) {
                return false
            }
        }
        return true
    }
    
    
    // Returns the index for a group with a given name
    func getIndexForGroup(withName: String) -> Int {
        for i in 0..<appDelegate.groups.count {
            if (appDelegate.groups[i].groupName == withName) {
                return i
            }
        }
        return -1
    }
    
    
    // MARK: - TableViewDelegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return appDelegate.groups[getIndexForGroup(withName: "Ungrouped Courses")].courses.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "CoursesCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath as IndexPath)
        
        cell.textLabel?.text = appDelegate.groups[getIndexForGroup(withName: "Ungrouped Courses")].courses[indexPath.row].courseName
        
        let view = UIView()
        view.backgroundColor = UIColor.init(red: 0, green: 139/255, blue: 1, alpha: 1)
        cell.selectedBackgroundView = view
        
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
    
    @objc func keyboardOpened(_ notification: Notification) {
        let info = notification.userInfo!
        let keyboardSize = (info[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue.height
        tableViewBottomConstraint.constant = keyboardSize + 8
        
        let duration: TimeInterval = (info[UIResponder.keyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
        
        UIView.animate(withDuration: duration) { self.view.layoutIfNeeded() }
    }

    @objc func keyboardClosed(_ notification: Notification) {
        let info = notification.userInfo!
        let duration: TimeInterval = (info[UIResponder.keyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
        tableViewBottomConstraint.constant = 8
        
        UIView.animate(withDuration: duration) { self.view.layoutIfNeeded() }
    }
    
}
