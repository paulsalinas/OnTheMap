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
        let jsonBody =  ["udacity": [
            "username": username,
            "password": password
            ]
        ]
        
        taskForPOSTMethod(Methods.SessionID, parameters: [String: AnyObject](), jsonBody: jsonBody) { result, error -> Void in
            let errorHandler = { (description: String) -> Void in
                print(description)
                
                completionHandler(success: false, errorString: description)
            }
            
            if let error = error {
                errorHandler("error: \(error.description)")
                return
            }
            
            guard let account = result[JSONResponseKeys.Account] as? [String: AnyObject] else {
                errorHandler("error: no account record in result")
                return
            }
            
            guard let userID = account[JSONResponseKeys.UserID] as? String else {
                errorHandler("error: no user id in result")
                return
            }
            
            self.userID = userID
            
            completionHandler(success: true, errorString: nil)
            
            print("found User ID: \(self.userID)")
        }
    }
    
}
