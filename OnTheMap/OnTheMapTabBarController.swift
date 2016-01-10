//
//  OnTheMapTabBarController.swift
//  OnTheMap
//
//  Created by Paul Salinas on 2016-01-04.
//  Copyright © 2016 Paul Salinas. All rights reserved.
//

import UIKit

class OnTheMapTabBarController: UITabBarController, Alertable {
    
    var user: StudentInformation?
    
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
    
    @IBAction func pinButtonTouch(sender: AnyObject) {
        ParseClient.sharedInstance().searchForStudenLocation(user!.userId) { user, errorString -> Void in
            
            // TODO: check for user and alert them to overwrite or cancel. pass the user model to the add pin controller
            
            dispatch_async(dispatch_get_main_queue(), {
                let controller = self.storyboard!.instantiateViewControllerWithIdentifier("AddPinViewController")
                self.presentViewController(controller, animated: true, completion: nil)
            })
        }
       
    }
}
