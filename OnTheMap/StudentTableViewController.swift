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
    
    var users:[StudentInformation]! {
        return ParseClient.sharedInstance().users
    }

    var filteredUsers: [StudentInformation]! = [StudentInformation]()
    var loaded : Bool = false
    
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
        
        if tableView == nil {
            return
        }

        self.filteredUsers = self.users
        tableView.reloadData()
        self.searchBar!.text = ""
    }

}

// MARK: - StudentTableViewController: UISearchBarDelegate

extension StudentTableViewController: UISearchBarDelegate {
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        
        filteredUsers = searchText != "" ?  users.filter({"\($0.firstName) \($0.lastName)".containsString(searchText)}) :  users
        tableView.reloadData()
    }
}

// MARK: - StudentTableViewController: UITableViewDelegate, UITableViewDataSource

extension StudentTableViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        /* Get cell type */
        let cellReuseIdentifier = "StudentLocationViewCell"
        let user = filteredUsers[indexPath.row]
        let cell = tableView.dequeueReusableCellWithIdentifier(cellReuseIdentifier) as! OnTheMapTableViewCell

        /* Set cell defaults */
        cell.name!.text = "\(user.firstName) \(user.lastName)"
        cell.url!.text = "\(user.url!)"
        cell.location!.text = "- \(user.mapString!)"
        
        //add the pin
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
    
//    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        
////        /* Push the movie detail view */
////        let controller = self.storyboard!.instantiateViewControllerWithIdentifier("MovieDetailViewController") as! MovieDetailViewController
////        controller.movie = movies[indexPath.row]
////        self.navigationController!.pushViewController(controller, animated: true)
//    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 200
    }
}
