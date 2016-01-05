//
//  ViewController.swift
//  OnTheMap
//
//  Created by Paul Salinas on 2015-12-30.
//  Copyright © 2015 Paul Salinas. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var usernameInput: UITextField!
    @IBOutlet weak var passwordInput: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func loginButtonTouch(sender: AnyObject) {
        
        // authenticate user
        UdacityClient.sharedInstance().authenticate(usernameInput.text!, password: passwordInput.text!) {
            success, error -> Void in
            
            // GUARD - Authentication must be successful
            guard success else {
                dispatch_async(dispatch_get_main_queue(), {
                    self.showWarningAlert(error!)
                })
                return
            }
            
            //get user id models
            print("success!")
            UdacityClient.sharedInstance().getUserData() { (user, errorString) -> Void in
                
                // GUARD: check if we have valid user data
                guard let user = user else {
                    if let errorString = errorString {
                        self.showWarningAlert(errorString)
                    } else {
                        self.showWarningAlert("Error occurred fetching user data")
                    }
                    return
                }
                
                // set the user id in the Parse Client which is required for the user specific client calls
                ParseClient.sharedInstance().userID = user.userId
                
                // launch the map view and pass the StudentInformation Model
                dispatch_async(dispatch_get_main_queue(), {
                    let controller = self.storyboard!.instantiateViewControllerWithIdentifier("OnTheMapNavigationController") as! UINavigationController
                    self.presentViewController(controller, animated: true, completion: nil)
                })
                
                return
            }
        }
    }
    
    // MARK: Helpers
    func showWarningAlert(message: String) {
        let alert = UIAlertController(title: "", message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
}

