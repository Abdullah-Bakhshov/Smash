//
//  SmashApp.swift
//  Smash
//
//  Created by Abdullah B on 29/10/2024.
//

import SwiftUI

@main
struct SmashApp: App {
    
    init() {
        AWSConfig.setup()
    }
    
    var body: some Scene {
        WindowGroup {
            Base()
        }
    }
}
