//
//  ParseConvenience.swift
//  OnTheMap
//
//  Created by Paul Salinas on 2016-01-04.
//  Copyright © 2016 Paul Salinas. All rights reserved.
//

import Foundation

extension ParseClient {
    
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
    
    class func studentInfoFromResults(results: [[String: AnyObject]]) -> [StudentInformation] {
        var students = [StudentInformation]()
        
        for result in results {
            let student = StudentInformation(
                firstName: result[JSONResponseKeys.FirstName] as! String,
                lastName: result[JSONResponseKeys.LastName] as! String,
                userId: result[JSONResponseKeys.UserID] as! String,
                url: result[JSONResponseKeys.Url] as! String?,
                longitude: result[JSONResponseKeys.Longitude] as! Double?,
                latitude: result[JSONResponseKeys.Latitude] as! Double?
            )
            
            students.append(student)
        }
        
        return students
    }
}