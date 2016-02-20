//
//  MissionsController.swift
//
//  Created by Emily Ivie on 9/22/15.
//  Copyright © 2015 urdnot.

//  Licensed under The MIT License
//  For full copyright and license information, please see http://opensource.org/licenses/MIT
//  Redistributions of files must retain the above copyright notice.

import UIKit

class ListController: UITableViewController {

    // loaded dynamically
    lazy var list: [String] = []
    
    // set by page controller parent
    var group: String = "Friends"
    
    var isUpdating = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDummyData()
    }
    
    func setupDummyData() {
        if group == "Friends" {
            list = [
                "Aeryn Sun",
                "Dominar Rygel XVI",
                "John Crichton",
                "Ka D'Argo",
                "Moya",
                "Pau'u Zotoh Zhaan",
                "Pilot",
            ]
        } else if group == "Enemies" {
            list = [
                "Braca",
                "Captain Bialar Crais",
                "Lieutenant Teeg",
                "Scorpius",
            ]
        }
    }

    //MARK: Protocol - UITableViewDelegate
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCellWithIdentifier("My Row") where indexPath.row < list.count {
            cell.textLabel?.text = list[indexPath.row]
            cell.detailTextLabel?.text = "Group: \(group)"
            return cell
        }
        return super.tableView(tableView, cellForRowAtIndexPath: indexPath)
    }
    
}
