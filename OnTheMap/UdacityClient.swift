//
//  UdacityClient.swift
//  OnTheMap
//
//  Created by Paul Salinas on 2016-01-03.
//  Copyright © 2016 Paul Salinas. All rights reserved.
//

import Foundation

class UdacityClient : NSObject {
    
    // MARK: Properties
    
    let baseClient : Client
    
    /* Authentication state */
    var sessionID : String? = nil
    var userID : String? = nil
    
    // MARK: Initializers
    
    override init() {
        baseClient = Client(url: Constants.BaseURLSecure)
        super.init()
    }
    
    // MARK: POST
    
    func taskForPOSTMethod(method: String, parameters: [String : AnyObject], jsonBody: [String:AnyObject], completionHandler: (result: AnyObject!, error: NSError?) -> Void) -> NSURLSessionDataTask {
        
        let httpHeaders = [
            ("application/json", "Accept"),
            ("application/json", "Content-Type"),
        ]
        
        return baseClient.taskForMethod(method, httpMethod: Client.HttpMethod.POST, parameters: parameters, jsonBody: jsonBody, httpHeaders: httpHeaders) { data, error -> Void in
            
            if let error = error {
                completionHandler(result: nil, error: error)
                return
            }
            
            guard let data = data else {
                completionHandler(result: nil, error: NSError(domain: "TaskForPostMethod", code: Client.ErrorCodes.DataError, userInfo: [NSLocalizedDescriptionKey : "There was error in the data response from the server"]))
                return
            }
            
            let newData = data.subdataWithRange(NSMakeRange(5, data.length - 5))
            Client.parseJSONWithCompletionHandler(newData, completionHandler: completionHandler)
            
        }
    }
    
    class func sharedInstance() -> UdacityClient {
            
        struct Singleton {
            static var sharedInstance = UdacityClient()
        }
            
        return Singleton.sharedInstance
    }
    
    func taskForGETMethod(method: String, parameters: [String : AnyObject], completionHandler: (result: AnyObject!, error: NSError?) -> Void) -> NSURLSessionDataTask {
        
        return baseClient.taskForGETMethod(method, parameters: parameters, httpHeaders: [(String, String)]()) { data, error -> Void in
            
            if let error = error {
                completionHandler(result: nil, error: error)
                return
            }
            
            guard let data = data else {
                completionHandler(result: nil, error: NSError(domain: "TaskForGetMethod", code: Client.ErrorCodes.DataError, userInfo: [NSLocalizedDescriptionKey : "There was error in the data response from the server"]))
                return
            }
            
            let newData = data.subdataWithRange(NSMakeRange(5, data.length - 5))
            Client.parseJSONWithCompletionHandler(newData, completionHandler: completionHandler)
            
        }
    }
}
