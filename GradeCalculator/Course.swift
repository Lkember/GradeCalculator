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
    var projects : [String]
    var projectMarks : [Double]
    var projectWeights : [Double]
//    var project : Dictionary<String, Double>
    
    // MARK: Initilization
    init?(courseName: String) {
        // Initialize stored properties.
        self.courseName = courseName
//        project = [:]
        projects = []
        projectMarks = []
        projectWeights = []
        
        // Initialization should fail if there is no name or if the rating is negative.
        if courseName.isEmpty {
            return nil
        }
    }
    
    func getAverage() -> Double {
        if projects.count != 0 {
            var mark = 0.0
            var weightSum = 0.0
            for i in 0..<projectMarks.count {
                mark += projectMarks[i] * projectWeights[i]
                weightSum += projectWeights[i]
            }
            mark = mark/weightSum
            return mark
        }
        else {
            return -1.0
        }
    }
    
    // Mark: Actions
    func addProject(projectName: String, grade: Double, weight: Double) {
        projects.append(projectName)
        projectMarks.append(grade)
        projectWeights.append(weight)
    }
}
