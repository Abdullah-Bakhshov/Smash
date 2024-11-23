//
//  Authentication.swift
//  Smash
//
//  Created by Abdullah B on 02/11/2024.
//

import Foundation


class Authentication {
    
    let acountdetail: Account = Account()
    
    init(){}
    
    func check(UserName: String, Password: String) -> Bool {
        if UserName == acountdetail.username && Password ==  acountdetail.password {
            return true
        }
        
        return false
    }
}
