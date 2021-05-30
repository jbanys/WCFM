//
//  RadioShowDetailTableViewCell.swift
//  WCFM
//
//  Created by Matt Newman on 11/13/18.
//  Copyright © 2018 Matt Newman. All rights reserved.
//

import UIKit

/**
 A custom table cell view for showing the details of a radio show
 */
class RadioShowDetailTableViewCell: UITableViewCell {
    
    // MARK: - Model
    
    /// The RadioShow to show in this view
    public var radioShow: RadioShow? {
        didSet {
            updateUI()
        }
    }
    
    // MARK: - Outlets
    
    @IBOutlet weak var showTitleLabel: UILabel!
    @IBOutlet weak var hostsLabel: UILabel!
    @IBOutlet weak var timeSlotLabel: UILabel!
    @IBOutlet weak var subscribeSwitch: UISwitch!
    @IBOutlet weak var coverArt: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var genresLabel: UILabel!
    
   // MARK: - Methods
    
    @IBAction func toggleSubscribe(_ subscribeSwitch: UISwitch) {
         if !subscribeSwitch.isOn {
            Subscriptions.remove(title: radioShow!.title)
            subscribeSwitch.setOn(false, animated: true)
        } else {
            Subscriptions.add(title: radioShow!.title)
            subscribeSwitch.setOn(true, animated: true)
        }
    }
    
    private func updateUI() {
        if let radioShow = radioShow {
            
            let titleAttributes = [
                //NSAttributedString.Key.foregroundColor: UIColor.blue,
                //NSAttributedString.Key.backgroundColor: UIColor.red,
                NSAttributedString.Key.font: UIFont(name: "Avenir-Book", size: 30)! // just testing font here
            ]
            
            showTitleLabel.attributedText = NSAttributedString(string: radioShow.title, attributes: titleAttributes)
            //hostsLabel.text = "Hosts: \(radioShow.hosts)"
            hostsLabel.text = "\(radioShow.hosts)"
            timeSlotLabel.text = radioShow.dayTimeDescription
            descriptionLabel.text = radioShow.description
            genresLabel.text = "Genres: \(radioShow.genres)"
            if Subscriptions.contains(title: radioShow.title) {
                subscribeSwitch.setOn(true, animated: false)
            } else {
                subscribeSwitch.setOn(false, animated: false)
            }
            
            if let imageURL = radioShow.imageURL {
                DispatchQueue.global().async { [weak self] in
                    let imageData = try? Data(contentsOf: imageURL)
                    DispatchQueue.main.async {
                        if let data = imageData {
                            self?.coverArt.image = UIImage(data: data)
                        }
                    }
                }
            }
        }
    }
}
