//
//  AddProjectViewController.swift
//  GradeCalculator
//
//  Created by Logan Kember on 2016-08-10.
//  Copyright © 2016 Logan Kember. All rights reserved.
//

import UIKit

class AddProjectViewController: UIViewController, UITextFieldDelegate {

    // MARK - Attributes
    @IBOutlet weak var projectNameField: UITextField!
    @IBOutlet weak var projectIsComplete: UISwitch!
    @IBOutlet weak var weightField: UITextField!
    @IBOutlet weak var gradeView: UIView!
    @IBOutlet weak var gradeField: UITextField!
    @IBOutlet weak var gradeOutOfField: UITextField!
    @IBOutlet weak var outOfLabel: UILabel!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var deleteProjectButton: UIButton!
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet weak var dueDateView: UIView!
    @IBOutlet weak var hasDueDateSwitch: UISwitch!
    @IBOutlet weak var dueDatePicker: UIDatePicker!
    @IBOutlet weak var projectDueDateLabel: UILabel!
    @IBOutlet weak var dueDateViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var gradeViewTopConstraint: NSLayoutConstraint!
    
    var activeField: UITextField?
    var project: Project = Project.init()
    var editorMode = false
    var courseName = ""
    
    // MARK: - Views
    
    override func viewDidLoad() {
        print("\(type(of: self)) > viewDidLoad > Entry")
        super.viewDidLoad()
        
        // Setting delegates
        self.projectNameField.delegate = self
        self.weightField.delegate = self
        self.gradeField.delegate = self
        self.gradeOutOfField.delegate = self
        
        // Adding listeners for when the keyboard shows or hides
        NotificationCenter.default.addObserver(self, selector: #selector(AddProjectViewController.keyboardToggle(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(AddProjectViewController.keyboardToggle(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        // Adding listener for when any of the text fields are edited
        projectNameField.addTarget(self, action: #selector(AddProjectViewController.textFieldDidChange(_textField:)), for: UIControl.Event.editingChanged)
        weightField.addTarget(self, action: #selector(AddProjectViewController.textFieldDidChange(_textField:)), for: UIControl.Event.editingChanged)
        gradeField.addTarget(self, action: #selector(AddProjectViewController.textFieldDidChange(_textField:)), for: UIControl.Event.editingChanged)
        gradeOutOfField.addTarget(self, action: #selector(AddProjectViewController.textFieldDidChange(_textField:)), for: UIControl.Event.editingChanged)
        
        // Used since there is a black background
        self.scrollView.indicatorStyle = .white
        dueDatePicker.setValue(UIColor.white, forKeyPath: "textColor")
        
        print("\(type(of: self)) > viewDidLoad > Exit")
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        print("\(type(of: self)) > viewWillAppear > Entry")
        
        // Updating UI
        deleteProjectButton.layer.cornerRadius = 10
        self.navigationController?.navigationBar.barStyle = UIBarStyle.black
        
        if (courseName != "") {
            self.title = courseName
        }
        
        if (self.project.getWeight() != -1.0 || self.project.name != "") {
            editorMode = true
            
            self.projectNameField?.text = "\(self.project.name)"
            self.weightField?.text = "\(self.project.weight)"
            
            if (project.isComplete) {
                if (project.mark == -1.0) {
                    self.gradeField?.text = ""
                }
                else {
                    self.gradeField?.text = "\(self.project.mark)"
                }
                
                if (project.outOf == -1.0) {
                    self.gradeOutOfField.text = "100"
                }
                else {
                    self.gradeOutOfField?.text = "\(self.project.outOf)"
                }
                
                projectIsComplete.isOn = true
            }
            else {
                projectIsComplete.isOn = false
                isComplete(projectIsComplete)
            }
            
            // If the date is set then make the picker show that date, otherwise close it
            if (project.dueDate != nil) {
                hasDueDateSwitch.isOn = true
                dueDatePicker.date = project.dueDate!
            }
            else {
                hasDueDateSwitch.isOn = false
                hasDueDateNoAnimation()
            }
        }
        else {
            self.deleteProjectButton.isHidden = true
            hasDueDateSwitch.isOn = false
            hasDueDateNoAnimation()
        }
        self.viewDidLayoutSubviews()
        
        print("\(type(of: self)) > viewWillAppear > Exit")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        // Remove observer for keyboard
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: - Actions
    @IBAction func cancelView(_ sender: UIBarButtonItem) {
        print("AddProject: Ending view")
        if (!editorMode) {
            dismiss(animated: true, completion: nil)
        }
        else {
             _ = self.navigationController?.popViewController(animated: true)
        }
    }
    
    
    // When the user specifies they have a mark, then show grade else hide
    @IBAction func isComplete(_ sender: UISwitch) {
        print("\(type(of: self)) > \(#function)")
        if sender == self.projectIsComplete {
            let deleteButtonFrame = self.deleteProjectButton.frame
            let gradeViewFrame = self.gradeView.frame
            let dueDateViewFrame = self.dueDateView.frame
            let dueDateLabelFrame = self.projectDueDateLabel.frame
            let dueDateSwitchFrame = self.hasDueDateSwitch.frame
            
            if sender.isOn {
                UIView.animate(withDuration: 0.3, delay: 0.0, options: UIView.AnimationOptions.curveEaseOut, animations: {
                    self.gradeViewTopConstraint.constant += gradeViewFrame.height
                    self.gradeView.alpha = 1.0
                    
                    self.deleteProjectButton.frame = CGRect(x: deleteButtonFrame.origin.x,
                                                            y: deleteButtonFrame.origin.y + gradeViewFrame.height,
                                                            width: deleteButtonFrame.width,
                                                            height: deleteButtonFrame.height)

                    self.projectDueDateLabel.frame = CGRect(x: dueDateLabelFrame.origin.x,
                                                            y: dueDateLabelFrame.origin.y + gradeViewFrame.height,
                                                            width: dueDateLabelFrame.width,
                                                            height: dueDateLabelFrame.height)

                    self.hasDueDateSwitch.frame = CGRect(x: dueDateSwitchFrame.origin.x,
                                                         y: dueDateSwitchFrame.origin.y + gradeViewFrame.height,
                                                         width: dueDateSwitchFrame.width,
                                                         height: dueDateSwitchFrame.height)

                    self.dueDateView.frame = CGRect(x: dueDateViewFrame.origin.x,
                                                    y: dueDateViewFrame.origin.y + gradeViewFrame.height,
                                                    width: dueDateViewFrame.width,
                                                    height: dueDateViewFrame.height)
                    
                }, completion: nil)
            }
            else {
                UIView.animate(withDuration: 0.3, delay: 0.0, options: UIView.AnimationOptions.curveEaseOut, animations: {
                    self.gradeView.alpha = 0.0
                    
                    self.deleteProjectButton.frame = CGRect(x: deleteButtonFrame.origin.x,
                                                            y: deleteButtonFrame.origin.y - gradeViewFrame.height,
                                                            width: deleteButtonFrame.width,
                                                            height: deleteButtonFrame.height)

                    self.projectDueDateLabel.frame = CGRect(x: dueDateLabelFrame.origin.x,
                                                            y: dueDateLabelFrame.origin.y - gradeViewFrame.height,
                                                            width: dueDateLabelFrame.width,
                                                            height: dueDateLabelFrame.height)

                    self.hasDueDateSwitch.frame = CGRect(x: dueDateSwitchFrame.origin.x,
                                                         y: dueDateSwitchFrame.origin.y - gradeViewFrame.height,
                                                         width: dueDateSwitchFrame.width,
                                                         height: dueDateSwitchFrame.height)

                    self.dueDateView.frame = CGRect(x: dueDateViewFrame.origin.x,
                                                    y: dueDateViewFrame.origin.y - gradeViewFrame.height,
                                                    width: dueDateViewFrame.width,
                                                    height: dueDateViewFrame.height)
                    
                }, completion: {(finished: Bool) in
                    self.gradeViewTopConstraint.constant -= gradeViewFrame.height
                });
            }
        }
    }
    
    // Called when the date is not set, it sets the constraints without using an animation
    func hasDueDateNoAnimation() {
        let deleteButtonFrame = self.deleteProjectButton.frame
        let dueDateFrame = self.dueDateView.frame
        
        self.dueDateView.alpha = 0.0
        self.deleteProjectButton.frame = CGRect(x: deleteButtonFrame.origin.x,
                                                y: deleteButtonFrame.origin.y - dueDateFrame.height,
                                                width: deleteButtonFrame.width,
                                                height: deleteButtonFrame.height)
        self.dueDateViewTopConstraint.constant -= dueDateFrame.height
    }
    
    // Updates the constraints when the dueDate switch is used
    @IBAction func hasDueDate(_ sender: UISwitch) {
        print("\(type(of: self)) > \(#function)")
        if sender == self.hasDueDateSwitch {
            let deleteButtonFrame = self.deleteProjectButton.frame
            let dueDateFrame = self.dueDateView.frame
            
            if sender.isOn {
                UIView.animate(withDuration: 0.3, delay: 0.0, options: UIView.AnimationOptions.curveEaseOut, animations: {
                    self.dueDateViewTopConstraint.constant += dueDateFrame.height
                    self.dueDateView.alpha = 1.0
                    self.deleteProjectButton.frame = CGRect(x: deleteButtonFrame.origin.x,
                                                            y: deleteButtonFrame.origin.y + dueDateFrame.height,
                                                            width: deleteButtonFrame.width,
                                                            height: deleteButtonFrame.height)
                    
                }, completion: nil)
            }
            else {
                
                UIView.animate(withDuration: 0.3, delay: 0.0, options: UIView.AnimationOptions.curveEaseOut, animations: {
                    self.dueDateView.alpha = 0.0
                    self.deleteProjectButton.frame = CGRect(x: deleteButtonFrame.origin.x,
                                                            y: deleteButtonFrame.origin.y - dueDateFrame.height,
                                                            width: deleteButtonFrame.width,
                                                            height: deleteButtonFrame.height)
                    
                }, completion: {(finished : Bool) in
                    self.dueDateViewTopConstraint.constant -= dueDateFrame.height
                });
            }
        }
    }
    
    @IBAction func deleteProject(_ sender: UIButton) {
        let alertController = UIAlertController(title: "Delete Project", message: "Are you sure you want to delete this project?", preferredStyle: UIAlertController.Style.alert)
        alertController.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
        
        alertController.addAction(UIAlertAction(title: "Delete", style: UIAlertAction.Style.destructive, handler: { action in
            
            self.performSegue(withIdentifier: "deleteProject", sender: self)
        }))
        
        self.present(alertController, animated: true, completion: nil)
    }

    // MARK: - Function
    
    // Function which checks the to make sure all fields are completed
    func checkInput() -> Bool {
        if (projectNameField.text == "" || weightField.text == "" || !checkMarkAndWeightInput()) {
            return false
        }
        else {
            project.name = projectNameField.text!
            if let weight = Double(weightField.text!) {
                project.weight = weight
            }
            else {
                return false
            }
        }
        
        if (projectIsComplete.isOn) {
            project.isComplete = true
            
            if (Double(gradeOutOfField.text!) == 0.0 || !checkMarkAndWeightInput())
            {
                return false
            }
            else {
                if (gradeField.text != "") {
                    if let grade = Double(gradeField.text!) {
                        project.mark = grade
                    }
                    else {
                        return false
                    }
                }
                else {
                    project.mark = -1.0
                }
                
                if (gradeOutOfField.text != "") {
                    project.outOf = Double(gradeOutOfField.text!)!
                }
                else {
                    project.outOf = -1.0
                }
            }

        }
        else {
            project.isComplete = false
        }
        return true
    }
    
    func checkMarkAndWeightInput() -> Bool {
        if (projectIsComplete.isOn) {
            print("AddProject: checkMarkInput Entry")
            let grade = gradeField.text
            let weight = weightField.text
            var numDecimals = 0
            var numDecimals2 = 0
            
            // Number of decimal places in the mark field
            if (grade != nil) {
                for char in grade! {
                    if (char == ".") {
                        numDecimals += 1
                    }
                }
            }
            
            // Number of decimals in the weight field
            if (weight != nil) {
                for char in weight! {
                    if (char == ".") {
                        numDecimals2 += 1
                    }
                }
            }
            
            if (numDecimals < 2 && numDecimals2 < 2) {
                print("AddProject: checkMarkInput Exit -> Success")
                return true
            }
            print("AddProject: checkMarkInput Exit -> Incorrect input")
            return false
        }
        
        return true
    }
    
    
    // MARK: - TextField
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @objc func textFieldDidChange(_textField: UITextField) {
        print("AddProject: textFieldDidChange -> Entry")
        if (checkInput()) {
            saveButton.isEnabled = true
            return
        }
        saveButton.isEnabled = false
    }
    
    // MARK: - Navigation

    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        return checkInput()
    }

    // MARK: - Listeners
    @objc func keyboardToggle(_ notification: Notification) {
        print("\(type(of: self)) > \(#function)")
        self.scrollView.isScrollEnabled = true
        let userInfo = notification.userInfo!
        
        let keyboardSize = (userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue.size
        let contentInsets : UIEdgeInsets = UIEdgeInsets.init(top: 0.0, left: 0.0, bottom: keyboardSize!.height, right: 0.0)
        
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
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeField = textField
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        activeField = nil
    }
    
    @IBAction func projectIsCompleteToggle(_ sender: UISwitch) {
        if (checkInput()) {
            saveButton.isEnabled = true
            return
        }
        
        saveButton.isEnabled = false
    }
}


