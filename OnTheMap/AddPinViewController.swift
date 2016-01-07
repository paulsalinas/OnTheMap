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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
            
            guard let location = placemarks?.first?.location else {
                self.alert("Location can not be Found")
                return
            }
        
            let controller = self.storyboard!.instantiateViewControllerWithIdentifier("SubmitPinViewController") as! SubmitPinViewController
            controller.rootPresentingController = self.presentingViewController
            controller.location = location
            self.presentViewController(controller, animated: false, completion: nil)
        }
    }

}