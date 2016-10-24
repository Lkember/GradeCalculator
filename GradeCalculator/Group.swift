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
    
    // A function which finds the index and dictionary key for a course
    // The return is in the form of [key, index]
//    func getDictionaryAndIndex(course: String) -> [Int] {
//        
//        // loop through each key
//        for i in 0..<keys.count {
//            
//            //loop through each course in each dictionary
//            for j in 0..<group[keys[i]]!.count {
//                
//                // if the current course name is equal to the input course name, then we have a match
//                if (group[keys[i]]![j].courseName == course) {
//                    return [i,j]
//                }
//            }
//        }
//        
//        return [-1]
//    }
    
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
    func editCourse(courseToEdit: Course?, newCourseName: String) {
//        for key in keys {
//            for course in self.group[key]! {
//                if course == courseToEdit {
//                    course.courseName = newCourseName
//                    return
//                }
//            }
//        }
        for course in courses {
            if course.courseName == courseToEdit?.courseName {
                course.courseName = newCourseName
                return
            }
        }
    }
    
    
    //A function to delete a course from the courses list
    func deleteFromCourseList(courseToDelete: Course?) {
        print("Group: deleteFromCourseList -> Entry: Deleting course \(courseToDelete?.courseName)")
        for i in 0..<self.courses.count {
            if self.courses[i] == courseToDelete {
                print("Group: deleteFromCourseList -> Exit: Course found. Deleting course \(courses[i].courseName)")
                self.courses.remove(at: i)
                return
            }
        }
    }
    
    //Can probably delete this method
    //A function to make sure the keys array is correct
//    func updateKeys() {
//        print("Group: UpdateKeys -> Entry")
//        if group.count == keys.count {
//            return
//        }
//        else {
//            keys.removeAll()
//            for (key, _) in group {
//                keys.append(key)
//            }
//        }
//        print("Group: UpdateKeys -> Exit")
//    }
    
    
    // A function which gets the average for the current group
    func getGroupAverage(key: String) -> Double {
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
            print("Group: getGroupAverage -> Exit: Return -1.0 since no courses have a mark")
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
        let groupName = aDecoder.decodeObject(forKey: PropertyKey.groupNameKey) as! [String: [Course]]
        let courses = aDecoder.decodeObject(forKey: PropertyKey.coursesKey) as! [Course]
        
        self.init(groupName: groupName, courses: courses)
    }
}
