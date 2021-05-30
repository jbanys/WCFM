//
//  ScheduleTableViewCell.swift
//  WCFM
//
//  Created by Matt Newman on 11/11/18.
//  Copyright © 2018 Matt Newman. All rights reserved.
//

import UIKit

/**
 A custom table cell view for showing a radio show in the schedule tab
 */
class ScheduleTableViewCell: UITableViewCell {

    // Outlets to the UI components in our ScheduleTableViewCell
    @IBOutlet private weak var showTitleLabel: UILabel!
    @IBOutlet private weak var timeSlotLabel: UILabel!
    
    /// The RadioShow to show in this view
    public var radioShow: RadioShow? {
        didSet {
            updateUI()
        }
    }
    
    private func updateUI() {
        if let radioShow = radioShow {
            if radioShow.board {
                let attributedString1 = NSMutableAttributedString(string: radioShow.title)
                let attributes = [
                    NSAttributedString.Key.foregroundColor: UIColor.red,
                    NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: UIFont.systemFontSize)
                ]
                let attributedString2 = NSAttributedString(string: " (WCFM board)", attributes: attributes)
                attributedString1.append(attributedString2)
                showTitleLabel.attributedText = attributedString1
            } else {
                showTitleLabel.text = radioShow.title
            }
            timeSlotLabel.text = radioShow.timeDescription
        }
    }

}
