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
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        refreshAllTabbedViewControllers()
    }
    
    /* function to refresh all of the tab's child controllers */
    func refreshAllTabbedViewControllers() {
        
        self.viewControllers?.forEach({ ($0 as! Refreshable).setRefreshAnimation(isAnimating: true) })
        
        ParseClient.sharedInstance().getStudentLocations() { users, errorString -> Void in
            
            dispatch_async(dispatch_get_main_queue(), {
                self.viewControllers?.forEach({
                    let vc = $0 as! Refreshable
                    vc.refresh()
                    vc.setRefreshAnimation(isAnimating: false)
                })
            })
            
        }
    }
    
    
    // MARK: - Touch Button Handlers
    
    @IBAction func refreshButtonTouch(sender: AnyObject) {
        
        refreshAllTabbedViewControllers()
    }
    
    /* THIS WAS USED FOR TESTING */
    @IBAction func deleteButtonTouch(sender: AnyObject) {
        ParseClient.sharedInstance().searchForStudenLocation(user!.userId) { user, errorString -> Void in
            
            // user has already placed a location?
            if let user = user {
                ParseClient.sharedInstance().deleteStudentLocation(user) {
                    success, errorString -> Void in
                    dispatch_async(dispatch_get_main_queue(), {
                        self.refreshAllTabbedViewControllers()
                    })
                }
            }
        }
    }
    
    @IBAction func signOutButtonTouch(sender: AnyObject) {
        UdacityClient.sharedInstance().logOutOfSession() {
            success, errorString -> Void in
            
            dispatch_async(dispatch_get_main_queue(), {
                if success {
                    self.dismissViewControllerAnimated(true, completion: nil)
                } else {
                    self.alert(errorString!)
                }
            })
        }
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
                    showAddPinController(self.user)
                })
            }
        }
       
    }
}
