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
        
        // 1) validate user input
        guard let username = usernameInput.text, password = passwordInput.text  else {
            showWarningAlert("Empty Email or Password")
            return
        }
        
        if username == ""  || password == "" {
            showWarningAlert("Empty Email or Password")
            return
        }
        
        // 2) authenticate user
        UdacityClient.sharedInstance().authenticate(username, password: password) {
            success, error -> Void in
            
            if success {
               print("sucess!!")
            } else {
                dispatch_async(dispatch_get_main_queue(), {
                    self.showWarningAlert("Invalid Email or Password")
                })
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

