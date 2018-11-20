//
//  Project.swift
//  GradeCalculator
//
//  Created by Logan Kember on 2018-11-17.
//  Copyright © 2018 Logan Kember. All rights reserved.
//

import UIKit

class Project: NSObject, NSCoding {
    
    // MARK: - Properties
    var name: String
    var mark: Double
    var outOf: Double
    var weight: Double
    var dueDate: Date?
    
    var empty: Double = -1
    
    // MARK: - Archiving Paths
    
    struct PropertyKey {
        static let nameKey = "projectKey"
        static let markKey = "projectMarkKey"
        static let outOfKey = "projectOutOfKey"
        static let weightKey = "projectWeightKey"
        static let dueDateKey = "projectDueDateKey"
    }
    
    // MARK: - Constructors
    override init() {
        name = ""
        mark = -1
        outOf = -1
        weight = 0
        dueDate = nil
    }
    
    init(name: String, mark: Double, outOf: Double, weight: Double, dueDate: Date?) {
        self.name = name
        self.mark = mark
        self.outOf = outOf
        self.weight = weight
        self.dueDate = dueDate
        
        super.init()
    }
    
    // MARK: - Setters
    func updateMark(mark: Double, outOf: Double) {
        self.mark = mark
        self.outOf = outOf
    }
    
    func updateWeight(weight: Double) {
        self.weight = weight
    }
    
    func updateDueDate(date: Date?) {
        dueDate = date
    }
    
    // MARK: - Getters
    func getMark() -> Double {
        if (mark == empty || outOf == empty) {
            return empty
        }
        
        return round(1000*mark/outOf)/10
    }
    
    func getWeight() -> Double {
        return round(1000*weight)/1000
    }
    
    // MARK: - NSCoding
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: PropertyKey.nameKey)
        aCoder.encode(mark, forKey: PropertyKey.markKey)
        aCoder.encode(outOf, forKey: PropertyKey.outOfKey)
        aCoder.encode(weight, forKey: PropertyKey.weightKey)
        aCoder.encode(dueDate, forKey: PropertyKey.dueDateKey)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        let name = aDecoder.decodeObject(forKey: PropertyKey.nameKey) as! String
        
        if let mark = aDecoder.decodeDouble(forKey: PropertyKey.markKey) as Double? {
            let outOf = aDecoder.decodeDouble(forKey: PropertyKey.outOfKey)
            let weight = aDecoder.decodeDouble(forKey: PropertyKey.weightKey)
            let dueDate = aDecoder.decodeObject(forKey: PropertyKey.dueDateKey) as? Date
            
            self.init(name: name, mark: mark, outOf: outOf, weight: weight, dueDate: dueDate)
        }
        else {
            return nil
        }
    }
}
