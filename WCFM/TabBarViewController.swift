//
//  TabBarViewController.swift
//  WCFM
//
//  Created by Matt Newman on 11/29/18.
//  Copyright © 2018 Matt Newman. All rights reserved.
//

import UIKit

/**
 Tab bar view controller
 */
class TabBarViewController: UITabBarController, UITabBarControllerDelegate {

    // MARK: - ViewController Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
    }
    
    func tabBarController(_ tabBar: UITabBarController, didSelect: UIViewController) {
        didSelect.viewDidAppear(true)
    }

}
