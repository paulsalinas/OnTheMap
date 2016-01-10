//
//  AddPinViewController.swift
//  OnTheMap
//
//  Created by Paul Salinas on 2016-01-05.
//  Copyright © 2016 Paul Salinas. All rights reserved.
//

import UIKit
import CoreLocation


class AddPinViewController: UIViewController, Alertable {

    @IBOutlet weak var enterLocationTextView: UITextView!
    
    var user: StudentInformation?
    
    // strong reference to the delegate
    var placeHolderDelegate: PlaceHolderTextViewDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        placeHolderDelegate = PlaceHolderTextViewDelegate(placeHolder: enterLocationTextView.text)
        enterLocationTextView.delegate = placeHolderDelegate
    }

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
        geocode.geocodeAddressString(locationString) {(placemarks, error)->Void in
            print(placemarks?.first?.location)
            
            guard let location = placemarks?.first?.location, name = placemarks?.first?.name, user = self.user else {
                self.alert("Location can not be Found")
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
                mapString: name)
            
            self.presentViewController(controller, animated: false, completion: nil)
        }
    }
}
