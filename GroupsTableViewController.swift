//
//  GroupsTableViewController.swift
//  GradeCalculator
//
//  Created by Logan Kember on 2016-10-07.
//  Copyright © 2016 Logan Kember. All rights reserved.
//

import UIKit

class GroupsTableViewController: UITableViewController {
    
    var groups: [String: [Course]?] = [:]
    var groupNames: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for (groupName, _) in groups {
            groupNames.append(groupName)
        }
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
         self.navigationItem.leftBarButtonItem = self.editButtonItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    // MARK: - Functions
    
    @IBAction func unwindToCourseDict(sender: UIStoryboardSegue) {
        print("GroupsTable: unwindToCourseDict: -> Entry")
        if let sourceVC = sender.source as? AddGroupViewController {
            let newGroup = sourceVC.groupName.text
            
            groups[newGroup!] = [] as [Course]??
            groupNames.append(newGroup!)
            
            print("groups.count == \(groups.count)")
        }
        self.tableView.reloadData()
        
    }
    
    @IBAction func backToStartUpView(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        print("GroupsTable: numberOfRows = \(groups.count)")
        return groups.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "GroupCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        
        let groupName = groupNames[indexPath.row]
        
        cell.textLabel?.text = groupName
        cell.detailTextLabel?.text = "Number of courses in group: \(groups[groupName]!!.count)"
        
        cell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
        
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("GroupsTable: didSelectRowAt: -> Entry")
        if (tableView.isEditing) {
            print("GroupsTable: didSelectRowAt: isEditing")
            
        }
        else {
            
        }
    }
    
    
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        
    }
    
    
    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */
    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        print("canEditRowAt: \(indexPath.row)")
        if (groups[groupNames[indexPath.row]]!?.count == 0) {
            print("GroupsTable: canEditRowAt \(indexPath.row) -> True")
            return true
        }
        print("GroupsTable: canEditRowAt \(indexPath.row) -> False")
        return false
    }

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            groups.removeValue(forKey: groupNames[indexPath.row])
            groupNames.remove(at: indexPath.row)
            
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.reloadData()
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
        
    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        let destView = segue.destination.childViewControllers[0] as! AddGroupViewController
        destView.groups = self.groups
    }

}
