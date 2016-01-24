//
//  AddPinViewController.swift
//  OnTheMap
//
//  Created by Paul Salinas on 2016-01-05.
//  Copyright © 2016 Paul Salinas. All rights reserved.
//

import UIKit
import CoreLocation


class AddPinViewController: UIViewController, UIGestureRecognizerDelegate, Alertable {

    @IBOutlet weak var enterLocationTextView: UITextView!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    var user: StudentInformation?
    var keyboardDismisser: KeyboardDismisser!
    
    // strong reference to the delegate
    var placeHolderDelegate: PlaceHolderTextViewDelegate?
    
//    var overlayView: UIView!
//    var activityIndicator: UIActivityIndicatorView!
    
    let activityOverlay = ActivityOverlay(alpha: 0.6, activityIndicatorColor: UIColor.whiteColor(), overlayColor: UIColor.blackColor())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        placeHolderDelegate = PlaceHolderTextViewDelegate(placeHolder: enterLocationTextView.text)
        enterLocationTextView.delegate = placeHolderDelegate
        
        /* Configure tap recognizer */
        let tapRecognizer = UITapGestureRecognizer(target: self, action: "handleSingleTap:")
        tapRecognizer.numberOfTapsRequired = 1
        tapRecognizer.delegate = self
        self.view.addGestureRecognizer(tapRecognizer)
        
        // will give the vc the behavior to able to dismiss the keyboard 'on tap'
        keyboardDismisser = KeyboardDismisser(viewController: self)
    }
    
    // MARK: Dismissals
    
    func handleSingleTap(recognizer: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    // MARK: - Button Touch Events

    @IBAction func cancelButtonTouch(sender: AnyObject) {
        presentingViewController!.dismissViewControllerAnimated(true, completion: nil)
    }

    @IBAction func findOnTheMapButtonTouch(sender: AnyObject) {
        
        // GUARD - Ensure that the textfield has text
        guard let locationString = enterLocationTextView.text where locationString != "" else {
            alert("Location can not be empty")
            return
        }
        
        // Geocode the string
        let geocode = CLGeocoder()
        activityOverlay.overlay(enterLocationTextView.superview!)
        geocode.geocodeAddressString(locationString) {(placemarks, error)->Void in
            
            if error != nil {
                dispatch_async(dispatch_get_main_queue(), {
                    self.activityOverlay.removeOverlay()
                    self.alert("There was an errror geocoding your input")
                    })
                return
            }
            
            guard let location = placemarks?.first?.location, name = placemarks?.first?.name, user = self.user else {
                dispatch_async(dispatch_get_main_queue(), {
                    self.activityOverlay.removeOverlay()
                    self.alert("Location can not be Found")
                })
                return
            }
            
            let controller = self.storyboard!.instantiateViewControllerWithIdentifier("SubmitPinViewController") as! SubmitPinViewController
            
            controller.rootPresentingController = self.presentingViewController
            controller.user = StudentInformation(
                firstName: user.firstName,
                lastName: user.lastName,
                userId: user.userId,
                url: nil,
                longitude: location.coordinate.longitude,
                latitude: location.coordinate.latitude,
                mapString: name,
                objectId: nil
            )
            
            dispatch_async(dispatch_get_main_queue(), {
                self.activityOverlay.removeOverlay()
                self.presentViewController(controller, animated: false, completion: nil)
            })
        }
    }
}
