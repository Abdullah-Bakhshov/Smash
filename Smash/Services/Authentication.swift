//
//  Authentication.swift
//  Smash
//
//  Created by Abdullah B on 02/11/2024.
//

import Foundation


class Authentication {
    
    let acountdetail: Account = Account()
    
    var userinfo: [String] {
        get async {
            return await ClientForAPI().getAccount()
        }
    }
    
    
    init(){}
    
    func check(UserName: String, Password: String) -> Bool {
        
        var isValid = false
        let semaphore = DispatchSemaphore(value: 0)
        Task {
            // Waiting for the username and info
            let info = await userinfo
            // Check
            if UserName == info[0] && Password == info[1] {
                isValid = true
            }
            // Post signal, increments the value
            semaphore.signal()
        }
        // if 0 we are waiting till the value is above 0 to then decrement it back to 0
        semaphore.wait()
        return isValid
    }
}
