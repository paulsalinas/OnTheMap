//
//  StudentInformationCollection.swift
//  OnTheMap
//
//  Created by Paul Salinas on 2016-01-23.
//  Copyright © 2016 Paul Salinas. All rights reserved.
//

import Foundation

class StudentInformationCollection {
    var users: [StudentInformation]?
    
    class func sharedInstance() -> StudentInformationCollection {
        
        struct Singleton {
            static var sharedInstance = StudentInformationCollection()
        }
        
        return Singleton.sharedInstance
    }
}
