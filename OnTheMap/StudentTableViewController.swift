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
    
    //var users:[StudentInformation] = [StudentInformation]()
    var filteredUsers: [StudentInformation]!  {
        return ParseClient.sharedInstance().users
    }


    override func viewDidLoad() {
        //filteredUsers = ParseClient.sharedInstance().users
        
        super.viewDidLoad()
        
        
        //refresh()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.reloadData()
    }
    
    func refresh() {
        
//        if tableView == nil {
//            return
//        }
        
        return
//        dispatch_async(dispatch_get_main_queue(), {
//            
//        })
        
//        ParseClient.sharedInstance().getStudentLocations() { users, errorString -> Void in
//            
//            // GUARD: users must not be nil
//            guard let users = users else {
//                if let errorString = errorString {
//                    self.alert(errorString)
//                }
//                else {
//                    self.alert("Error fetching user locations")
//                }
//                return
//            }
//            
//            //self.users = users
//            self.filteredUsers = users
//            
//            dispatch_async(dispatch_get_main_queue(), {
//                self.tableView.reloadData()
//            })
//        }
        
    }

}

// MARK: - StudentTableViewController: UISearchBarDelegate

extension StudentTableViewController: UISearchBarDelegate {
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        
//        let users = ParseClient.sharedInstance().users!
//        
//        filteredUsers = searchText != "" ?  users.filter({"\($0.firstName) \($0.lastName)".containsString(searchText)}) :  users
//        tableView.reloadData()
    }
}

// MARK: - StudentTableViewController: UITableViewDelegate, UITableViewDataSource

extension StudentTableViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        /* Get cell type */
        let cellReuseIdentifier = "StudentLocationViewCell"
        let user = filteredUsers[indexPath.row]
        print("\(indexPath.row) - \(user.firstName) \(user.lastName) \(user.longitude)")
        let cell = tableView.dequeueReusableCellWithIdentifier(cellReuseIdentifier)!

        /* Set cell defaults */
        cell.textLabel?.text = "\(user.firstName) \(user.lastName)"
        
//        //add the pin
//        let annotation = MKPointAnnotation()
//        annotation.coordinate = CLLocationCoordinate2D(latitude: user.latitude!, longitude: user.longitude!)
//        cell.mapView.addAnnotation(annotation)
//        cell.mapView.setRegion(MKCoordinateRegion(center: annotation.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)), animated: true)
        
//        cell.mapView.zoomEnabled = false;
//        cell.mapView.scrollEnabled = false;
//        cell.mapView.userInteractionEnabled = false;
        
        
        //cell.detailTextLabel?.text = "\(user.url!)"
        
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
        return 150
    }
}
