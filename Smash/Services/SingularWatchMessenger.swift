//
//  SingularWatchMessenger.swift
//  Smash
//
//  Created by Abdullah B on 10/11/2024.
//

import Foundation
import Observation

@Observable
class WatchSingleton {
    static let shared = WatchSingleton()
    var sendtowatch = ViewController()
    
    private init() {}
    
    func returnsendtowatch(){
        sendtowatch.checkAndSendGameState()
    }
}
