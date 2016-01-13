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
    var user: StudentInformation!
    
    var rootPresentingController: UIViewController!
    
    @IBOutlet weak var enterLinkTextView: UITextView!
    
    // strong reference to the delegate
    var placeHolderDelegate: PlaceHolderTextViewDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        placeHolderDelegate = PlaceHolderTextViewDelegate(placeHolder: enterLinkTextView.text)
        enterLinkTextView.delegate = placeHolderDelegate
        
        //add the pin
        let annotation = MKPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2D(latitude: user!.latitude!, longitude: user! .longitude!)
        mapView.addAnnotation(annotation)
        mapView.setRegion(MKCoordinateRegion(center: annotation.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)), animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func submitLinkButtonTouch(sender: AnyObject) {
        
        guard let inputUrl = enterLinkTextView.text where inputUrl != "" else {
            alert("Please enter a proper url for the link")
            return
        }
        
        //see if the user has already been submitted
        ParseClient.sharedInstance().searchForStudenLocation(user!.userId) {
            user, errorString -> Void in
            
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
                    )) {
                        success, errorString -> Void in
                        return
                }
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
                    )) {
                        success, errorString -> Void in
                        return
                }
            }
        }
    }
    @IBAction func cancelButtonTouch(sender: AnyObject) {
        
        // we need to dismiss at the root to also dismiss all of the modals that may have presented this one
        rootPresentingController.dismissViewControllerAnimated(true, completion: nil)
    }
}
