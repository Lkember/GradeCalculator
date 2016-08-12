//
//  Course.swift
//  GradeCalculator
//
//  Created by Logan Kember on 2016-07-25.
//  Copyright © 2016 Logan Kember. All rights reserved.
//

import UIKit

class Course: NSObject, NSCoding {
    
    // MARK: Properties
    var courseName : String
    var projects : [String]
    var projectMarks : [Double]
    var projectWeights : [Double]
    
    // MARK: Archiving Paths
    
    static let DocumentsDirectory = NSFileManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.URLByAppendingPathComponent("courses")
    
    
    // MARK: Types
    
    struct PropertyKey {
        static let courseNameKey = "courseName"
        static let projectsKey = "projects"
        static let projectMarksKey = "projectMarks"
        static let projectWeightsKey = "projectWeights"
    }
    
    // MARK: Initilization
    
    init?(courseName: String) {
        // Initialize stored properties.
        self.courseName = courseName
        projects = []
        projectMarks = []
        projectWeights = []
        
        super.init()
        
        if courseName.isEmpty {
            return nil
        }
    }
    
    init?(courseName: String, projects: [String], projectMarks: [Double], projectWeights: [Double]) {
        self.courseName = courseName
        self.projects = projects
        self.projectMarks = projectMarks
        self.projectWeights = projectWeights
        
        super.init()
    }
    
    func getAverage() -> Double {
        if projects.count != 0 {
            var mark = 0.0
            var weightSum = 0.0
            for i in 0..<projectMarks.count {
                if (projectMarks[i] != -1.0) {
                    mark += projectMarks[i] * projectWeights[i]
                    weightSum += projectWeights[i]
                }
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
    
    // MARK: NSCoding
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(courseName, forKey: PropertyKey.courseNameKey)
        aCoder.encodeObject(projects, forKey: PropertyKey.projectsKey)
        aCoder.encodeObject(projectMarks, forKey: PropertyKey.projectMarksKey)
        aCoder.encodeObject(projectWeights, forKey: PropertyKey.projectWeightsKey)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        let courseName = aDecoder.decodeObjectForKey(PropertyKey.courseNameKey) as! String
        let projects = aDecoder.decodeObjectForKey(PropertyKey.projectsKey) as! [String]
        let projectMarks = aDecoder.decodeObjectForKey(PropertyKey.projectMarksKey) as! [Double]
        let projectWeights = aDecoder.decodeObjectForKey(PropertyKey.projectWeightsKey) as! [Double]
        
        self.init(courseName: courseName, projects: projects, projectMarks: projectMarks, projectWeights: projectWeights)
    }
    
}
