//
//  AddProjectViewController.swift
//  GradeCalculator
//
//  Created by Logan Kember on 2016-08-10.
//  Copyright © 2016 Logan Kember. All rights reserved.
//

import UIKit

class AddProjectViewController: UIViewController {

    // MARK - Attributes
    @IBOutlet weak var projectNameField: UITextField!
    @IBOutlet weak var projectIsComplete: UISwitch!
    @IBOutlet weak var weightField: UITextField!
    @IBOutlet weak var gradeView: UIView!
    @IBOutlet weak var gradeField: UITextField!
    @IBOutlet weak var gradeOutOfField: UITextField!
    @IBOutlet weak var incorrectInfoLabel: UILabel!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    var projectName = ""
    var projectWeight = -1.0
    var projectGrade = -1.0
    var projectOutOf = -1.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        incorrectInfoLabel.hidden = true
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - Actions
    @IBAction func cancelView(sender: UIBarButtonItem) {
        dismissViewControllerAnimated(true, completion: nil)
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

    // MARK: - Function
    
    // Function which checks the to make sure all fields are completed
    func checkInput() -> Bool {
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
    
    
    // MARK: - Navigation

    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool {
        print("Checking... \(checkInput())")
        return checkInput()
    }
    
//    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        // Get the new view controller using segue.destinationViewController.
//        // Pass the selected object to the new view controller.
//        print("prepareForSegue")
//    }

}
