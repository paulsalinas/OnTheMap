//
//  SubmitPinViewController.swift
//  OnTheMap
//
//  Created by Paul Salinas on 2016-01-06.
//  Copyright © 2016 Paul Salinas. All rights reserved.
//

import UIKit
import MapKit

class SubmitPinViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    var user: StudentInformation?
    
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
    
    @IBAction func cancelButtonTouch(sender: AnyObject) {
        
        // we need to dismiss at the root to also dismiss all of the modals that may have presented this one
        rootPresentingController.dismissViewControllerAnimated(true, completion: nil)
    }
}
