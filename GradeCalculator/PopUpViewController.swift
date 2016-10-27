//
//  PopUpViewController.swift
//  GradeCalculator
//
//  Created by Logan Kember on 2016-10-25.
//  Copyright © 2016 Logan Kember. All rights reserved.
//

import UIKit

class PopUpViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    //MARK: Attributes
    var groups: [Group] = []
    var index = -1
    var courseIndex = -1
    @IBOutlet weak var popUpView: UIView!
    @IBOutlet weak var groupSelector: UIPickerView!
    
    // MARK: View
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.groupSelector.delegate = self
        self.groupSelector.dataSource = self
        self.navigationController?.setToolbarHidden(true, animated: true)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
        self.groupSelector.selectRow(index, inComponent: 0, animated: false)
        
        self.popUpView.layer.cornerRadius = 10
        self.popUpView.layer.borderColor = UIColor.white.cgColor
        self.popUpView.layer.borderWidth = 2
        
        self.animate()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //MARK: Custom Functions
    
    @IBAction func cancelIsClicked(_ sender: AnyObject) {
        dismissAnimate()
    }

    @IBAction func acceptIsClicked(_ sender: UIButton) {
        if (groups[index].groupName != groups[groupSelector.selectedRow(inComponent: 0)].groupName) {
            let tempCourse = groups[index].courses.remove(at: courseIndex)
            groups[groupSelector.selectedRow(inComponent: 0)].courses.append(tempCourse)
            index = groupSelector.selectedRow(inComponent: 0)
            courseIndex = groups[index].courses.count
        }
        
        dismissAnimate()
    }
    
    func animate() {
        self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        self.view.alpha = 0.0;
        UIView.animate(withDuration: 0.25, animations: {
            self.view.alpha = 1.0
            self.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        });
    }
    
    func dismissAnimate()
    {
        self.navigationController?.setToolbarHidden(false, animated: true)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
        UIView.animate(withDuration: 0.25, animations: {
            self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            self.view.alpha = 0.0;
            }, completion:{(finished : Bool)  in
                if (finished)
                {
                    self.view.removeFromSuperview()
                }
        });
    }
    
    // MARK: - UIPickerViewDataSource
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return groups.count
    }
    
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return groups[row].groupName
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
