//
//  CourseTableViewCell.swift
//  GradeCalculator
//
//  Created by Logan Kember on 2016-07-25.
//  Copyright © 2016 Logan Kember. All rights reserved.
//

import UIKit

class CourseTableViewCell: UITableViewCell {
    
    // MARK: Properties
    @IBOutlet weak var courseName: UILabel!
    @IBOutlet weak var courseDescription: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
