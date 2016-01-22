//
//  PinMapViewController.swift
//  OnTheMap
//
//  Created by Paul Salinas on 2016-01-04.
//  Copyright © 2016 Paul Salinas. All rights reserved.
//

import UIKit
import MapKit


class PinMapViewController: UIViewController, MKMapViewDelegate, Refreshable, Alertable {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var loadingOverlayView: UIView!
    @IBOutlet weak var loadingIndicatorView: UIActivityIndicatorView!
    
    // MARK: - Refreshable
    
    func refreshindicator(isShowing isShowing: Bool) {
        
        // for animation, we need to unhide the indicators
        let hidden = !isShowing
        
        loadingIndicatorView.hidden = hidden
        loadingOverlayView.hidden = hidden
    }
    
    func refresh() {
        
        // make sure we access to the list of users from the model
        guard let users = ParseClient.sharedInstance().users else {
            alert("There's an issue communicating with the server. Please refresh and try again...")
            return
        }
        
        // clear the map for new annotations
        removeMapAnnotations()
        
        // map users into annotations
        let annotations = users.map {
            user -> MKPointAnnotation in
            
            let lat = CLLocationDegrees(user.latitude!)
            let long = CLLocationDegrees(user.longitude!)
            
            let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
            
            let first = user.firstName
            let last = user.lastName
            let mediaURL = user.url!
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = "\(first) \(last)"
            annotation.subtitle = mediaURL
            
            return annotation
        }
        
        // pin them on the map
        mapView.addAnnotations(annotations)
    }
    
    // MARK: - MKMapViewDelegate
    
    // Here we create a view with a "right callout accessory view". 
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = UIColor.redColor()
            pinView!.rightCalloutAccessoryView = UIButton(type: .DetailDisclosure)
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    
    
    // This delegate method is implemented to respond to taps. It opens the system browser
    // to the URL specified in the annotationViews subtitle property.
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            let app = UIApplication.sharedApplication()
            if let toOpen = view.annotation?.subtitle! {
                app.openURL(NSURL(string: toOpen)!)
            }
        }
    }
    
    // MARK: - Helpers
    
    /* removes all of the annotations on the map */
    func removeMapAnnotations() {
        let annotationsToRemove = mapView.annotations.filter { $0 !== mapView.userLocation }
        mapView.removeAnnotations( annotationsToRemove )
    }
}
