//
//  Constants.swift
//  OnTheMap
//
//  Created by Paul Salinas on 2016-01-03.
//  Copyright © 2016 Paul Salinas. All rights reserved.
//

import Foundation

extension UdacityClient {
    
    // MARK: Constants
    struct Constants {
        static let BaseURLSecure : String = "https://www.udacity.com/api/"
    }
    
    // MARK: Methods
    struct Methods {
        // MARK: Session
        static let SessionID = "session"
        
        // MARK: User Data
        static let Users = "users/{userid}"
    }
    
    // MARK: JSON Response Keys
    struct JSONResponseKeys {
        static let UserID = "key"
        static let Account = "account"
        static let FirstName = "first_name"
        static let LastName = "last_name"
        static let User = "user"
        static let Session = "session"
    }
    
    // MARK: Errors
    struct Errors {
        static let EmptyEmailPassword = "Empty Email or Password"
        static let InvalidEmailPassword = "Invalid Email or Password"
        static let RequestError = "Error Making your Request"
        static let DataError = "Data Response Error"
    }
    
    // MARK: URL Keys
    struct URLKeys {
        
        static let UserID = "userid"
        
    }
  
}
