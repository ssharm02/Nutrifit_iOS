//
//  Customer.swift
//  fitnessApp
//
//  Created by Xcode User on 2018-04-06.
//  Copyright © 2018 Xcode User. All rights reserved.
//

import UIKit

class Customer: NSObject {

    var username: String
    var firstName: String
    var lastName: String
    var email : String
    var password: String
    
    
    
    init(username: String, firstName: String, lastName: String, email: String, password: String) {
        self.username = username
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.password = password
    }
}
