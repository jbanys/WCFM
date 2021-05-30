//
//  SubscriptionTableViewController.swift
//  WCFM
//
//  Created by Matt Newman on 11/11/18.
//  Copyright © 2018 Matt Newman. All rights reserved.
//

import UIKit

/**
 Subscription table view controller
 */
class SubscriptionTableViewController: UITableViewController {
    
    // MARK: - ViewController Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableView.automaticDimension
        self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func viewDidAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    // MARK: - Table view data source

    /// Returns: The number of sections in our model
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    /// Returns: The number of rows in a section of our model
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Subscriptions.count
    }
    
    /// Sets the color of header section
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let headerView = view as? UITableViewHeaderFooterView {
            headerView.contentView.backgroundColor = #colorLiteral(red: 0.3293734789, green: 0.3294344246, blue: 0.3293649554, alpha: 1)
            headerView.textLabel?.textColor = .white
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Subscriptions"
    }

    /// Returns: The UITableView
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RadioShow", for: indexPath)
        // Configure the cell...
        let radioShowName = Subscriptions.get(at: indexPath.row)
        let radioShow = Schedule.instance.getRadioShow(named: radioShowName)
        if let radioShowCell = cell as? SubscriptionTableViewCell {
            // set contents of radioShowCell
            radioShowCell.radioShow = radioShow
        }
        return cell
    }
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            Subscriptions.deleteAtIndex(index: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }

    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "RadioShowDetail" {
            /// Segue to the details controller you'll be building...
            if let cell = sender as? SubscriptionTableViewCell,
                let indexPath = tableView.indexPath(for: cell) {
                let radioShowName = Subscriptions.get(at: indexPath.row)
                let radioShow = Schedule.instance.getRadioShow(named: radioShowName)
                if let detailViewController = segue.destination as? RadioShowDetailTableViewController {
                    detailViewController.radioShow = radioShow
                }
            }
        }
    }
    
}
