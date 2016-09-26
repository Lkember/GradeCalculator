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
    @IBOutlet weak var incorrectInfoLabel: UILabel!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var deleteProjectButton: UIButton!
    @IBOutlet var scrollView: UIScrollView!
    
    var projectName = ""
    var projectWeight = -1.0
    var projectGrade = -1.0
    var projectOutOf = -1.0
    var editorMode = false
    var course: Course?
    
    
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
        
        incorrectInfoLabel.isHidden = true
        // Do any additional setup after loading the view.
        
//        scrollView.contentInset = UIEdgeInsets.zero
//        print("AddProject: Content Inset.")
        
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - Actions
    @IBAction func cancelView(_ sender: UIBarButtonItem) {
        print("AddProject: Ending view")
        if (!editorMode) {
            dismiss(animated: true, completion: nil)
        }
        else {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    
    // When the user specifies they have a mark, then show grade else hide
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
    }
    
    @IBAction func deleteProject(_ sender: UIButton) {
        let alertController = UIAlertController(title: "Delete Project", message: "Are you sure you want to delete this project?", preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
        
        alertController.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.default, handler: { action in
            // TODO
            self.performSegue(withIdentifier: "deleteProject", sender: self)
        }))
        
        self.present(alertController, animated: true, completion: nil)
    }
    

    // MARK: - Function
    
    // Function which checks the to make sure all fields are completed
    func checkInput() -> Bool {
        // if user is adding a new project
        if (!editorMode) {
            if (projectNameField.text == "" || weightField.text == "") {
                incorrectInfoLabel.isHidden = false
                return false
            }
            else {
                projectName = projectNameField.text!
                projectWeight = Double(weightField.text!)!
            }
            if (projectIsComplete.isOn) {
                if (gradeField.text == "" || gradeOutOfField.text == "" || !checkMarkInput()) {
                    incorrectInfoLabel.isHidden = false
                    return false
                }
                else {
                    projectGrade = Double(gradeField.text!)!
                    projectOutOf = Double(gradeOutOfField.text!)!
                }
            }
            incorrectInfoLabel.isHidden = true
            return true
        }
            // if user is editing a project
        else {
            if (projectNameField.text == "" || weightField.text == "") {
                incorrectInfoLabel.isHidden = false
                return false
            }
            else {
                projectName = projectNameField.text!
                projectWeight = Double(weightField.text!)!
            }
            if (projectIsComplete.isOn) {
                if (gradeField.text == "" || gradeOutOfField.text == "" || Double(gradeOutOfField.text!) == 0.0 || !checkMarkInput()) {
                    incorrectInfoLabel.isHidden = false
                    return false
                }
                else {
                    projectGrade = Double(gradeField.text!)!
                    projectOutOf = Double(gradeOutOfField.text!)!
                }
            }
            incorrectInfoLabel.isHidden = true
            return true
        }
    }
    
    func checkMarkInput() -> Bool {
        print("AddProject: Checking mark input")
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
            return true
        }
        return false
    }
    
    
    // MARK: - TextField
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
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
        let userInfo = (notification as NSNotification).userInfo!
        
        let keyboardScreenEndFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: scrollView)
        let navHeight = self.navigationController!.navigationBar.frame.height
        
        if notification.name == NSNotification.Name.UIKeyboardWillHide {
            scrollView.contentInset = UIEdgeInsets(top: navHeight + 20, left: 0, bottom: 0, right: 0)
            print("AddProject: Keyboard is hidden.")
        } else {
            scrollView.contentInset = UIEdgeInsets(top: navHeight + 20, left: 0, bottom: keyboardViewEndFrame.height, right: 0)
            print("AddProject: Keyboard is showing.")
        }
    }
    
}
