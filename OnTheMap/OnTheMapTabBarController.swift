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
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        refreshAllTabbedViewControllers()
    }
    
    @IBAction func refreshButtonTouch(sender: AnyObject) {
        
        refreshAllTabbedViewControllers()
    }
    
    @IBAction func pinButtonTouch(sender: AnyObject) {
        ParseClient.sharedInstance().searchForStudenLocation(user!.userId) { user, errorString -> Void in
            
            // closure to show the next controller
            let showAddPinController = { (user: StudentInformation?) -> Void in
                let controller = self.storyboard!.instantiateViewControllerWithIdentifier("AddPinViewController") as! AddPinViewController
                controller.user = user
                self.presentViewController(controller, animated: true, completion: nil)
            }
            
            // user has already placed a location?
            if let user = user {
                
                //alert them with the ability to overwrite
                let alert = UIAlertController(title: "", message: "\(user.firstName) \(user.lastName) already has input a location do you want to overwrite?", preferredStyle: UIAlertControllerStyle.Alert)
                
                alert.addAction(UIAlertAction(title: "Overwrite", style: UIAlertActionStyle.Default){
                    alert -> Void in
                    
                    dispatch_async(dispatch_get_main_queue(), {
                        showAddPinController(user)
                    })
                })
                alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default, handler: nil))
                
                dispatch_async(dispatch_get_main_queue(), {
                    self.presentViewController(alert, animated: true, completion: nil)
                })
            }
            else {
                
                // no existing user? let user do what they initially intended
                dispatch_async(dispatch_get_main_queue(), {
                    showAddPinController(user)
                })
            }
        }
       
    }
    
    /* function to refresh all of the tab's child controllers */
    func refreshAllTabbedViewControllers() {
        
        // refresh all tabbed controllers that are Refreshable
        for vc in viewControllers! {
            if let vc = vc as? Refreshable {
                vc.refresh()
            }
        }
    }
}
