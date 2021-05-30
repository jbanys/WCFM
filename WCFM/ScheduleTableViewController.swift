//
//  ScheduleTableViewController.swift
//  WCFM
//
//  Created by Matt Newman on 11/11/18.
//  Copyright © 2018 Matt Newman. All rights reserved.
//

import UIKit

/**
 Schedule table view controller
 */
class ScheduleTableViewController: UITableViewController, UISearchBarDelegate {
    
    // MARK: - ViewController Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableView.automaticDimension
    }
    
    override func viewDidAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    // MARK: - Search Bar Controls
    
    /// Seach bar outlet
    @IBOutlet weak var searchBar: UISearchBar! {
        didSet {
            searchBar.delegate = self
        }
    }
    
    /// Reloads table with a filter when the text field of search bar changes
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.count > 0 {
            Schedule.instance.search = true
            Schedule.instance.filterShows(keyword: searchText)
            
        } else {
            Schedule.instance.clearFiltered()
            Schedule.instance.search = false
        }
        tableView.reloadData()
    }
    
    /// Hides keyboard after user presses Search
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.searchBar.resignFirstResponder()
    }
    
    /// Hides keyboard when user scrolls
    override func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.searchBar.resignFirstResponder()
    }

    // MARK: - Table view data source

    /// Returns: The number of sections in our model
    override func numberOfSections(in tableView: UITableView) -> Int {
        if Schedule.instance.search {
            return Schedule.instance.numberOfCategories()
        }
        
        return Schedule.instance.numberOfDays
    }

    /// Returns: The number of rows in a section of our model
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if Schedule.instance.search {
            return Schedule.instance.numberOfShows(category: Schedule.FilterCategory(rawValue: section)!)
        }
        
        return Schedule.instance.numberOfShows(on: Day(rawValue: section)!)
    }

    /// Returns: A header for a given section that is just a section number.
    /// The first section has the largest number. The last has number 1.
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if Schedule.instance.search {
            return Schedule.FilterCategory(rawValue: section)?.string
        }
        
        return Day(rawValue: section)?.string
    }
    
    /// Sets the color of header section
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let headerView = view as? UITableViewHeaderFooterView {
            headerView.contentView.backgroundColor = #colorLiteral(red: 0.3293734789, green: 0.3294344246, blue: 0.3293649554, alpha: 1)
            headerView.textLabel?.textColor = .white
        }
    }

    /// Returns: The UITableView
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RadioShow", for: indexPath)
        // Configure the cell...
        let radioShow : RadioShow?
        if Schedule.instance.search {
            radioShow = Schedule.instance.getFilteredRadioShow(for: indexPath.section, atIndex: indexPath.row)
        } else {
            radioShow = Schedule.instance.getRadioShow(on: indexPath.section, atIndex: indexPath.row)
        }
   
        if let radioShowCell = cell as? ScheduleTableViewCell {
            // set contents of radioShowCell
            radioShowCell.radioShow = radioShow
        }
        return cell
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "RadioShowDetail" {
            /// Segue to the details controller you'll be building...
            if let cell = sender as? ScheduleTableViewCell,
                let indexPath = tableView.indexPath(for: cell) {
                let radioShow : RadioShow?
                if Schedule.instance.search {
                    radioShow = Schedule.instance.getFilteredRadioShow(for: indexPath.section, atIndex: indexPath.row)
                } else {
                    radioShow = Schedule.instance.getRadioShow(on: indexPath.section, atIndex: indexPath.row)
                }

                if let detailViewController = segue.destination as? RadioShowDetailTableViewController {
                    detailViewController.radioShow = radioShow
                }
            }
        }
    }


}
