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
    var group: [String: [Course]?] = [:]
    var courses = [Course]()
    var keys: [String] = []
    
    //MARK: - init
    init(group: [String: [Course]?], courses: [Course], keys: [String]) {
        self.group = group
        self.courses = courses
        self.keys = keys
        
        if (self.group.count == 0) {
            self.group["Ungrouped Courses"] = []
            self.keys.append("Ungrouped Courses")
        }
    }
    
    override init() {
        self.group = [:]
        self.group["Ungrouped Courses"] = []
        self.courses = []
        self.keys = []
    }
    
    
    //MARK: - Functions
    
    //A function which returns an array of all group names
    func getGroupNames() -> [String] {
        return keys
    }
    
    //MARK: - NSCoding
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("groups")
    
    struct PropertyKey {
        static let groupKey = "group"
        static let coursesKey = "courses"
        static let keys = "keys"
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(group, forKey: PropertyKey.groupKey)
        aCoder.encode(courses, forKey: PropertyKey.coursesKey)
        aCoder.encode(keys, forKey: PropertyKey.keys)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        let group = aDecoder.decodeObject(forKey: PropertyKey.groupKey) as! [String: [Course]?]
        let courses = aDecoder.decodeObject(forKey: PropertyKey.coursesKey) as! [Course]
        let keys = aDecoder.decodeObject(forKey: PropertyKey.keys) as! [String]
        
        self.init(group: group, courses: courses, keys: keys)
    }
}
