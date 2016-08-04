//
//  NewCoursesViewController.swift
//  GradeCalculator
//
//  Created by Logan Kember on 2016-07-26.
//  Copyright © 2016 Logan Kember. All rights reserved.
//

import UIKit

class NewCoursesViewController: UIViewController, UITextFieldDelegate {
    
    // MARK: Properties
    var courses = [Course]()
    var course = Course?()
    @IBOutlet weak var courseName: UITextField!
    @IBOutlet weak var warningLabel: UILabel!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    
    // MARK: Actions
    @IBAction func cancel(sender: UIBarButtonItem) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    // MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        if sender === saveButton {
//            print("Adding course")
//            let destinationView = segue.destinationViewController as? CourseTableViewController
//            destinationView?.courses = self.courses
//        }
    }
    
    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool {
        if saveButton === sender {
            var check = false
            let courseInput = self.courseName.text ?? ""
            for courseName in self.courses {
                if courseName.courseName == courseInput {
                    check = true
                    break
                }
            }
            if check {
                warningLabel.text = "A course with that name already exists."
                warningLabel.hidden = false;
                return false
            }
            else {
                course = Course(courseName: courseInput)
                courses.append(course!)
                warningLabel.hidden = true
                return true
            }
        }
        if cancelButton === sender {
            return true
        }
        return false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.courseName.delegate = self
        warningLabel.hidden = true
        courseName.addTarget(self, action: #selector(NewCoursesViewController.textFieldDidChange(_:)), forControlEvents: UIControlEvents.EditingChanged)
        saveButton.enabled = false
        
        print("num courses: \(courses.count)")
        for course in courses {
            print(course.courseName)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Mark: UITextFieldDelegate
    
    func textFieldDidChange(textField: UITextField) {
        let text = textField.text ?? ""
        if text == "" {
            saveButton.enabled = false
        }
        else {
            saveButton.enabled = true
        }
    }

}
