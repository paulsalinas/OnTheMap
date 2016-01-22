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
    
    var overlayView: UIView!
    var activityIndicator: UIActivityIndicatorView!
    
    // our main source of unfiltered users
    var users:[StudentInformation]! {
        return ParseClient.sharedInstance().users
    }
    
    // our main collection to be used in the table. it essentially holds our filtered result
    var filteredUsers: [StudentInformation]! = [StudentInformation]()
    
    // track the state if we've loaded already. used in 'viewWillAppear'
    var loaded : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // setup of overlay view and activity indicator
        // exact positioning will be determined later by the tableview
        overlayView = UIView()
        activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.WhiteLarge)
        activityIndicator.startAnimating()
        activityIndicator.color = UIColor.blackColor()
        overlayView.alpha = 0.7
        overlayView.backgroundColor = UIColor.whiteColor()
        overlayView.addSubview(activityIndicator)
    }

    
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
    
    func setRefreshAnimation(isAnimating isAnimating: Bool) {
        if tableView == nil {
            return
        }
        
        if (isAnimating) {
            
            // set positioning of the overlay and action indicator before "showing" it
            overlayView.frame = tableView.bounds
            activityIndicator.center = CGPointMake(overlayView.frame.size.width / 2, (overlayView.frame.size.height / 2))
            tableView.addSubview(overlayView)
        } else {
            overlayView.removeFromSuperview()
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
        
        cell.detailTextLabel?.text = "\(user.url!)"
        
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredUsers.count
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let user = filteredUsers[indexPath.row]
        let app = UIApplication.sharedApplication()
        let url = user.url!
        app.openURL(NSURL(string: url)!)
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 200
    }
}
