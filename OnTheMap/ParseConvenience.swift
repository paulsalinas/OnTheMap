//
//  ParseConvenience.swift
//  OnTheMap
//
//  Created by Paul Salinas on 2016-01-04.
//  Copyright © 2016 Paul Salinas. All rights reserved.
//

import Foundation

extension ParseClient {
    
    func getUserLocations (completionHandler: (users:[Udacian]?, errorString: String?) -> Void){
        let parameters = [
            "limit" : "100",
            "skip" : "0",
            "order" : "updatedAt"
        ]
        
        taskForGETMethod(Methods.StudentLocation, parameters: parameters) { (result, error) -> Void in
            
            // GUARD: fail and call completion handler on error
            if let error = error {
                completionHandler(users: nil, errorString: error.localizedDescription)
                return
            }
            
            print(result)
            
//            guard let user = result[JSONResponseKeys.User] as? [String: AnyObject] else {
//                print("error: user found in result")
//                return
//            }
//            
//            completionHandler(user: Udacian(dictionary: user), errorString: nil)
        }
    }
}