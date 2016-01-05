//
//  Client.swift
//  OnTheMap
//
//  Created by Paul Salinas on 2016-01-05.
//  Copyright © 2016 Paul Salinas. All rights reserved.
//

import Foundation

class Client : NSObject {
    // MARK: Properties
    
    /* Shared session */
    let session: NSURLSession
    
    /* base url */
    let url: String
    
    // MARK: Initializers
    
    init(url: String) {
        self.url = url
        session = NSURLSession.sharedSession()
        super.init()
    }
    
    func taskForPOSTMethod(method: String, parameters: [String : AnyObject], jsonBody: [String:AnyObject], httpHeaders: [(String, String)], completionHandler: (data: NSData?, error: NSError?) -> Void) -> NSURLSessionDataTask {
        
        /* 1. Set the parameters */
        let mutableParameters = parameters
        
        /* 2/3. Build the URL and configure the request */
        let urlString = url + method + Client.escapedParameters(mutableParameters)
        
        let request = NSMutableURLRequest(URL: NSURL(string: urlString)!)
        request.HTTPMethod = "POST"
        
        for (val, field) in httpHeaders {
            request.addValue(val, forHTTPHeaderField: field)
        }
        
        do {
            request.HTTPBody = try! NSJSONSerialization.dataWithJSONObject(jsonBody, options: .PrettyPrinted)
        }
        
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in
            
            /* function to be called when an error occurs from server response */
            let errorHandler = { (description: String) -> Void in
                print(description)
                
                let userInfo = [NSLocalizedDescriptionKey : description]
                completionHandler(data: nil, error: NSError(domain: "taskForPOSTMethod", code: 1, userInfo: userInfo))
            }
            
            
            /* GUARD: Was there an error? */
            guard (error == nil) else {
                errorHandler("There was an error with your request: \(error)")
                return
            }
            
            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? NSHTTPURLResponse)?.statusCode where statusCode >= 200 && statusCode <= 299 else {
                let error: String
                if let response = response as? NSHTTPURLResponse {
                    error = "Your request returned an invalid response! Status code: \(response.statusCode)!"
                } else if let response = response {
                    error = "Your request returned an invalid response! Response: \(response)!"
                } else {
                    error = "Your request returned an invalid response!"
                }
                
                errorHandler(error)
                return
            }
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                errorHandler("No data was returned by the request!")
                return
            }
            
            
            completionHandler(data: data, error: nil)
        }
        
        task.resume()
        
        return task
    }
    
    // MARK: GET
    
    func taskForGETMethod(method: String, parameters: [String : AnyObject], httpHeaders: [(String, String)], completionHandler: (data: NSData?, error: NSError?) -> Void) -> NSURLSessionDataTask {
        
        /* 1. Set the parameters */
        let mutableParameters = parameters
        
        /* 2/3. Build the URL and configure the request */
        let urlString = url + method + ParseClient.escapedParameters(mutableParameters)
        let request = NSMutableURLRequest(URL: NSURL(string: urlString)!)
        
        for (val, field) in httpHeaders {
            request.addValue(val, forHTTPHeaderField: field)
        }
        
        /* 4. Make the request */
        let task = session.dataTaskWithRequest(request) { (data, response, error) in
            
            /* GUARD: Was there an error? */
            guard (error == nil) else {
                print("There was an error with your request: \(error)")
                return
            }
            
            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? NSHTTPURLResponse)?.statusCode where statusCode >= 200 && statusCode <= 299 else {
                if let response = response as? NSHTTPURLResponse {
                    print("Your request returned an invalid response! Status code: \(response.statusCode)!")
                } else if let response = response {
                    print("Your request returned an invalid response! Response: \(response)!")
                } else {
                    print("Your request returned an invalid response!")
                }
                return
            }
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                print("No data was returned by the request!")
                return
            }
            
            completionHandler(data: data, error: nil)
        }
        
        /* 7. Start the request */
        task.resume()
        
        return task
    }
    
    // MARK: Helpers
    
    /* Helper: Substitute the key for the value that is contained within the method name */
    class func substituteKeyInMethod(method: String, key: String, value: String) -> String? {
        if method.rangeOfString("{\(key)}") != nil {
            return method.stringByReplacingOccurrencesOfString("{\(key)}", withString: value)
        } else {
            return nil
        }
    }
    
    /* Helper: Given raw JSON, return a usable Foundation object */
    class func parseJSONWithCompletionHandler(data: NSData, completionHandler: (result: AnyObject!, error: NSError?) -> Void) {
        
        var parsedResult: AnyObject!
        do {
            parsedResult = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
        } catch {
            let userInfo = [NSLocalizedDescriptionKey : "Could not parse the data as JSON: '\(data)'"]
            completionHandler(result: nil, error: NSError(domain: "parseJSONWithCompletionHandler", code: 1, userInfo: userInfo))
        }
        
        completionHandler(result: parsedResult, error: nil)
    }
    
    /* Helper function: Given a dictionary of parameters, convert to a string for a url */
    class func escapedParameters(parameters: [String : AnyObject]) -> String {
        
        var urlVars = [String]()
        
        for (key, value) in parameters {
            
            /* Make sure that it is a string value */
            let stringValue = "\(value)"
            
            /* Escape it */
            let escapedValue = stringValue.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())
            
            /* Append it */
            urlVars += [key + "=" + "\(escapedValue!)"]
            
        }
        
        return (!urlVars.isEmpty ? "?" : "") + urlVars.joinWithSeparator("&")
    }
}
