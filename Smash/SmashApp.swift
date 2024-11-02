//
//  SmashApp.swift
//  Smash
//
//  Created by Abdullah B on 29/10/2024.
//

import SwiftUI

@main
struct SmashApp: App {
    @StateObject var state = ViewingStatesModel()

    var body: some Scene {
        WindowGroup {
            Base()
                .environmentObject(state) // Injecting the environment object here
        }
    }
}
