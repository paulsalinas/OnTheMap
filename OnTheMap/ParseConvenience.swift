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
    func getStudentLocations (completionHandler: (users:[StudentInformation]?, errorString: String?) -> Void){
        let parameters = [
            "limit" : "100",
            "skip" : "0",
            "order" : "-updatedAt"
        ]
        
        taskForGETMethod(Methods.StudentLocation, parameters: parameters) {
            (result, error) -> Void in
            
            // GUARD: fail and call completion handler on error
            if let error = error {
                completionHandler(users: nil, errorString: error.localizedDescription)
                return
            }
            
            guard let result = result[JSONResponseKeys.Results] as? [[String: AnyObject]] else {
                completionHandler(users: nil, errorString: Errors.ErrorReadingResults)
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
        
        taskForGETMethod(Methods.StudentLocation, parameters: parameters) {
            (result, error) -> Void in
            
            // GUARD: fail and call completion handler on error
            if let error = error {
                completionHandler(user: nil, errorString: error.localizedDescription)
                return
            }
            
            guard let result = result[JSONResponseKeys.Results] as? [[String: AnyObject]] else {
                completionHandler(user: nil, errorString: Errors.ErrorReadingResults)
                return
            }
            
            guard let user = result.first  else {
                completionHandler(user: nil, errorString: Errors.UserNotFound)
                return
            }
            
            completionHandler(user: StudentInformation(parseDictionary: user), errorString: nil)
        }
    }
    
    func addStudentLocation(user: StudentInformation, completionHandler: (success: Bool?, errorString: String?) -> Void){
        
        // validate the model
        let validationResult = ParseClient.validateStudentLocation(user)
        
        // end it here if validation fails
        if !validationResult.success {
            completionHandler(success: validationResult.success, errorString: validationResult.errorString)
            return
        }
        
        let jsonBody : [String: AnyObject]
        
        jsonBody = [
            JSONBody.FirstName: user.firstName,
            JSONBody.LastName: user.lastName,
            JSONBody.Latitude: user.latitude!,
            JSONBody.Longitude: user.longitude!,
            JSONBody.Url: user.url!,
            JSONBody.MapString: user.mapString!,
            JSONBody.UserID: user.userId
        ]
        
        taskForMethod(Methods.StudentLocation, httpMethod: Client.HttpMethod.POST, parameters: [String: AnyObject](), jsonBody: jsonBody) {
            (result, error) -> Void in
            
            // GUARD: fail and call completion handler on error
            if let error = error {
                completionHandler(success: false, errorString: error.localizedDescription)
                return
            }
            
            guard (result[JSONResponseKeys.CreatedAt] as? String) != nil  else {
                completionHandler(success: false, errorString: Errors.ErrorReadingResults)
                return
            }
            
            completionHandler(success: true, errorString: nil)
        }
    }
    
    func changeStudentLocation(user: StudentInformation, completionHandler: (success: Bool?, errorString: String?) -> Void){
        
        // validate the model
        let validationResult = ParseClient.validateStudentLocation(user)
        
        // end it here if validation fails
        if !validationResult.success {
            completionHandler(success: validationResult.success, errorString: validationResult.errorString)
            return
        }
        
        let jsonBody : [String: AnyObject]
        
        jsonBody = [
            JSONBody.FirstName: user.firstName,
            JSONBody.LastName: user.lastName,
            JSONBody.Latitude: user.latitude!,
            JSONBody.Longitude: user.longitude!,
            JSONBody.Url: user.url!,
            JSONBody.MapString: user.mapString!,
            JSONBody.UserID: user.userId
        ]
        
        let method = Client.substituteKeyInMethod(Methods.PUTStudentLocation, key: "objectId", value: user.objectId!)
        
        taskForMethod(method!, httpMethod: Client.HttpMethod.PUT, parameters: [String: AnyObject](), jsonBody: jsonBody) {
            (result, error) -> Void in
            
            // GUARD: fail and call completion handler on error
            if let error = error {
                completionHandler(success: false, errorString: error.localizedDescription)
                return
            }
            
            guard (result[JSONResponseKeys.UpdatedAt] as? String) != nil else {
                completionHandler(success: false, errorString: Errors.ErrorReadingResults)
                return
            }
            
            completionHandler(success: true, errorString: nil)
        }
    }
    
    func deleteStudentLocation (user: StudentInformation, completionHandler: (success: Bool?, errorString: String?) -> Void){
        
        // validate the model
        let validationResult = ParseClient.validateStudentLocation(user)
        
        // end it here if validation fails
        if !validationResult.success {
            completionHandler(success: validationResult.success, errorString: validationResult.errorString)
            return
        }
        
        let jsonBody = [String: AnyObject]()
        
        let method = Client.substituteKeyInMethod(Methods.PUTStudentLocation, key: "objectId", value: user.objectId!)
        
        taskForMethod(method!, httpMethod: Client.HttpMethod.DELETE, parameters: [String: AnyObject](), jsonBody: jsonBody) {
            (result, error) -> Void in
            
            // GUARD: fail and call completion handler on error
            if let error = error {
                completionHandler(success: false, errorString: error.localizedDescription)
                return
            }
            
            completionHandler(success: true, errorString: nil)
        }
    }
    
    class func validateStudentLocation(user: StudentInformation) -> (success: Bool, errorString: String?) {
        
        // validate the model
        guard let url = user.url where url != "" else {
            return (success: false, errorString: Errors.EmptyUrlForStudent)
        }
        
        guard let mapString = user.mapString where mapString != "" else {
            return (success: false, errorString: Errors.EmptyUrlForStudent)
        }
        
        guard let latitude = user.latitude where latitude >= -90 && latitude <= 90 else {
            return (success: false, errorString: Errors.InvalidLatitude)
        }
        
        guard let longitude = user.longitude where longitude >= -180 && longitude <= 180 else {
            return (success: false, errorString: Errors.InvalidLongitude)
        }
        
        return (success: true, errorString: nil)
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