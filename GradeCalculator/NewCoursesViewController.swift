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
    var course: Course?
    @IBOutlet weak var courseName: UITextField!
    @IBOutlet weak var warningLabel: UILabel!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    
    // MARK: Actions
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    
    // MARK: - Navigation
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        return checkInput()
    }
    
    override func viewDidLoad() {
        print("NewCourses: viewDidLoad")
        super.viewDidLoad()
        
        self.courseName.delegate = self
        self.navigationController?.navigationBar.barStyle = UIBarStyle.black
        
        warningLabel.isHidden = true
        courseName.addTarget(self, action: #selector(NewCoursesViewController.textFieldDidChange(_:)), for: UIControlEvents.editingChanged)
        saveButton.isEnabled = false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // Mark: UITextFieldDelegate
    
    func textFieldDidChange(_ textField: UITextField) {
        let text = textField.text ?? ""
        if text == "" {
            saveButton.isEnabled = false
        }
        else {
            saveButton.isEnabled = true
        }
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        courseName.resignFirstResponder()
        return true
    }
    
    func checkInput() -> Bool {
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
            warningLabel.isHidden = false;
            return false
        }
        course = Course(courseName: courseInput)
        courses.append(course!)
        warningLabel.isHidden = true
        return true
    }
}
