//
//  LoadingScreenViewController.swift
//  WCFM
//
//  Created by Matt Newman on 11/29/18.
//  Copyright © 2018 Matt Newman. All rights reserved.
//

import UIKit

/**
 Loading screen view controller
 */
class LoadingScreenViewController: UIViewController {

    /// outlet for spinner
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    // MARK: - ViewController Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        spinner?.startAnimating()
        DispatchQueue.global().async {
            SchedulePopulator.loadSchedule()
            SchedulePopulator.updateSubscriptions()
            DispatchQueue.main.async { [weak self] in
                self?.spinner?.stopAnimating()
                self?.performSegue(withIdentifier: "TabView", sender: self)
            }
        }
        
    }

}
