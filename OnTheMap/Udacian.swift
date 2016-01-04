//
//  Udacian.swift
//  OnTheMap
//
//  Created by Paul Salinas on 2016-01-03.
//  Copyright © 2016 Paul Salinas. All rights reserved.
//

import Foundation

struct Udacian {
    let firstName: String
    let lastName: String
    let userId: String
    
    /* Construct a Udacian from a dictionary */
    init(dictionary: [String : AnyObject]) {
        firstName = dictionary[UdacityClient.JSONResponseKeys.FirstName] as! String
        lastName = dictionary[UdacityClient.JSONResponseKeys.LastName] as! String
        userId = dictionary[UdacityClient.JSONResponseKeys.UserID] as! String
    }
}
