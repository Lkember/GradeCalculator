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
    var projectOutOf : [Double]
    var projectWeights : [Double]
    
    // MARK: Archiving Paths
    
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("courses")
    
    
    // MARK: Types
    
    struct PropertyKey {
        static let courseNameKey = "courseName"
        static let projectsKey = "projects"
        static let projectMarksKey = "projectMarks"
        static let projectOutOfKey = "projectOutOf"
        static let projectWeightsKey = "projectWeights"
    }
    
    // MARK: Initilization
    
    init?(courseName: String) {
        // Initialize stored properties.
        self.courseName = courseName
        projects = []
        projectMarks = []
        projectOutOf = []
        projectWeights = []
        
        super.init()
        
        if courseName.isEmpty {
            return nil
        }
    }
    
    init?(courseName: String, projects: [String], projectMarks: [Double], projectOutOf: [Double],projectWeights: [Double]) {
        self.courseName = courseName
        self.projects = projects
        self.projectMarks = projectMarks
        self.projectWeights = projectWeights
        self.projectOutOf = projectOutOf
        
        super.init()
    }
    
    // Returns the average of all completed projects
    func getAverage() -> Double {
        print("Course.swift: projects.count = \(projects.count)")
        if projects.count != 0 {
            var mark = 0.0
            var weightSum = 0.0
            var incomplete = 0
            for i in 0..<projectMarks.count {
                if (projectMarks[i] != -1.0) {
                    mark += (projectMarks[i]/projectOutOf[i]) * projectWeights[i]
                    weightSum += projectWeights[i]
                }
                else {
                    incomplete += 1
                }
            }
            
            mark = mark/weightSum
            if (incomplete == projects.count) {
                return -1.0
            }
            return mark
        }
        return -1.0
    }
    
    // Returns the number of grades that have been inputted
    func getNumMarks() -> Int {
        var markCount = 0
        print("Course.swift: projects.count = \(projects.count)");
        for i in 0..<projects.count {
            if (projectMarks[i] != -1.0) {
                markCount+=1
            }
        }
        return markCount
    }
    
    // Mark: Actions
    func addProject(_ projectName: String, grade: Double, outOf: Double, weight: Double) {
        projects.append(projectName)
        projectMarks.append(grade)
        projectWeights.append(weight)
        projectOutOf.append(outOf)
    }
    
    // MARK: NSCoding
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(courseName, forKey: PropertyKey.courseNameKey)
        aCoder.encode(projects, forKey: PropertyKey.projectsKey)
        aCoder.encode(projectMarks, forKey: PropertyKey.projectMarksKey)
        aCoder.encode(projectOutOf, forKey: PropertyKey.projectOutOfKey)
        aCoder.encode(projectWeights, forKey: PropertyKey.projectWeightsKey)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        let courseName = aDecoder.decodeObject(forKey: PropertyKey.courseNameKey) as! String
        let projects = aDecoder.decodeObject(forKey: PropertyKey.projectsKey) as! [String]
        let projectMarks = aDecoder.decodeObject(forKey: PropertyKey.projectMarksKey) as! [Double]
        let projectOutOf = aDecoder.decodeObject(forKey: PropertyKey.projectOutOfKey) as! [Double]
        let projectWeights = aDecoder.decodeObject(forKey: PropertyKey.projectWeightsKey) as! [Double]
        
        self.init(courseName: courseName, projects: projects, projectMarks: projectMarks, projectOutOf: projectOutOf, projectWeights: projectWeights)
    }
    
}
