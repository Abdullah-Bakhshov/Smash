//
//  WatchNavigationCoordinator.swift
//  Smash
//
//  Created by Abdullah B on 09/11/2024.
//

import Foundation
import SwiftUI
import Observation

@Observable
final class WatchNavigationCoordinator {
        
    // MARK: - Properties
    static let shared = WatchNavigationCoordinator()
    
    public var path: [NavigationDestination] = []
    
    // MARK: - Init
    private init() {}
    
    // MARK: - Functions
    func push(_ destination: NavigationDestination) {
        path.append(destination)
    }
    
    func pop() {
        path.removeLast()
    }
    
    func popToRoot() {
        path.removeAll()
    }
    
    @ViewBuilder
    func destination(for destination: NavigationDestination) -> some View {
        switch destination {
        case .watchhomescreen: WatchHomeScreen()
        case .watchsession: WatchSession()
        }
    }
}

enum NavigationDestination: Hashable {
    case watchhomescreen
    case watchsession
}
