//
//  OnTheMapTabBarController.swift
//  OnTheMap
//
//  Created by Paul Salinas on 2016-01-04.
//  Copyright © 2016 Paul Salinas. All rights reserved.
//

import UIKit

class OnTheMapTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func refreshButtonTouch(sender: AnyObject) {
        
        // refresh all tabbed controllers that are Refreshable
        for vc in viewControllers! {
            if let vc = vc as? Refreshable {
                vc.refresh()
            }
        }
    }
}
