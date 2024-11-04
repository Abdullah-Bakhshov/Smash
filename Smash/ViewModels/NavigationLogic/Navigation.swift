//
//  Base.swift
//  Smash
//
//  Created by Jack Rong on 01/11/2024.
//

import SwiftUI
import Observation

// Setting up global variables

//struct ViewingStates {
//    var showLoginLayer: Bool
//    var logintohome: Bool
//    var logintoregistration : Bool
//    var startsessiontoaccount : Bool
//    var accounttostartsession : Bool
//    var logout : Bool
//    var madeaccount : Bool
//}
//
//class ViewingStatesModel: ObservableObject {
//    @Published var states: ViewingStates
//
//    init() {
//        self.states = ViewingStates(
//                                showLoginLayer: false,
//                                logintohome: false,
//                                logintoregistration: false,
//                                startsessiontoaccount: false,
//                                accounttostartsession: false,
//                                logout: false,
//                                madeaccount: false)
//    }
//}

//@Observable class ViewingStatesModel {
//    
//    var showLoginLayer: Bool = false
//    var logintohome: Bool = false
//    var logintoregistration : Bool = false
//    var startsessiontoaccount : Bool = false
//    var accounttostartsession : Bool = false
//    var logout : Bool = false
//    var madeaccount : Bool = false
//    
//    init(){
//    }
//}


struct Base: View {
    
    @Bindable private var coordinator = NavigationCoordinator.shared
    @Bindable var states = ViewingStatesModel.shared

    // If user is logged in previously or not
    private var accountLoggedIn: Bool = true

    var body: some View {
        NavigationStack(path: $coordinator.path) {
            BackgroundVideoView(login: 1)
                .ignoresSafeArea(.all)
                .navigationDestination(for: NavigationDestination.self) { destination in
                    coordinator.destination(for: destination)
                        .navigationBarBackButtonHidden(true)
                }
                .onChange(of: states.showloginLayer) { _, _ in
                    coordinator.push(accountLoggedIn ? .login : .home)
                }
                .onChange(of: states.logintohome) { _, _ in
                        coordinator.popToRoot()
                        coordinator.push(.home)
                }
                .onChange(of: states.logintoregistration) { _, _ in
                    coordinator.push(.register)
                }
                .onChange(of: states.madeaccount) {
                    coordinator.pop()
                }
                .onChange(of: states.startsessiontoaccount ) { _, _ in
                    if states.startsessiontoaccount {
                        coordinator.push(.account)
                    }
                }
                .onChange(of: states.logout) { _, _ in
                    coordinator.popToRoot()
                    coordinator.push(.login)
                    states.LogoutToggle()
                }
                .onChange(of: states.accounttostartsession) { _, _ in
                    if states.accounttostartsession {
                        coordinator.pop()
                        states.AccountsettingToggle()
                        states.AccountBackToHomeToggle(back: 0)
                }
            }
        }
    }
}

#Preview {
    Base()
}
