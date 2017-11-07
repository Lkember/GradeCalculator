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
    var projectName = ""
    var projectWeight = -1.0
    var projectGrade = -1.0
    var projectOutOf = -1.0
    var editorMode = false
    var courseName = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setting delegates
        self.projectNameField.delegate = self
        self.weightField.delegate = self
        self.gradeField.delegate = self
        self.gradeOutOfField.delegate = self
        
        // Adding listeners for when the keyboard shows or hides
        NotificationCenter.default.addObserver(self, selector: #selector(AddProjectViewController.keyboardToggle(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(AddProjectViewController.keyboardToggle(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        // Adding listener for when any of the text fields are edited
        projectNameField.addTarget(self, action: #selector(AddProjectViewController.textFieldDidChange(_textField:)), for: UIControlEvents.editingChanged)
        weightField.addTarget(self, action: #selector(AddProjectViewController.textFieldDidChange(_textField:)), for: UIControlEvents.editingChanged)
        gradeField.addTarget(self, action: #selector(AddProjectViewController.textFieldDidChange(_textField:)), for: UIControlEvents.editingChanged)
        gradeOutOfField.addTarget(self, action: #selector(AddProjectViewController.textFieldDidChange(_textField:)), for: UIControlEvents.editingChanged)
        
        deleteProjectButton.layer.cornerRadius = 10
        
        self.navigationController?.navigationBar.barStyle = UIBarStyle.black
        
        // Do any additional setup after loading the view.
        if (courseName != "") {
            self.title = courseName
        }
            
        if (self.projectWeight != -1.0 || self.projectName != "") {
            editorMode = true
            
            print("AddProject: Updating projectName \(projectName), grade: \(projectGrade), outOf: \(projectOutOf) weight: \(projectWeight)")
            self.projectNameField?.text = "\(self.projectName)"
            self.weightField?.text = "\(self.projectWeight)"
            
            if (projectGrade != -1.0) {
                self.gradeField?.text = "\(self.projectGrade)"
                self.gradeOutOfField?.text = "\(self.projectOutOf)"
            }
            else {
                projectIsComplete.isOn = false
                isComplete(projectIsComplete)
            }
        }    
        else {
            self.deleteProjectButton.isHidden = true
        }
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
                UIView.animate(withDuration: 0.3, delay: 0.0, options: UIViewAnimationOptions.curveEaseOut, animations: {
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
                UIView.animate(withDuration: 0.3, delay: 0.0, options: UIViewAnimationOptions.curveEaseOut, animations: {
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
    
    @IBAction func hasDueDate(_ sender: UISwitch) {
        print("\(type(of: self)) > \(#function)")
        if sender == self.hasDueDateSwitch {
            let deleteButtonFrame = self.deleteProjectButton.frame
            let dueDateFrame = self.dueDateView.frame
            
            if sender.isOn {
                UIView.animate(withDuration: 0.3, delay: 0.0, options: UIViewAnimationOptions.curveEaseOut, animations: {
                    self.dueDateViewTopConstraint.constant += dueDateFrame.height
                    self.dueDateView.alpha = 1.0
                    self.deleteProjectButton.frame = CGRect(x: deleteButtonFrame.origin.x,
                                                            y: deleteButtonFrame.origin.y + dueDateFrame.height,
                                                            width: deleteButtonFrame.width,
                                                            height: deleteButtonFrame.height)
                    
                }, completion: nil)
            }
            else {
                
                UIView.animate(withDuration: 0.3, delay: 0.0, options: UIViewAnimationOptions.curveEaseOut, animations: {
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
        let alertController = UIAlertController(title: "Delete Project", message: "Are you sure you want to delete this project?", preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
        
        alertController.addAction(UIAlertAction(title: "Delete", style: UIAlertActionStyle.destructive, handler: { action in
            
            self.performSegue(withIdentifier: "deleteProject", sender: self)
        }))
        
        self.present(alertController, animated: true, completion: nil)
    }

    // MARK: - Function
    
    // Function which checks the to make sure all fields are completed
    func checkInput() -> Bool {
        print("AddProject: CheckInput Entry")
        if (projectNameField.text == "" || weightField.text == "") {
            print("AddProject: CheckInput Exit -> projectName or weight field empty")
            return false
        }
        else {
            projectName = projectNameField.text!
            projectWeight = Double(weightField.text!)!
        }
        
        if (projectIsComplete.isOn) {
            print("AddProject: CheckInput projectIsComplete.isOn -> True")
            if (gradeField.text == "" || gradeOutOfField.text == "" || Double(gradeOutOfField.text!) == 0.0 || !checkMarkInput()) {
                print("AddProject: CheckInput Exit -> Field empty or gradeOutOf set to 0")
                return false
            }
            else {
                projectGrade = Double(gradeField.text!)!
                projectOutOf = Double(gradeOutOfField.text!)!
            }

        }
        print("AddProject: CheckInput Exit -> Success")
        return true
    }
    
    func checkMarkInput() -> Bool {
        if (projectIsComplete.isOn) {
            print("AddProject: checkMarkInput Entry")
            let grade = gradeField.text
            let weight = weightField.text
            var numDecimals = 0
            var numDecimals2 = 0
            
            for char in (grade?.characters)! {
                if (char == ".") {
                    numDecimals += 1
                }
            }
            print("AddProject: number of decimals in grade: \(numDecimals)")
            
            for char in (weight?.characters)! {
                if (char == ".") {
                    numDecimals2 += 1
                }
            }
            print("AddProject: number of decimals in weight: \(numDecimals2)")
            
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
    
    func textFieldDidChange(_textField: UITextField) {
        print("AddProject: textFieldDidChange -> Entry")
        if (checkInput()) {
            saveButton.isEnabled = true
            return
        }
        saveButton.isEnabled = false
    }
    
    // MARK: - Navigation

    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        print("AddProject: Checking input... \(checkInput())")
        return checkInput()
    }
    
//    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        // Get the new view controller using segue.destinationViewController.
//        // Pass the selected object to the new view controller.
//        print("prepareForSegue")
//    }

    // MARK: - Listeners
    func keyboardToggle(_ notification: Notification) {
        print("\(type(of: self)) > \(#function)")
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


