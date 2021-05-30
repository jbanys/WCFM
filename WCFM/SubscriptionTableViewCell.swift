//
//  SubscriptionTableViewCell.swift
//  WCFM
//
//  Created by Matt Newman on 11/11/18.
//  Copyright © 2018 Matt Newman. All rights reserved.
//

import UIKit

/**
 A custom table cell view for showing a radio show in the subscriptions tab
 */
class SubscriptionTableViewCell: UITableViewCell {

    // Outlets to the UI components in our SubscriptionTableViewCell
    @IBOutlet weak var showTitleLabel: UILabel!
    @IBOutlet weak var timeSlotLabel: UILabel!
    
    /// The RadioShow to show in this view
    public var radioShow: RadioShow? {
        didSet {
            updateUI()
        }
    }
    
    private func updateUI() {
        if let radioShow = radioShow {
            showTitleLabel.text = radioShow.title
            timeSlotLabel.text = radioShow.dayTimeDescription
        }
    }
    

}
