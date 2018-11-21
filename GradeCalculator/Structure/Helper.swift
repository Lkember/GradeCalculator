//
//  Helper.swift
//  GradeCalculator
//
//  Created by Logan Kember on 2018-11-21.
//  Copyright © 2018 Logan Kember. All rights reserved.
//

import UIKit

class Helper {
    
    // MARK: Rounding
    // Rounds a value to one decimal places
    static func roundOneDecimalPlace(value: Double) -> Double {
        return round(10*value)/10
    }
    
}
