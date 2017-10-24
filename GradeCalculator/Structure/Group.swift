//
//  Group.swift
//  GradeCalculator
//
//  Created by Logan Kember on 2016-10-13.
//  Copyright © 2016 Logan Kember. All rights reserved.
//

import UIKit

class Group: NSObject, NSCoding {
    //MARK: - Properties
    var groupName = ""
    var courses = [Course]()
    
    //MARK: - init

    init(groupName: String, courses: [Course]) {
        self.groupName = groupName
        self.courses = courses
    }
    
    override init() {
        self.groupName = ""
        self.courses = []
    }
    
    
    //MARK: - Functions
    
    //A function which returns the index to a course in the courses list only
    //Returns -1 if course is not found
    func findIndexInCourseList(course: String) -> Int {
        for i in 0..<courses.count {
            if courses[i].courseName == course {
                return i
            }
        }
        return -1
    }
    
    // A function which checks to see if a course with this name already exists
    func doesCourseNameExist(courseName: String) -> Bool {
        for course in courses {
            if course.courseName == courseName {
                return true
            }
        }
        return false
    }
    
    //A function to edit the courseName of a given course
    func editCourse(courseToEdit: Course?, newCourseName: String) -> Bool {
        for course in courses {
            if courseToEdit == course {
                course.courseName = newCourseName
                return true
            }
        }
        return false
    }
    
    
    //A function to delete a course from the courses list
    func deleteFromCourseList(courseToDelete: Course?) {
        for i in 0..<courses.count {
            if courses[i] == courseToDelete {
                courses.remove(at: i)
                return
            }
        }
    }
    
    
    // Calculates and returns the average of the entire group
    func getGroupAverage() -> Double {
        print("Group: getGroupAverage -> Entry")
        var counter = 0
        var totalAverage = 0.0
        var currAverage = 0.0
        
        for course in courses {
            currAverage = course.getAverage()
            if currAverage != -1.0 {
                totalAverage += currAverage
                counter += 1
            }
        }
        if counter == 0 {
            print("Group: getGroupAverage -> Exit Return -1.0 due to no course averages")
            return -1.0
        }
        print("Group: getGroupAverage -> Exit")
        return totalAverage/Double(counter)
    }
    
    // A function that gets the total number of courses with marks
    func getNumActiveCourses() -> Int {
        var numCourses = 0
        
        for course in courses {
            if course.getAverage() != 0 {
                numCourses += 1
            }
        }
        return numCourses
    }
    
    
    //MARK: - NSCoding
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("groups")
    
    struct PropertyKey {
        static let groupNameKey = "groupName"
        static let coursesKey = "courses"
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(groupName, forKey: PropertyKey.groupNameKey)
        aCoder.encode(courses, forKey: PropertyKey.coursesKey)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        let groupName = aDecoder.decodeObject(forKey: PropertyKey.groupNameKey) as! String
        let courses = aDecoder.decodeObject(forKey: PropertyKey.coursesKey) as! [Course]
        
        self.init(groupName: groupName, courses: courses)
    }
}
