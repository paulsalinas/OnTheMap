//
//  UdacityClient.swift
//  OnTheMap
//
//  Created by Paul Salinas on 2016-01-03.
//  Copyright © 2016 Paul Salinas. All rights reserved.
//

import Foundation

class UdacityClient : Client {
    
    // MARK: Properties
    
    /* Authentication state */
    var sessionID : String? = nil
    var userID : String? = nil
    
    // MARK: Initializers
    
    init() {
        super.init(url: Constants.BaseURLSecure)
    }
    
    // MARK: POST
    
    func taskForPOSTMethod(method: String, parameters: [String : AnyObject], jsonBody: [String:AnyObject], completionHandler: (result: AnyObject!, error: NSError?) -> Void) -> NSURLSessionDataTask {
        
        let httpHeaders = [
            ("application/json", "Accept"),
            ("application/json", "Content-Type"),
        ]
        
         return taskForPOSTMethod(method, parameters: parameters, jsonBody: jsonBody, httpHeaders: httpHeaders) { data, error -> Void in
            
            if let error = error {
                completionHandler(result: nil, error: error)
                return
            }
            
            guard let data = data else {
                completionHandler(result: nil, error: NSError(domain: "TaskForPostMethod", code: ErrorCodes.DataError, userInfo: [NSLocalizedDescriptionKey : "There was error in the data response from the server"]))
                return
            }
            
            let newData = data.subdataWithRange(NSMakeRange(5, data.length - 5))
            UdacityClient.parseJSONWithCompletionHandler(newData, completionHandler: completionHandler)
            
        }
    }
    
    class func sharedInstance() -> UdacityClient {
            
        struct Singleton {
            static var sharedInstance = UdacityClient()
        }
            
        return Singleton.sharedInstance
    }
    
    func taskForGETMethod(method: String, parameters: [String : AnyObject], completionHandler: (result: AnyObject!, error: NSError?) -> Void) -> NSURLSessionDataTask {
        
        return taskForGETMethod(method, parameters: parameters, httpHeaders: [(String, String)]()) { data, error -> Void in
            
            if let error = error {
                completionHandler(result: nil, error: error)
                return
            }
            
            guard let data = data else {
                completionHandler(result: nil, error: NSError(domain: "TaskForGetMethod", code: ErrorCodes.DataError, userInfo: [NSLocalizedDescriptionKey : "There was error in the data response from the server"]))
                return
            }
            
            let newData = data.subdataWithRange(NSMakeRange(5, data.length - 5))
            UdacityClient.parseJSONWithCompletionHandler(newData, completionHandler: completionHandler)
            
        }
    }
}
