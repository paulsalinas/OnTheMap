//
//  ParseConvenience.swift
//  OnTheMap
//
//  Created by Paul Salinas on 2016-01-04.
//  Copyright © 2016 Paul Salinas. All rights reserved.
//

import Foundation

extension ParseClient {
    
    /* get the 100 most recent student locations */
    func getUserLocations (completionHandler: (users:[StudentInformation]?, errorString: String?) -> Void){
        let parameters = [
            "limit" : "100",
            "skip" : "0",
            "order" : "-updatedAt"
        ]
        
        taskForGETMethod(Methods.StudentLocation, parameters: parameters) { (result, error) -> Void in
            
            // GUARD: fail and call completion handler on error
            if let error = error {
                completionHandler(users: nil, errorString: error.localizedDescription)
                return
            }
            
            guard let result = result[JSONResponseKeys.Results] as? [[String: AnyObject]] else {
                print("couldn't find result key")
                return
            }
            
            completionHandler(users: ParseClient.studentInfoFromResults(result), errorString: nil)
        }
    }
    
    /* get the student location. the user object will be nil on the call back if it doesn't exist */
    func searchForStudenLocation(userId: String, completionHandler: (user: StudentInformation?, errorString: String?) -> Void){
        let parameters = [
            "where" : "{\"uniqueKey\":\"\(userId)\"}"
        ]
        
        taskForGETMethod(Methods.StudentLocation, parameters: parameters) { (result, error) -> Void in
            
            // GUARD: fail and call completion handler on error
            if let error = error {
                completionHandler(user: nil, errorString: error.localizedDescription)
                return
            }
            
            guard let result = result[JSONResponseKeys.Results] as? [[String: AnyObject]] else {
                completionHandler(user: nil, errorString: "User not found")
                return
            }
            
            guard let user = result.first  else {
                completionHandler(user: nil, errorString: "User not found")
                return
            }
            
            completionHandler(user: StudentInformation(parseDictionary: user), errorString: nil)
        }
    }
    
    class func studentInfoFromResults(results: [[String: AnyObject]]) -> [StudentInformation] {
        var students = [StudentInformation]()
        
        for result in results {
            let student = StudentInformation(parseDictionary: result)
            
            students.append(student)
        }
        
        return students
    }
}