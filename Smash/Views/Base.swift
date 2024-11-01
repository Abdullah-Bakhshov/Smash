//
//  Base.swift
//  Smash
//
//  Created by Jack Rong on 01/11/2024.
//

import SwiftUI

struct Base: View {
    @Bindable private var coordinator = NavigationCoordinator.shared
    @State private var isLoggedIn: Bool = false
    
    var body: some View {
        NavigationStack(path: $coordinator.path) {
            VStack() {
                Button("Login") {
                    coordinator.push(.login)
                }
                
                Button("Home") {
                    coordinator.push(.home)
                }
            }
            .navigationDestination(for: NavigationDestination.self) { destination in
                coordinator.destination(for: destination)
            }
            .onAppear() {
                coordinator.push(isLoggedIn ? .login : .home)
            }
        }
    }
}

#Preview {
    Base()
}
