//
//  InformationMessageViewController.swift
//  GradeCalculator
//
//  Created by Logan Kember on 2018-11-21.
//  Copyright © 2018 Logan Kember. All rights reserved.
//

import UIKit

class InformationMessageViewController: UIViewController {

    @IBOutlet weak var informationalMessageView: UIView!
    @IBOutlet weak var informationalMessageText: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the corner radius
        self.informationalMessageView.layer.cornerRadius = 10
        self.informationalMessageView.layer.borderColor = UIColor.white.cgColor
        self.informationalMessageView.layer.borderWidth = 2
    }
    

    func setMessage(_ value: String) {
        informationalMessageText.text = value
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
