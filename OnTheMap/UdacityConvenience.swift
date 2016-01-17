///Users/paulsalinas/Development/Udacity/NanoDegree/iOS/Projects/OnTheMap/OnTheMap.xcodeproj
//  UdacityConvenience.swift
//  OnTheMap
//
//  Created by Paul Salinas on 2016-01-03.
//  Copyright © 2016 Paul Salinas. All rights reserved.
//

import Foundation

extension UdacityClient {
    
     func authenticateWithFacebook(accessToken: String, completionHandler: (success: Bool, errorString: String?) -> Void) {
        
        // 1) validate - check if username and password are empty
        guard accessToken != "" else {
            completionHandler(success: false, errorString: "Empty access token")
            return
        }
        
        let jsonBody =  [
            "facebook_mobile": ["access_token": accessToken ]
        ]
        
        // 2) POST the data over
        taskForPOSTMethod(Methods.SessionID, parameters: [String: AnyObject](), jsonBody: jsonBody) { result, error -> Void in
            
            // GUARD: fail and call completion handler on error
            if let error = error {
                if error.code ==  Client.ErrorCodes.Forbidden {
                    completionHandler(success: false, errorString: Errors.InvalidEmailPassword)
                }
                else if error.code == Client.ErrorCodes.DataError {
                    completionHandler(success: false, errorString: Errors.DataError)
                }
                else {
                    completionHandler(success: false, errorString: Errors.RequestError)
                }
                
                return
            }
            
            // parse the data for the user id
            guard let account = result[JSONResponseKeys.Account] as? [String: AnyObject] else {
                completionHandler(success: false, errorString: Errors.DataError)
                return
            }
            
            guard let userID = account[JSONResponseKeys.UserID] as? String else {
                completionHandler(success: false, errorString: Errors.DataError)
                return
            }
            
            // set the user id for this session
            self.userID = userID
            
            completionHandler(success: true, errorString: nil)
        }

    }
    
    func authenticateAndCreateSession(username: String, password: String , completionHandler: (success: Bool, errorString: String?) -> Void) {
        
        // 1) validate - check if username and password are empty
        guard username != "" && password != ""  else {
            completionHandler(success: false, errorString: Errors.EmptyEmailPassword)
            return
        }
        
        let jsonBody =  [
            "udacity": [
                "username": username,
                "password": password
                ]
        ]
        
        // 2) POST the data over
        taskForPOSTMethod(Methods.SessionID, parameters: [String: AnyObject](), jsonBody: jsonBody) { result, error -> Void in
            
            // GUARD: fail and call completion handler on error
            if let error = error {
                if error.code ==  Client.ErrorCodes.Forbidden {
                    completionHandler(success: false, errorString: Errors.InvalidEmailPassword)
                }
                else if error.code == Client.ErrorCodes.DataError {
                    completionHandler(success: false, errorString: Errors.DataError)
                }
                else {
                    completionHandler(success: false, errorString: Errors.RequestError)
                }
                
                return
            }
            
            // parse the data for the user id
            guard let account = result[JSONResponseKeys.Account] as? [String: AnyObject] else {
                completionHandler(success: false, errorString: Errors.DataError)
                return
            }
            
            guard let userID = account[JSONResponseKeys.UserID] as? String else {
                completionHandler(success: false, errorString: Errors.DataError)
                return
            }
            
            // set the user id for this session
            self.userID = userID
            
            completionHandler(success: true, errorString: nil)
        }
    }
    
    func logOutOfSession(completionHandler: (success: Bool, errorString: String?) -> Void) {
        
        var xsrfCookie: NSHTTPCookie? = nil
        let sharedCookieStorage = NSHTTPCookieStorage.sharedHTTPCookieStorage()
        var httpHeaders = [(String, String)]()
        
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        
        if let xsrfCookie = xsrfCookie {
            httpHeaders.append((xsrfCookie.value, "X-XSRF-TOKEN"))
        }
        
        taskForDELETEMethod(Methods.SessionID, httpHeaders: httpHeaders) {
            result, error -> Void in
            
            // GUARD: fail and call completion handler on error
            if let error = error {
                if error.code ==  Client.ErrorCodes.Forbidden {
                    completionHandler(success: false, errorString: Errors.InvalidEmailPassword)
                }
                else if error.code == Client.ErrorCodes.DataError {
                    completionHandler(success: false, errorString: Errors.DataError)
                }
                else {
                    completionHandler(success: false, errorString: Errors.RequestError)
                }
                
                return
            }
            
            // parse the data for the user id
            if (result[JSONResponseKeys.Session] as? [String: AnyObject]) == nil {
                completionHandler(success: false, errorString: Errors.DataError)
                return
            }
            
            // reset state of client - we've logged out of the session
            self.userID = nil
            
            completionHandler(success: true, errorString: nil)
        }
    }
    
    /* The completionHandler is passed the StudentInformation object with all of the user information from the api  */
    func getUserData(completionHandler: (user: StudentInformation?, errorString: String?) -> Void) {
        
        // GUARD: User id must be defined
        guard let userID = userID else {
            print("no user id found")
            return
        }
        
        let method = Client.substituteKeyInMethod(Methods.Users, key: URLKeys.UserID, value: userID)!
        
        taskForGETMethod(method, parameters: [String: AnyObject]()) { (result, error) -> Void in
            
            // GUARD: fail and call completion handler on error
            if let error = error {
                if error.code ==  Client.ErrorCodes.Forbidden {
                    completionHandler(user: nil, errorString: Errors.InvalidEmailPassword)
                }
                else if error.code == Client.ErrorCodes.DataError {
                    completionHandler(user: nil, errorString: Errors.DataError)
                }
                else {
                    completionHandler(user: nil, errorString: Errors.RequestError)
                }
                
                return
            }
            
            guard let user = result[JSONResponseKeys.User] as? [String: AnyObject] else {
                completionHandler(user: nil, errorString: Errors.DataError)
                return
            }
            
            let student = StudentInformation(udacityDictionary: user)
        
            completionHandler(user: student, errorString: nil)
        }
    }
    
}
