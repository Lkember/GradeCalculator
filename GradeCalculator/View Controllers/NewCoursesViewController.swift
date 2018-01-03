//
//  NewCoursesViewController.swift
//  GradeCalculator
//
//  Created by Logan Kember on 2016-07-26.
//  Copyright © 2016 Logan Kember. All rights reserved.
//

import UIKit

class NewCoursesViewController: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    // MARK: - Properties
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var index = -1
    var course: Course = Course()
    @IBOutlet weak var courseName: UITextField!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var groupSelection: UIPickerView!
    @IBOutlet weak var courseIsComplete: UISwitch!
    @IBOutlet weak var gradeField: UITextField!
    @IBOutlet weak var gradeOutOfField: UITextField!
    @IBOutlet weak var gradeView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var activeField: UITextField?
    
    
    // MARK: - Navigation
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        return checkInput()
    }
    
    override func viewDidLoad() {
        print("NewCourses: viewDidLoad")
        super.viewDidLoad()
        
        self.courseName.delegate = self
        self.gradeField.delegate = self
        self.gradeOutOfField.delegate = self
        
        self.navigationController?.navigationBar.barStyle = UIBarStyle.black
        self.groupSelection.delegate = self
        self.groupSelection.dataSource = self
        self.groupSelection.layer.cornerRadius = 10
        self.groupSelection.layer.borderWidth = 1
        self.groupSelection.layer.borderColor = UIColor.white.cgColor
        
        self.courseIsComplete.isOn = false
        self.isComplete(courseIsComplete)
        
        if index != -1 {
            groupSelection.selectRow(index, inComponent: 0, animated: true)
        }
        else {
            groupSelection.selectRow(getIndexForGroup(withName: "Ungrouped Courses"), inComponent: 0, animated: true)
        }
        
        // Adding listeners for when a text field changes
        courseName.addTarget(self, action: #selector(NewCoursesViewController.textFieldDidChange(_:)), for: UIControlEvents.editingChanged)
        gradeField.addTarget(self, action: #selector(NewCoursesViewController.textFieldDidChange(_:)), for: UIControlEvents.editingChanged)
        gradeOutOfField.addTarget(self, action: #selector(NewCoursesViewController.textFieldDidChange(_:)), for: UIControlEvents.editingChanged)
        saveButton.isEnabled = false
        
        // Adding listeners for when the keyboard shows or hides
        NotificationCenter.default.addObserver(self, selector: #selector(NewCoursesViewController.keyboardToggle(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(NewCoursesViewController.keyboardToggle(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        // Remove observer for keyboard
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    
    // MARK: Actions
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func isComplete(_ sender: UISwitch) {
        if sender.isOn {
            UIView.animate(withDuration: 0.3, delay: 0.0, options: UIViewAnimationOptions.curveEaseOut, animations: {
                self.gradeView.alpha = 1.0
            }, completion: nil)
        }
        else {
            UIView.animate(withDuration: 0.3, delay: 0.0, options: UIViewAnimationOptions.curveEaseOut, animations: {
                self.gradeView.alpha = 0.0
            }, completion: nil)
        }
        textFieldDidChange(courseName)
    }
    
    
    // MARK: Functions
    func getIndexForGroup(withName: String) -> Int {
        for i in 0..<appDelegate.groups.count {
            if appDelegate.groups[i].groupName == withName {
                return i
            }
        }
        return -1
    }
    
    // Mark: UITextFieldDelegate
    func textFieldDidChange(_ textField: UITextField) {
        let text = courseName.text ?? ""
        print("NewCourses: textFieldDidChange: Current text = \(text)")
        if text == "" {
            saveButton.isEnabled = false
            return
        }
        else {
            if (courseIsComplete.isOn) {
                if let _ = Double(gradeField.text!), let _ = Double(gradeOutOfField.text!) {
                    saveButton.isEnabled = true
                }
                else {
                    saveButton.isEnabled = false
                    return
                }
            }
            for group in appDelegate.groups {
                if group.doesCourseNameExist(courseName: textField.text!) {
                    saveButton.isEnabled = false
                    return
                }
            }
            saveButton.isEnabled = true
        }
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeField = textField
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        activeField = nil
    }
    
    func checkInput() -> Bool {
        var check = false
        let courseInput = self.courseName.text ?? ""
        for group in appDelegate.groups {
            check = group.doesCourseNameExist(courseName: courseInput)
            if check {
                return false
            }
        }
        
        course = Course(courseName: courseInput)!
        return true
    }
    
    // MARK: UIPickerViewDataSource
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return appDelegate.groups.count
    }
    
    // Returning white text
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        return NSAttributedString(string: appDelegate.groups[row].groupName, attributes: [NSForegroundColorAttributeName : UIColor.white])
    }
    
    // MARK: - Listeners
    func keyboardToggle(_ notification: Notification) {
        self.scrollView.isScrollEnabled = true
        let userInfo = notification.userInfo!
        
        let keyboardSize = (userInfo[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue.size
        let contentInsets : UIEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, keyboardSize!.height, 0.0)
        
        self.scrollView.contentInset = contentInsets
        self.scrollView.scrollIndicatorInsets = contentInsets
        
        var aRect : CGRect = self.view.frame
        aRect.size.height -= keyboardSize!.height
        
        if let activeField = self.activeField {
            if (!aRect.contains(activeField.frame.origin)){
                self.scrollView.scrollRectToVisible(activeField.frame, animated: true)
            }
        }
    }
    
    
    // MARK: UITextFieldDelegate
    //TODO
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        textField.resignFirstResponder()
//    }
    
}
