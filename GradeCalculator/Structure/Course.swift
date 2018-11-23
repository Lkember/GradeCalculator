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
    var projects: [Project]
    
    // MARK: Types
    struct PropertyKey {
        static let courseNameKey = "courseName"
        static let oldProjectsKey = "projects"
        static let projectsKey = "projectsKey"
        static let projectMarksKey = "projectMarks"
        static let projectOutOfKey = "projectOutOf"
        static let projectWeightsKey = "projectWeights"
        static let dueDateKey = "dueDate"
    }
    
    // MARK: Initilization
    override init() {
        self.courseName = ""
        projects = []
    }
    
    init?(courseName: String) {
        // Initialize stored properties.
        if courseName.isEmpty {
            return nil
        }
        
        self.courseName = courseName
        projects = []
        
        super.init()
    }
    
    init?(courseName: String, projects: [Project]) {
        self.courseName = courseName
        self.projects = projects
    }
    
    // MARK: - Project Getters and Setters
    func getProjectName(index: Int) -> String {
        return projects[index].name
    }
    
    func getProjectMark(index: Int) -> Double {
        return projects[index].getMark()
    }
    
    func getProjectWeight(index: Int) -> Double {
        return projects[index].getWeight()
    }
    
    func getProjectDueDate(index: Int) -> Date? {
        return projects[index].dueDate
    }
    
    func setProjectName(index: Int, value: String) {
        projects[index].name = value
    }
    
    func setProjectMark(index: Int, value: Double) {
        projects[index].mark = value
    }
    
    func setProjectOutOf(index: Int, value: Double) {
        projects[index].outOf = value
    }
    
    func setProjectWeight(index: Int, value: Double) {
        projects[index].weight = value
    }
    
    func setProjectDueDate(index: Int, value: Date?) {
        projects[index].dueDate = value
    }
    
    func setIsComplete(index: Int, value: Bool) {
        projects[index].isComplete = value
    }
    
    //MARK: - Functions
    
    func projectIsComplete(index: Int) -> Bool {
        if (projects.count > index && index >= 0) {
            if (projects[index].getMark() != -1.0 || projects[index].isComplete) {
                return true;
            }
        }
        
        return false;
    }
    
    // Deletes a project at the given index
    func deleteAtRow(row: Int) {
        projects.remove(at: row)
    }
    
    // Returns the average of all completed projects
    func getAverage() -> Double {
        if projects.count != 0 {
            var mark = 0.0
            var weightSum = 0.0
            var incomplete = 0
            
            for i in 0..<projects.count {
                let currMark = projects[i].getMark()
                if (currMark != -1.0) {
                    mark += (currMark * projects[i].weight)
                    weightSum += projects[i].weight
                }
                else {
                    incomplete += 1
                }
            }
            
            mark = mark/weightSum
            if (incomplete == projects.count) {
                return -1.0
            }
            
            return Helper.roundOneDecimalPlace(value: mark)
        }
        
        print("Courses: getAverage() -> \(courseName) = -1.0")
        return -1.0
    }
    
    // Returns the number of grades that have been inputted
    func getNumMarks() -> Int {
        var markCount = 0
        for i in 0..<projects.count {
            if (projects[i].mark != -1.0) {
                markCount+=1
            }
        }
        print("Courses getNumMarks \(courseName) numMarks = \(markCount)")
        return markCount
    }
    
    // Returns the total weight
    func getWeightTotal() -> Double {
        print("courses getWeightTotal entry")
        var weight = 0.0
        for i in 0..<projects.count {
            weight += projects[i].weight
        }
        print("courses getWeightTotal -> exit RETURN \(courseName) = \(weight)")
        return Helper.roundOneDecimalPlace(value: weight)
    }
    
    func getActiveWeightTotal() -> Double {
        print("courses getActiveWeightTotal entry")
        var weight = 0.0
        for i in 0..<projects.count {
            if (projects[i].mark != -1.0) {
                weight += projects[i].weight
            }
        }
        print("courses getActiveWeightTotal -> exit RETURN \(courseName) = \(weight)")
        return Helper.roundOneDecimalPlace(value: weight)
    }
    
    func getPotentialMark() -> Double {

        let average = getAverage()
        var activeWeight = 0.0
        
        print("Courses: getPotentialMark -> Entry: \(courseName) average \(average)")
        
        for i in 0..<projects.count {
            if projects[i].mark != -1.0 {
                activeWeight += projects[i].weight
            }
        }
        
        let remainingWeight = 100.0 - activeWeight
        let potential = ((average/100)*(activeWeight/100) + remainingWeight/100)*100
        print("Courses: getPotentialMark -> Exit Return \(courseName) potential = \(potential)")
        return Helper.roundOneDecimalPlace(value: potential)
    }
    
    // MARK: Actions
    func addProject(_ projectName: String, grade: Double, outOf: Double, weight: Double, newDueDate: Date?, isComplete: Bool) {
        print("courses addProject \(courseName)")
        let proj: Project = Project.init(name: projectName, mark: grade, outOf: outOf, weight: weight, dueDate: newDueDate, isComplete: isComplete)
        projects.append(proj)
    }
    
    // MARK: NSCoding
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(courseName, forKey: PropertyKey.courseNameKey)
        aCoder.encode(projects, forKey: PropertyKey.projectsKey)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        let courseName = aDecoder.decodeObject(forKey: PropertyKey.courseNameKey) as! String
        let projects = aDecoder.decodeObject(forKey: PropertyKey.projectsKey) as! [Project]
        
        self.init(courseName: courseName, projects: projects)
    }
    
}
