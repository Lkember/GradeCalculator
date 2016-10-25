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
    
    override init() {
        self.courseName = ""
        projects = []
        projectMarks = []
        projectOutOf = []
        projectWeights = []
    }
    
    init?(courseName: String) {
        // Initialize stored properties.
        if courseName.isEmpty {
            return nil
        }
        
        self.courseName = courseName
        projects = [String]()
        projectMarks = [Double]()
        projectOutOf = [Double]()
        projectWeights = [Double]()
        
        super.init()
    }
    
    init?(courseName: String, projects: [String], projectMarks: [Double], projectOutOf: [Double],projectWeights: [Double]) {
        self.courseName = courseName
        self.projects = projects
        self.projectMarks = projectMarks
        self.projectWeights = projectWeights
        self.projectOutOf = projectOutOf
        
        super.init()
    }
    
    
    //MARK: Functions
    
    // Deletes a project at the given index
    func deleteAtRow(row: Int) {
        projects.remove(at: row)
        projectMarks.remove(at: row)
        projectWeights.remove(at: row)
        projectOutOf.remove(at: row)
    }
    
    // Returns the average of all completed projects
    func getAverage() -> Double {
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
                print("Courses: getAverage() -> Incomplete")
                return -1.0
            }
            print("Courses: getAverage() -> \(mark)")
            return mark
        }
        print("Courses: getAverage() -> -1.0")
        return -1.0
    }
    
    // Returns the number of grades that have been inputted
    func getNumMarks() -> Int {
        print("Courses getNumMarks entry")
        var markCount = 0
        print("Course.swift: projects.count = \(projects.count)");
        for i in 0..<projects.count {
            if (projectMarks[i] != -1.0) {
                markCount+=1
            }
        }
        print("Courses getNumMarks exit")
        return markCount
    }
    
    // Returns the total weight
    func getWeightTotal() -> Double {
        print("courses getWeightTotal entry")
        var weight = 0.0
        for i in 0..<projects.count {
            weight += projectWeights[i]
        }
        print("courses getWeightTotal -> exit RETURN \(weight)")
        return weight
    }
    
    func getPotentialMark() -> Double {

        let average = getAverage()
        var activeWeight = 0.0
        
        for i in 0..<projects.count {
            if projectMarks[i] != -1.0 {
                activeWeight += projectWeights[i]
            }
        }
        
        let remainingWeight = 100.0 - activeWeight
        let potential = ((average*(remainingWeight)) + remainingWeight)/100
        print("Courses: getPotentialMark: Exit Return \(potential)")
        return potential
    }
    
    // Mark: Actions
    func addProject(_ projectName: String, grade: Double, outOf: Double, weight: Double) {
        print("courses addProject entry")
        projects.append(projectName)
        projectMarks.append(grade)
        projectWeights.append(weight)
        projectOutOf.append(outOf)
        print("courses addProject exit")
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
