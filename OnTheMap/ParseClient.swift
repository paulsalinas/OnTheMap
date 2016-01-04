//
//  ParseClient.swift
//  OnTheMap
//
//  Created by Paul Salinas on 2016-01-04.
//  Copyright © 2016 Paul Salinas. All rights reserved.
//

import Foundation

class ParseClient : NSObject {
    
    // MARK: Properties
    
    /* Authentication state */
    var sessionID : String? = nil
    var userID : String? = nil
    
    /* helper client */
    let helperClient : CommonClient
    
    // MARK: Initializers
    
    override init() {
        helperClient = CommonClient(url: Constants.BaseURLSecure, session: NSURLSession.sharedSession())
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
    
    class func sharedInstance() -> ParseClient {
        
        struct Singleton {
            static var sharedInstance = ParseClient()
        }
        
        return Singleton.sharedInstance
    }
    
    func taskForGETMethod(method: String, parameters: [String : AnyObject], completionHandler: (result: AnyObject!, error: NSError?) -> Void) -> NSURLSessionDataTask {
        
        let httpHeaders = [
            (Constants.ApiKey, HttpHeaders.ApiKey),
            (Constants.ApplicationID, HttpHeaders.ApplicationID),
        ]
        
        return helperClient.taskForGETMethod(method, parameters: parameters, httpHeaders: httpHeaders) { data, error -> Void in
            
            if let error = error {
                completionHandler(result: nil, error: error)
            }
            
            guard let data = data else {
                print("there's data returned")
                return
            }
        
            print(NSString(data: data, encoding: NSUTF8StringEncoding))
            
            CommonClient.parseJSONWithCompletionHandler(data, completionHandler: completionHandler)
            
        }
    }
}