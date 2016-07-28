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
    @IBOutlet weak var courseName: UITextField!
    @IBOutlet weak var warningLabel: UILabel!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    
     // MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
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
            }
            else {
                courses.append(Course(courseName: courseInput)!)
                warningLabel.hidden = true
            }
            
        }
//        if segue.identifier == "backToCourseView" {
//            let destinationViewController = segue.destinationViewController as? CourseTableViewController
//            destinationViewController?.courses = self.courses;
//        }
    }
    
    // MARK: Actions
//    @IBAction func addCourse(sender: UIBarButtonItem) {
//        if courseName.text != "" {
//            print("Value of input: \(courseName.text)")
//            print("Number of courses: \(courses.count)")
//            var check = false
//            // check if course name already exists
//            for courseName in self.courses {
//                // If the input is the same as
//                print("Checking: \(courseName) == \(self.courseName.text)")
//                if courseName.courseName == self.courseName.text {
//                    print("true")
//                    check = true
//                    break
//                }
//            }
//            if check {
//                print("Course already exists")
//                warningLabel.text = "A course with that name already exists."
//                warningLabel.hidden = false
//            }
//            else {
//                print("Adding Course")
//                let newCourse = Course.init(courseName: self.courseName.text!)
//                courses.append(newCourse!)
//                warningLabel.hidden = true
//                
//                // change views
//                performSegueWithIdentifier("backToCourseView", sender: nil)
//            }
//        }
//        else {
//            print("User did not enter anything")
//            // tell the user to input a course name
//            warningLabel.hidden = false
//        }
//    }
    
    // When return button is pressed
//    func textFieldShouldReturn(textField: UITextField) -> Bool {
//        courseName.resignFirstResponder()
//        addCourse(saveButton)
//        return true
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.courseName.delegate = self
        warningLabel.hidden = true
        courseName.addTarget(self, action: #selector(NewCoursesViewController.textFieldDidChange(_:)), forControlEvents: UIControlEvents.EditingChanged)
        saveButton.enabled = false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Mark: UITextFieldDelegate
    
    func textFieldDidChange(textField: UITextField) {
        let text = textField.text ?? ""
        print("Here")
        if text == "" {
            saveButton.enabled = false
        }
        else {
            saveButton.enabled = true
        }
    }

}
