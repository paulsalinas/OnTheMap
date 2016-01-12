//
//  ParseConstants.swift
//  OnTheMap
//
//  Created by Paul Salinas on 2016-01-04.
//  Copyright © 2016 Paul Salinas. All rights reserved.
//

import Foundation

extension ParseClient {
    struct Constants {
        static let ApiKey : String = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
        static let ApplicationID : String = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr" 
        
        static let BaseURLSecure : String = "https://api.parse.com/1/classes/"
    }
    
    struct Methods {
        static let StudentLocation = "StudentLocation"
        static let PUTStudentLocation = "StudentLocation/{objectId}"
    }
    
    struct HttpMethod {
        static let POST = "POST"
        static let PUT = "PUT"
    }
    
    struct HttpHeaders {
        static let ApiKey : String = "X-Parse-REST-API-Key"
        static let ApplicationID : String = "X-Parse-Application-Id"
    }
    
    // MARK: JSON Response Keys
    
    struct JSONResponseKeys {
        static let UserID = "uniqueKey"
        static let Account = "account"
        static let FirstName = "firstName"
        static let LastName = "lastName"
        static let Results = "results"
        static let Latitude = "latitude"
        static let Longitude = "longitude"
        static let Url = "mediaURL"
        static let ObjectId = "objectId"
        static let CreatedAt = "createdAt"
        static let MapString = "mapString"
        static let UpdatedAt = "updatedAt"
    }
    
    struct JSONBody {
        static let UserID = "uniqueKey"
        static let FirstName = "firstName"
        static let LastName = "lastName"
        static let Latitude = "latitude"
        static let Longitude = "longitude"
        static let Url = "mediaURL"
        static let MapString = "mapString"
    }
    
    struct Errors {
        static let ErrorReadingResults = "Error Reading Server Results"
        static let EmptyUrlForStudent = "Student Location has an empty url field"
        static let InvalidLongitude = "Student Location has en invalid longitude"
        static let InvalidLatitude = "Student Location has en invalid latitude"
    }
}