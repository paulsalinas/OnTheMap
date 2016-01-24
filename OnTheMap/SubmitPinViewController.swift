//
//  SubmitPinViewController.swift
//  OnTheMap
//
//  Created by Paul Salinas on 2016-01-06.
//  Copyright © 2016 Paul Salinas. All rights reserved.
//

import UIKit
import MapKit

class SubmitPinViewController: UIViewController, MKMapViewDelegate, Alertable {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var enterLinkTextView: UITextView!
    
    var user: StudentInformation!
    
    var rootPresentingController: UIViewController!
    
    let placeholderText = "Enter Link to Share Here"
    
    // strong reference to the delegate
    var placeHolderDelegate: PlaceHolderTextViewDelegate?
    
    let activityOverlay = ActivityOverlay(alpha: 0.6, activityIndicatorColor: UIColor.whiteColor(), overlayColor: UIColor.blackColor())
    
    var keyboardDismisser: KeyboardDismisser!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        placeHolderDelegate = PlaceHolderTextViewDelegate(placeHolder: placeholderText)
        enterLinkTextView.delegate = placeHolderDelegate
        
        // add the pin
        let annotation = MKPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2D(latitude: user!.latitude!, longitude: user! .longitude!)
        mapView.addAnnotation(annotation)
        mapView.setRegion(MKCoordinateRegion(center: annotation.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)), animated: true)
        
        // will give the vc the behavior to able to dismiss the keyboard 'on tap'
        keyboardDismisser = KeyboardDismisser(viewController: self)
    }
    
    @IBAction func submitLinkButtonTouch(sender: AnyObject) {
        
        guard let inputUrl = enterLinkTextView.text where inputUrl != "" && inputUrl != placeholderText else {
            alert("Please enter a proper url for the link")
            return
        }
        
        activityOverlay.overlay(mapView)
        
        //see if the user has already been submitted
        ParseClient.sharedInstance().searchForStudenLocation(user!.userId) {
            user, errorString -> Void in
            
            if let errorString = errorString {
                
                dispatch_async(dispatch_get_main_queue(), {
                    self.alert(errorString)
                    self.activityOverlay.removeOverlay()
                })
                
                return
            }
            
            let onComplete = {(success: Bool?, errorString: String?) -> Void in
                 dispatch_async(dispatch_get_main_queue(), {
                    if success == true {
                        self.rootPresentingController.dismissViewControllerAnimated(true, completion: nil)
                    } else {
                        self.alert(errorString!)
                    }
                    
                    self.activityOverlay.removeOverlay()
                })
            }
            
            
            if let user = user {
                
                //user was found, we send a "change" request
                ParseClient.sharedInstance().changeStudentLocation(
                    StudentInformation(
                        firstName: user.firstName,
                        lastName: user.lastName,
                        userId: user.userId,
                        
                        // from the input text
                        url: inputUrl,
                        longitude: self.user.longitude,
                        latitude: self.user.latitude,
                        mapString: self.user.mapString,
                        
                        // pass the object id from the search
                        objectId: user.objectId
                    ), completionHandler: onComplete)
            } else {
                
                //use was not found, we send an add request
                ParseClient.sharedInstance().addStudentLocation(
                    StudentInformation(
                        firstName: self.user.firstName,
                        lastName: self.user.lastName,
                        userId: self.user.userId,
                        
                        // from the input text
                        url: inputUrl,
                        longitude: self.user.longitude,
                        latitude: self.user.latitude,
                        mapString: self.user.mapString,
                        
                        // new add
                        objectId: nil
                    ), completionHandler: onComplete)
            }
        }
    }
    
    @IBAction func cancelButtonTouch(sender: AnyObject) {
        
        // we need to dismiss at the root to also dismiss all of the modals that may have presented this one
        rootPresentingController.dismissViewControllerAnimated(true, completion: nil)
    }

}
