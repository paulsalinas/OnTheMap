//
//  OnTheMapTabBarController.swift
//  OnTheMap
//
//  Created by Paul Salinas on 2016-01-04.
//  Copyright © 2016 Paul Salinas. All rights reserved.
//

import UIKit

class OnTheMapTabBarController: UITabBarController {

    var user: StudentInformation!
    var parseClient: ParseClient!
    var userLocations: [StudentInformation]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
        //initialize parseClient and get the user locations
        parseClient = ParseClient.sharedInstance()
        parseClient.getUserLocations() { users, errorString -> Void in
            print(users)
            return
        }
    }
}
