//
//  WatchState.swift
//  Smash
//
//  Created by Abdullah B on 09/11/2024.
//

import Foundation
import Observation

@Observable
final class WatchState {
    
    private(set) var home: Bool = true
    static let shared = WatchState()

    private init(){}
    
    func toggleHome() {
        home.toggle()
    }
}
