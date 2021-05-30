//
//  RadioShowDetailTableViewController.swift
//  WCFM
//
//  Created by Matt Newman on 11/13/18.
//  Copyright © 2018 Matt Newman. All rights reserved.
//

import UIKit

/**
 Radio show detail view controller
 */
class RadioShowDetailTableViewController: UITableViewController {

    // MARK: - Model
    
    /// The RadioShow we are showing the details of
    public var radioShow: RadioShow?
    
    // MARK: - ViewController Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableView.automaticDimension
    }
    
    override func viewDidAppear(_ animated: Bool) {
        tableView.reloadData()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RadioShowDetail", for: indexPath)
        // Configure the cell...
        if let radioShowDetailCell = cell as? RadioShowDetailTableViewCell {
            // set contents of radioShowCell
            radioShowDetailCell.radioShow = radioShow
        }
        return cell
    }

}
