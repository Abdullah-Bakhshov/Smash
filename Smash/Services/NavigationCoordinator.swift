//
//  NavigationCoordinator.swift
//  Smash
//
//  Created by Jack Rong on 01/11/2024.
//

import Foundation
import SwiftUI
import Observation

@Observable
final class NavigationCoordinator {
    // MARK: - Properties
    static let shared = NavigationCoordinator()
    
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
        case .login: LoginView()
        case .home: HomePage()
        case .register: RegistrationPage()
        case .account: AccountSettingsPage()
        case .startsession: VideoSystem()
        case .previewview: PreviewView()
        }
    }
}

enum NavigationDestination: Hashable {
    case login
    case home
    case register
    case account
    case startsession
    case previewview
}
