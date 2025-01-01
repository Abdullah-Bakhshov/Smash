//
//  Authentication.swift
//  Smash
//
//  Created by Abdullah B on 02/11/2024.
//

import Foundation
import SwiftUICore


class Authentication {
    
    let acountdetail: Account = Account()
    @Bindable var accountinfo = GlobalAccountinfo.shared
    
    init(){}
    
    func check(username: String, password: String) -> Bool {
        
        var isValid = false
        let semaphore = DispatchSemaphore(value: 0)
        Task {
            // Waiting for the username and info
            let info = await ClientForAPI().getAccount(username: username)
            // Check
            if username == info[0] && password == info[1] {
                isValid = true
                accountinfo.username = username
            }
            // Post signal, increments the value
            semaphore.signal()
        }
        // if 0 we are waiting till the value is above 0 to then decrement it back to 0
        semaphore.wait()
        return isValid
    }
    
    func userNameInUse(username: String) -> Bool{
        var isValid = false
        let semaphore = DispatchSemaphore(value: 0)
        Task {
            // Waiting for the username and info
            let info = await ClientForAPI().getAccount(username: username)
            // Check
            if "" != info[0] && "" != info[1] {
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
