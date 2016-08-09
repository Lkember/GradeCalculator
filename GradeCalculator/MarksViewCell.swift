//
//  MarksViewCell.swift
//  GradeCalculator
//
//  Created by Logan Kember on 2016-08-05.
//  Copyright © 2016 Logan Kember. All rights reserved.
//

import UIKit

class MarksViewCell: UITableViewCell {
    
    // MARK: Attributes
    @IBOutlet weak var projectNameLabel: UILabel!
    @IBOutlet weak var markLabel: UILabel!
    @IBOutlet weak var weightLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
