//
//  ViewController.swift
//  OnTheMap
//
//  Created by Paul Salinas on 2015-12-30.
//  Copyright © 2015 Paul Salinas. All rights reserved.
//

import UIKit
import FBSDKLoginKit

// MARK: - LoginViewController: UIViewController

class LoginViewController: UIViewController, Alertable {

    @IBOutlet weak var usernameInput: UITextField!
    @IBOutlet weak var passwordInput: UITextField!
    @IBOutlet weak var loadingIndicatorView: UIActivityIndicatorView!

    @IBOutlet weak var fbLoginButton: FBSDKLoginButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fbLoginButton.delegate = self
    }
    
    /* present udacity login page */
    @IBAction func signUpButtonTouch(sender: AnyObject) {
        
        let app = UIApplication.sharedApplication()
        let udacitySignUpUrl = "http://www.udacity.com/account/auth#!/signup"
        app.openURL(NSURL(string: udacitySignUpUrl)!)
    }
    
    @IBAction func loginButtonTouch(sender: AnyObject) {
        
        loadingIndicatorView.hidden = false
        
        UdacityClient.sharedInstance().authenticateAndCreateSession(usernameInput.text!, password: passwordInput.text!) {
            success, error -> Void in
            
            // GUARD - Authentication must be successful
            guard success else {
                dispatch_async(dispatch_get_main_queue(), {
                    self.alert(error!)
                    self.loadingIndicatorView.hidden = true
                })
                return
            }
            
            self.fetchUserDataAndCompleteLogin()
        }
    }
    
    /* fetch the user id corresponding to the logged in user and complete the login and transition to next VC */
    func fetchUserDataAndCompleteLogin() {
        
        //get user id models
        UdacityClient.sharedInstance().getUserData() { (user, errorString) -> Void in
            
            // make sure to stop the animation when this code block ends
            defer {
                dispatch_async(dispatch_get_main_queue(), {
                    self.loadingIndicatorView.hidden = true
                })
            }
            
            // GUARD: check if we have valid user data
            guard let user = user else {
                dispatch_async(dispatch_get_main_queue(), {
                    if let errorString = errorString {
                        self.alert(errorString)
                    } else {
                        self.alert("Error occurred fetching user data")
                    }
                })
                return
            }
            
            // set the user id in the Parse Client which is required for the user specific client calls
            ParseClient.sharedInstance().userID = user.userId
            
            // launch the map view and pass the StudentInformation Model
            dispatch_async(dispatch_get_main_queue(), {
                let controller = self.storyboard!.instantiateViewControllerWithIdentifier("OnTheMapNavigationController") as! UINavigationController
                let tabController = controller.topViewController as! OnTheMapTabBarController
                tabController.user = user
                self.presentViewController(controller, animated: true, completion: nil)
                
                self.resetViewToInitialState()
            })
        }
    }
    
    /* resets the view to its initial state */
    func resetViewToInitialState() {
        passwordInput.text = ""
        usernameInput.text = ""
    }
}


// MARK: - LoginViewController: FBSDKLoginButtonDelegate

extension LoginViewController: FBSDKLoginButtonDelegate {
    
    /* facebook button delegate to handle the result from login */
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        
        // GUARD - do nothing if user cancelled
        if result.isCancelled {
            return
        }
        
        // GUARD - any errors?
        if let error = error {
            alert(error.localizedDescription)
            return
        }
        
        // GUARD - valid access token
        guard let accessToken = result.token?.tokenString else {
            alert("There was an error authenticating via Facebook")
            return
        }
        
        loadingIndicatorView.hidden = false
        
        // logout of FB once you've obtained an access token
        FBSDKLoginManager().logOut()
        
        
        UdacityClient.sharedInstance().createSessionWithFacebookToken(accessToken) {
            success, error -> Void in
            
            // GUARD - Authentication must be successful
            guard success else {
                dispatch_async(dispatch_get_main_queue(), {
                    self.alert(error!)
                    self.loadingIndicatorView.hidden = true
                })
                return
            }
            
            self.fetchUserDataAndCompleteLogin()
        }
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        
        //do nothing
        return
    }
    
}

