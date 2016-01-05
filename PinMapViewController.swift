//
//  PinMapViewController.swift
//  OnTheMap
//
//  Created by Paul Salinas on 2016-01-04.
//  Copyright © 2016 Paul Salinas. All rights reserved.
//

import UIKit
import MapKit

class PinMapViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        reloadData()
    }
    
    func reloadData() {
        ParseClient.sharedInstance().getUserLocations() { users, errorString -> Void in
            
            // GUARD: users must not be nil
            guard let users = users else {
                print("Error fetching user locations")
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
}
