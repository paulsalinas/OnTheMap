//
//  StudentInformation.swift
//  OnTheMap
//
//  Created by Paul Salinas on 2016-01-03.
//  Copyright © 2016 Paul Salinas. All rights reserved.
//

import Foundation

struct StudentInformation {
    let firstName: String
    let lastName: String
    let userId: String
    let url: String?
    let longitude: Double?
    let latitude: Double?
    
    init (parseDictionary: [String: AnyObject]){
        firstName = parseDictionary[ParseClient.JSONResponseKeys.FirstName] as! String
        lastName = parseDictionary[ParseClient.JSONResponseKeys.LastName] as! String
        userId = parseDictionary[ParseClient.JSONResponseKeys.UserID] as! String
        url = parseDictionary[ParseClient.JSONResponseKeys.Url] as! String?
        longitude = parseDictionary[ParseClient.JSONResponseKeys.Longitude] as! Double?
        latitude = parseDictionary[ParseClient.JSONResponseKeys.Latitude] as! Double?
    }
    
    init (udacityDictionary: [String: AnyObject]) {
        firstName = udacityDictionary[UdacityClient.JSONResponseKeys.FirstName] as! String
        lastName = udacityDictionary[UdacityClient.JSONResponseKeys.LastName] as! String
        userId = udacityDictionary[UdacityClient.JSONResponseKeys.UserID] as! String
        url = nil
        longitude = nil
        latitude = nil
    }
}
