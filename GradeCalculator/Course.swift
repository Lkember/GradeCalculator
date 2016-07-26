//
//  Course.swift
//  GradeCalculator
//
//  Created by Logan Kember on 2016-07-25.
//  Copyright © 2016 Logan Kember. All rights reserved.
//

import UIKit

class Course: NSObject {
    
    // MARK: Properties
    var courseName : String
    var project : Dictionary<String, Double>
    
    // MARK: Initilization
    init?(courseName: String) {
        // Initialize stored properties.
        self.courseName = courseName
        project = [:]
        
        // Initialization should fail if there is no name or if the rating is negative.
        if courseName.isEmpty {
            return nil
        }
    }
    
    func getAverage() -> Double {
        if project.count != 0 {
            var sum : Double = 0
            sum = 0.0
        
            for (_, grade) in project {
                sum += grade
            }
        
            return sum/Double(project.count)
        }
        else {
            return -1.0
        }
    }
    
    // Mark: Actions
    func addProject(projectName: String, grade: Double) -> Bool {
        if (project[projectName] == nil) {
            project[projectName] = grade
            return true
        }
        else {
            return false
        }
    }
}
