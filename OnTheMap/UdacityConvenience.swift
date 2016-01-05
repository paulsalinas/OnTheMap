///Users/paulsalinas/Development/Udacity/NanoDegree/iOS/Projects/OnTheMap/OnTheMap.xcodeproj
//  UdacityConvenience.swift
//  OnTheMap
//
//  Created by Paul Salinas on 2016-01-03.
//  Copyright © 2016 Paul Salinas. All rights reserved.
//

import Foundation

extension UdacityClient {
    
    func authenticate(username: String, password: String , completionHandler: (success: Bool, errorString: String?) -> Void) {
        
        // 1) validate - check if username and password are empty
        guard username != "" && password != ""  else {
            completionHandler(success: false, errorString: ErrorDescription.EmptyEmailPassword)
            return
        }
        
        let jsonBody =  ["udacity": [
            "username": username,
            "password": password
            ]
        ]
        
        // 2) POST the data over
        taskForPOSTMethod(Methods.SessionID, parameters: [String: AnyObject](), jsonBody: jsonBody) { result, error -> Void in
            
            // GUARD: fail and call completion handler on error
            if let error = error {
                if error.localizedDescription == "Your request returned an invalid response! Status code: 403!" {
                    completionHandler(success: false, errorString: ErrorDescription.InvalidEmailPassword)
                }
                else if error.localizedDescription.containsString("There was an error with your request") {
                    completionHandler(success: false, errorString: ErrorDescription.RequestError)
                }
                else {
                    completionHandler(success: false, errorString: ErrorDescription.DataError)
                }
                
                return
            }
            
            // parse the data for the user id
            guard let account = result[JSONResponseKeys.Account] as? [String: AnyObject] else {
                print("error: no account record in result")
                completionHandler(success: false, errorString: ErrorDescription.DataError)
                return
            }
            
            guard let userID = account[JSONResponseKeys.UserID] as? String else {
                print("error: no user id in result")
                completionHandler(success: false, errorString: ErrorDescription.DataError)
                return
            }
            
            // set the user id
            self.userID = userID
            completionHandler(success: true, errorString: nil)
            
            print("found User ID: \(self.userID)")
        }
    }
    
    /* The completionHandler is passed the StudentInformation object with all of the user information from the api  */
    func getUserData(completionHandler: (user: StudentInformation?, errorString: String?) -> Void) {
        
        // GUARD: User id must be defined
        guard let userID = userID else {
            print("no user id found")
            return
        }
        
        let method = CommonClient.substituteKeyInMethod(Methods.Users, key: URLKeys.UserID, value: userID)!
        
        taskForGETMethod(method, parameters: [String: AnyObject]()) { (result, error) -> Void in
            
            // GUARD: fail and call completion handler on error
            if let error = error {
                completionHandler(user: nil, errorString: error.localizedDescription)
                return
            }
            
            print(result)
            
            guard let user = result[JSONResponseKeys.User] as? [String: AnyObject] else {
                print("error: user found in result")
                return
            }
            
            let udacian = StudentInformation(
                firstName: user[UdacityClient.JSONResponseKeys.FirstName] as! String,
                lastName: user[UdacityClient.JSONResponseKeys.LastName] as! String,
                userId: user[UdacityClient.JSONResponseKeys.UserID] as! String,
                url: nil,
                longitude: nil,
                latitude: nil
            )
            
            completionHandler(user: udacian, errorString: nil)
        }
    }
    
}
