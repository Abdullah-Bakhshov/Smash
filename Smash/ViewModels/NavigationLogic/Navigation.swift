//
//  Base.swift
//  Smash
//
//  Created by Jack Rong on 01/11/2024.
//

import SwiftUI

struct Base: View {
    
    @Bindable private var coordinator = NavigationCoordinator.shared
    @Bindable var states = ViewingStatesModel.shared
    // If user is logged in previously or not
    var accountLoggedIn: Bool = Account().accountLoggedIn
    
    var body: some View {
        NavigationStack(path: $coordinator.path) {
            
            // Intro Video is played
            BackgroundVideoView(login: 1)
                .ignoresSafeArea(.all)
            
            // Setting up the Navigation Destination
                .navigationDestination(for: NavigationDestination.self) { destination in
                    coordinator.destination(for: destination)
                        .navigationBarBackButtonHidden(true)
                }
            
            // We check if we are going to home page from previous login or if we need to login
                .onChange(of: states.showloginLayer) { _, _ in
                    coordinator.push(accountLoggedIn ? .login : .home)
                }
            // From Login page to home page, Login Successful
                .onChange(of: states.logintohome) { _, _ in
                    coordinator.popToRoot()
                    coordinator.push(.home)
                }
            // We go from Login page to Registeration page to make a account
                .onChange(of: states.logintoregistration) { _, _ in
                    coordinator.push(.register)
                }
            // From Registration page to Login page, Registration Successful
                .onChange(of: states.madeaccount) {
                    coordinator.pop()
                }
            // Go to Account Settings
                .onChange(of: states.startsessiontoaccount ) { _, _ in
                    if states.startsessiontoaccount {
                        coordinator.push(.account)
                    }
                }
            // Logout out of Account
                .onChange(of: states.logout) { _, _ in
                    coordinator.popToRoot()
                    coordinator.push(.login)
                    states.LogoutToggle()
                }
            // Going back from Account page to Home page
                .onChange(of: states.accounttostartsession) { _, _ in
                    if states.accounttostartsession {
                        coordinator.pop()
                        states.AccountsettingToggle()
                        states.AccountBackToHomeToggle(back: 0)
                    }
                }
            // Going back and forth from home to start session
                .onChange(of: states.startingagame) {_, _ in
                    if states.startingagame{
                        coordinator.push(.startsession)
                    } else {
                        coordinator.pop()
                    }
                }
            
                .onChange(of: states.previewinggame){_, _ in
                    if states.previewinggame{
                        coordinator.push(.previewview)
                    } else {
                        coordinator.pop()
                    }
                }
            
                .onChange(of: states.watchhisorygame){_, _ in
                    if states.watchhisorygame{
                        coordinator.push(.watchhistorygame)
                    } else {
                        coordinator.pop()
                    }
                }
            
                .onChange(of: states.AWSClips){_, _ in
                    if states.AWSClips{
                        coordinator.pop()
                        coordinator.push(.AWSClips)
                    } else {
                        coordinator.pop()
                        coordinator.push(.clips)
                    }
                }
        }
    }
}

#Preview {
    Base()
}
