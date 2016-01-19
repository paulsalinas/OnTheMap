//
//  ParseClient.swift
//  OnTheMap
//
//  Created by Paul Salinas on 2016-01-04.
//  Copyright © 2016 Paul Salinas. All rights reserved.
//

import Foundation

class ParseClient: NSObject {
    
    // MARK: Properties
    
    var users : [StudentInformation]?
    
    /* Authentication state */
    var userID : String? = nil
    
    let baseClient : Client
    
    // MARK: Initializers
    
    override init() {
        baseClient = Client(url: Constants.BaseURLSecure)
        super.init()
    }
    
    // MARK: POST
    
    internal func taskForPOSTMethod(method: String, parameters: [String : AnyObject], jsonBody: [String : AnyObject], completionHandler: (result: AnyObject!, error: NSError?) -> Void) -> NSURLSessionDataTask {
        
        let httpHeaders = [
            (Constants.ApiKey, HttpHeaders.ApiKey),
            (Constants.ApplicationID, HttpHeaders.ApplicationID),
        ]
        
        return baseClient.taskForMethod(method, httpMethod: Client.HttpMethod.POST, parameters: parameters, jsonBody: jsonBody, httpHeaders: httpHeaders) { data, error -> Void in
            
            if let error = error {
                completionHandler(result: nil, error: error)
            }
            
            guard let data = data else {
                print("there's data returned")
                return
            }
            
            Client.parseJSONWithCompletionHandler(data, completionHandler: completionHandler)
            
        }
    }
    
    // MARK: GENERAL TASK
    
    internal func taskForMethod(method: String, httpMethod: String, parameters: [String : AnyObject], jsonBody: [String : AnyObject], completionHandler: (result: AnyObject!, error: NSError?) -> Void) -> NSURLSessionDataTask {
        
        let httpHeaders = [
            (Constants.ApiKey, HttpHeaders.ApiKey),
            (Constants.ApplicationID, HttpHeaders.ApplicationID),
        ]
        
        return baseClient.taskForMethod(method, httpMethod: httpMethod, parameters: parameters, jsonBody: jsonBody, httpHeaders: httpHeaders) { data, error -> Void in
            
            if let error = error {
                completionHandler(result: nil, error: error)
            }
            
            guard let data = data else {
                print("there's data returned")
                return
            }
            
            Client.parseJSONWithCompletionHandler(data, completionHandler: completionHandler)
            
        }
    }
    
    class func sharedInstance() -> ParseClient {
        
        struct Singleton {
            static var sharedInstance = ParseClient()
        }
        
        return Singleton.sharedInstance
    }
    
    internal func taskForGETMethod(method: String, parameters: [String : AnyObject], completionHandler: (result: AnyObject!, error: NSError?) -> Void) -> NSURLSessionDataTask {
        
        let httpHeaders = [
            (Constants.ApiKey, HttpHeaders.ApiKey),
            (Constants.ApplicationID, HttpHeaders.ApplicationID),
        ]
        
        return baseClient.taskForGETMethod(method, parameters: parameters, httpHeaders: httpHeaders) { data, error -> Void in
            
            if let error = error {
                completionHandler(result: nil, error: error)
            }
            
            guard let data = data else {
                print("there's data returned")
                return
            }
            
            Client.parseJSONWithCompletionHandler(data, completionHandler: completionHandler)
            
        }
    }
}