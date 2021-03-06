//
//  StudentTableViewController.swift
//  OnTheMap
//
//  Created by Paul Salinas on 2016-01-17.
//  Copyright © 2016 Paul Salinas. All rights reserved.
//

import UIKit
import MapKit

// MARK: - StudentTableViewController

class StudentTableViewController: UIViewController, Alertable, Refreshable {

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var searchBar: UISearchBar!
    
   let activityOverlay = ActivityOverlay(alpha: 0.7, activityIndicatorColor: UIColor.blackColor(), overlayColor: UIColor.whiteColor())
    
    // our main source of unfiltered users
    var users:[StudentInformation]! {
        return StudentInformationCollection.sharedInstance().users
    }
    
    // our main collection to be used in the table. it essentially holds our filtered result
    var filteredUsers: [StudentInformation]! = [StudentInformation]()
    
    // track the state if we've loaded already. used in 'viewWillAppear'
    var loaded : Bool = false
    
    // colors
    let udacityOrange = UIColor(red: 1, green: 0.608, blue: 0.244, alpha: 1)
    let tableCellColor = UIColor (red: 0.271, green: 0.529, blue: 0.816, alpha: 1.0)
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        // TODO: - this prevents the view from reloading when toggling tabs. 
        //         would like to find an alternative to keeping this state variable
        if !loaded {
            refresh()
            loaded = true
        }
    }
    
    func refresh() {
        
        // in case the parent vc refreshes when we haven't loaded yet
        if tableView == nil {
            return
        }
        
        // make sure we access to the list of users from the model
        guard let users = users else {
            alert("There's an issue communicating with the server. Please refresh and try again...")
            return
        }
        
        // this is our initial state
        filteredUsers = users
        tableView.reloadData()
        searchBar!.text = ""
    }
    
    func refreshIndicator(isShowing isShowing: Bool) {
        if tableView == nil {
            return
        }
        
        if (isShowing) {
            activityOverlay.overlay(tableView)
        } else {
            activityOverlay.removeOverlay()
        }
    }
}

// MARK: - StudentTableViewController: UISearchBarDelegate

extension StudentTableViewController: UISearchBarDelegate {
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        
        // make sure we access to the list of users from the model
        guard let users = users else {
            alert("There's an issue communicating with the server. Please refresh and try again...")
            return
        }
        
        filteredUsers = searchText != "" ?  users.filter({"\($0.firstName) \($0.lastName)".containsString(searchText)}) :  users
        tableView.reloadData()
    }
}

// MARK: - StudentTableViewController: UITableViewDelegate, UITableViewDataSource

extension StudentTableViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        // get cell type
        let cellReuseIdentifier = "StudentLocationViewCell"
        let user = filteredUsers[indexPath.row]
        let cell = tableView.dequeueReusableCellWithIdentifier(cellReuseIdentifier) as! OnTheMapTableViewCell
        
        // set the values
        cell.name!.text = "\(user.firstName) \(user.lastName)"
        cell.url!.text = "\(user.url!)"
        cell.location!.text = "- \(user.mapString!)"
        
        // add the pin
        let annotation = MKPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2D(latitude: user.latitude!, longitude: user.longitude!)
        cell.mapView.addAnnotation(annotation)
        cell.mapView.setRegion(MKCoordinateRegion(center: annotation.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5)), animated: false)
        
        cell.mapView.zoomEnabled = false;
        cell.mapView.scrollEnabled = false;
        cell.mapView.userInteractionEnabled = false;
        
        cell.mapView.layer.cornerRadius = 10
        
        cell.detailTextLabel?.text = "\(user.url!)"
        
        return cell
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        
        // set the background color and the selection color
        cell.backgroundColor = tableCellColor
        
        let bgColorView = UIView()
        bgColorView.backgroundColor = udacityOrange
        cell.selectedBackgroundView = bgColorView
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredUsers.count
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let user = filteredUsers[indexPath.row]
        let app = UIApplication.sharedApplication()
        if let url = user.url {
            if let url = NSURL(string: url) {
                if url.scheme != "" && url.host != nil {
                    app.openURL(url)
                } else {
                    alert("The url for this student is invalid")
                }
            }
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 200
    }
}
