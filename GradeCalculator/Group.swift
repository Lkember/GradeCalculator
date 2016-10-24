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
//    var group: [String: [Course]] = [:]
    var groupName = ""
    var courses = [Course]()
//    var keys: [String] = []
    
    //MARK: - init
//    init(group: [String: [Course]], courses: [Course], keys: [String]) {
//        self.group = group
//        self.courses = courses
//        self.keys = keys
//        
//        if (self.group.count == 0) {
//            self.group["Ungrouped Courses"] = []
//            self.keys.append("Ungrouped Courses")
//        }
//    }

    init(groupName: String, courses: [Course]) {
        self.groupName = groupName
        self.courses = courses
    }
    
    override init() {
//        self.group = [:]
//        self.group["Ungrouped Courses"] = []
//        self.courses = []
//        self.keys = []
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
    
    
    // A function which removes all courses in a given array.
    // TODO: This method needs to be reimplemented.
//    func removeCourses(coursesToDelete: [Course]) {
//        print("Group: removeCourses: -> Entry")
//        var counter = 0
//        
//        print("Group: removeCourses: Number of courses to delete \(coursesToDelete.count), number of keys to search through \(keys.count)")
//        
//        for tempCourse in coursesToDelete {
//            for key in keys {
//                counter = 0
//                for course in self.group[key]! {
//                    print("Group: removeCourses: Looking at course: \(course.courseName)")
//                    if course == tempCourse {
//                        print("Group: removeCourses: Removing course -> \(self.group[key]?[counter].courseName)")
//                        self.group[key]!.remove(at: counter)
//                        break
//                    }
//                    counter += 1
//                }
//            }
//        }
//        print("Group: removeCourses: -> Exit")
//    }
    
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
