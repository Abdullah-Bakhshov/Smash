//
//  Authentication.swift
//  Smash
//
//  Created by Abdullah B on 02/11/2024.
//

import Foundation


class Authentication {
    private let username: String    // giving the space in memory
    private let password: String
    
    init(UserName: String, Password: String) {  // we need to take this input and set it the space of memory we have created
        self.username = UserName
        self.password = Password
    }
    
    func check() -> Bool {
        if password == "123" && username == "123"{  // using what we have set
            return true
        }
        return false
    }
    
}
