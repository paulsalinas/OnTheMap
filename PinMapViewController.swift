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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        refresh()
    }
    
    func refresh() {
        ParseClient.sharedInstance().getUserLocations() { users, errorString -> Void in
            
            // GUARD: users must not be nil
            guard let users = users else {
                if let errorString = errorString {
                    self.alert(errorString)
                }
                else {
                    self.alert("Error fetching user locations")
                }
                return
            }
            
            // convert the users into annotations and then add them to the map
            var annotations = [MKPointAnnotation]()
            
            for user in users {
                
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
                
                annotations.append(annotation)
            }
            
            dispatch_async(dispatch_get_main_queue(), {
                
                self.mapView.addAnnotations(annotations)
            })
        }
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
}
