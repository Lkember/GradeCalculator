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
    var course = Course?()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setting delegates
        self.projectNameField.delegate = self
        self.weightField.delegate = self
        self.gradeField.delegate = self
        self.gradeOutOfField.delegate = self
        
        // Adding listeners for when the keyboard shows or hides
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(AddProjectViewController.keyboardToggle(_:)), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(AddProjectViewController.keyboardToggle(_:)), name: UIKeyboardWillHideNotification, object: nil)
        
        incorrectInfoLabel.hidden = true
        // Do any additional setup after loading the view.
        
        if (self.projectWeight != -1.0 || self.projectName != "") {
            editorMode = true
            
            print("AddProject: Updating projectName \(projectName), grade: \(projectGrade), weight: \(projectWeight)")
            self.projectNameField?.text = "\(self.projectName)"
            self.weightField?.text = "\(self.projectWeight)"
            
            if (projectGrade != -1.0) {
                self.gradeField?.text = "\(self.projectGrade)"
                
            }
            else {
                projectIsComplete.on = false
                isComplete(projectIsComplete)
            }
            
            self.outOfLabel.hidden = true
            self.gradeOutOfField.hidden = true
            self.deleteProjectButton.hidden = false
        }
        else {
            self.deleteProjectButton.hidden = true
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - Actions
    @IBAction func cancelView(sender: UIBarButtonItem) {
        print("AddProject: Ending view")
        if (!editorMode) {
            dismissViewControllerAnimated(true, completion: nil)
        }
        else {
            self.navigationController?.popViewControllerAnimated(true)
        }
    }
    
    
    // When the user specifies they have a mark, then show grade else hide
    @IBAction func isComplete(sender: UISwitch) {
        if sender.on {
            UIView.animateWithDuration(0.3, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
                self.gradeView.alpha = 1.0
                }, completion: nil)
        }
        else {
            UIView.animateWithDuration(0.3, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
                self.gradeView.alpha = 0.0
                }, completion: nil)
        }
    }
    
    @IBAction func deleteProject(sender: UIButton) {
        let alertController = UIAlertController(title: "Delete Project", message: "Are you sure you want to delete this project?", preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil))
        
        alertController.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.Default, handler: { action in
            // TODO
            self.performSegueWithIdentifier("deleteProject", sender: self)
        }))
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    

    // MARK: - Function
    
    // Function which checks the to make sure all fields are completed
    func checkInput() -> Bool {
        if (!editorMode) {
            if (projectNameField.text == "" || weightField.text == "") {
                incorrectInfoLabel.hidden = false
                return false
            }
            else {
                projectName = projectNameField.text!
                projectWeight = Double(weightField.text!)!
            }
            if (projectIsComplete.on) {
                if (gradeField.text == "" || gradeOutOfField.text == "") {
                    incorrectInfoLabel.hidden = false
                    return false
                }
                else {
                    projectGrade = Double(gradeField.text!)!
                    projectOutOf = Double(gradeOutOfField.text!)!
                }
            }
            incorrectInfoLabel.hidden = true
            return true
        }
        else {
            if (projectNameField.text == "" || weightField.text == "") {
                incorrectInfoLabel.hidden = false
                return false
            }
            else {
                projectName = projectNameField.text!
                projectWeight = Double(weightField.text!)!
            }
            if (projectIsComplete.on) {
                if (gradeField.text == "") {
                    incorrectInfoLabel.hidden = false
                    return false
                }
                else {
                    projectGrade = Double(gradeField.text!)!
                }
            }
            incorrectInfoLabel.hidden = true
            return true
        }
    }
    
    
    // MARK: - TextField
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    // MARK: - Navigation

    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool {
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
    func keyboardToggle(notification: NSNotification) {
        let userInfo = notification.userInfo!
        
        let keyboardScreenEndFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
        let keyboardViewEndFrame = view.convertRect(keyboardScreenEndFrame, fromView: scrollView)
        
        if notification.name == UIKeyboardWillHideNotification {
            scrollView.contentInset = UIEdgeInsetsZero
            print("AddProject: Keyboard is hidden.")
        } else {
            scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height, right: 0)
            print("AddProject: Keyboard is showing.")
        }
    }
    
}
