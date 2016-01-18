//
//  StudentTableViewController.swift
//  OnTheMap
//
//  Created by Paul Salinas on 2016-01-17.
//  Copyright © 2016 Paul Salinas. All rights reserved.
//

import UIKit

class StudentTableViewController: UIViewController, Alertable {

    @IBOutlet weak var tableView: UITableView!
    var users:[StudentInformation] = [StudentInformation]()

    override func viewDidLoad() {
        super.viewDidLoad()
        refresh()

        // Do any additional setup after loading the view.
    }

    func refresh() {
        ParseClient.sharedInstance().getStudentLocations() { users, errorString -> Void in
            
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
            
            self.users = users
            
            dispatch_async(dispatch_get_main_queue(), {
                self.tableView.reloadData()
            })
        }
        
    }

}

extension StudentTableViewController:  UITableViewDelegate, UITableViewDataSource {
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        /* Get cell type */
        let cellReuseIdentifier = "StudentLocationViewCell"
        let user = users[indexPath.row]
        let cell = tableView.dequeueReusableCellWithIdentifier(cellReuseIdentifier) as UITableViewCell!

        /* Set cell defaults */
        cell.textLabel!.text = "\(user.firstName) \(user.lastName)"
        
        cell.detailTextLabel?.text = "\(user.url!)"
        
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
//    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        
////        /* Push the movie detail view */
////        let controller = self.storyboard!.instantiateViewControllerWithIdentifier("MovieDetailViewController") as! MovieDetailViewController
////        controller.movie = movies[indexPath.row]
////        self.navigationController!.pushViewController(controller, animated: true)
//    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 100
    }
}
