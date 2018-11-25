//
//  CompletedProjectTableViewCell.swift
//  GradeCalculator
//
//  Created by Logan Kember on 2018-11-15.
//  Copyright © 2018 Logan Kember. All rights reserved.
//

import UIKit

class CompletedProjectTableViewCell: UITableViewCell {
    
    @IBOutlet weak var projectNameLabel: UILabel!
    @IBOutlet weak var projectMarkLabel: UILabel!
    @IBOutlet weak var projectWeightLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setDisabled() {
        self.projectNameLabel.isEnabled = false
        self.projectMarkLabel.isEnabled = false
        self.projectWeightLabel.isEnabled = false
    }
    
    func updateCell(projectName: String, mark: Double, weight: Double) {
        self.projectNameLabel.text = projectName
        if (mark != Helper.empty) {
            self.projectMarkLabel.text = "Mark: \(mark)%"
        }
        else {
            self.projectMarkLabel.text = "Mark: N/A"
        }
        self.projectWeightLabel.text = "Weight: \(weight)%"
    }
}
