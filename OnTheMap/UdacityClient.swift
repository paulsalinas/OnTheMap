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
    
    /* Authentication state */
    var sessionID : String? = nil
    var userID : String? = nil
    
    /* helper client */
    let helperClient : CommonClient
    
    // MARK: Initializers
    
    override init() {
        helperClient = CommonClient(url: UdacityClient.Constants.BaseURLSecure, session: NSURLSession.sharedSession())
        super.init()
    }
    
    // MARK: POST
    
    func taskForPOSTMethod(method: String, parameters: [String : AnyObject], jsonBody: [String:AnyObject], completionHandler: (result: AnyObject!, error: NSError?) -> Void) -> NSURLSessionDataTask {
        
        let httpHeaders = [
            ("application/json", "Accept"),
            ("application/json", "Content-Type"),
        ]
        
         return helperClient.taskForPOSTMethod(method, parameters: parameters, jsonBody: jsonBody, httpHeaders: httpHeaders) { data, error -> Void in
            
            if let error = error {
                completionHandler(result: nil, error: error)
            }
            
            guard let data = data else {
                print("there's data returned")
                return
            }
            
            let newData = data.subdataWithRange(NSMakeRange(5, data.length - 5))
            print(NSString(data: newData, encoding: NSUTF8StringEncoding))
            
            CommonClient.parseJSONWithCompletionHandler(newData, completionHandler: completionHandler)
            
        }
    }
    
    class func sharedInstance() -> UdacityClient {
            
        struct Singleton {
            static var sharedInstance = UdacityClient()
        }
            
        return Singleton.sharedInstance
    }
    
    func taskForGETMethod(method: String, parameters: [String : AnyObject], completionHandler: (result: AnyObject!, error: NSError?) -> Void) -> NSURLSessionDataTask {
        
        return helperClient.taskForGETMethod(method, parameters: parameters, httpHeaders: [(String, String)]()) { data, error -> Void in
            
            if let error = error {
                completionHandler(result: nil, error: error)
            }
            
            guard let data = data else {
                print("there's data returned")
                return
            }
            
            let newData = data.subdataWithRange(NSMakeRange(5, data.length - 5))
            print(NSString(data: newData, encoding: NSUTF8StringEncoding))
            
            CommonClient.parseJSONWithCompletionHandler(newData, completionHandler: completionHandler)
            
        }
    }
}
