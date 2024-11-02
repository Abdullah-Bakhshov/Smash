//
//  Base.swift
//  Smash
//
//  Created by Jack Rong on 01/11/2024.
//

import SwiftUI


struct ViewingStates {
    var showLoginLayer: Bool
    var logintohome: Bool
    var logintoregistration : Bool
    var startsessiontoaccount : Bool
    var accounttostartsession : Bool
    var logout : Bool
    var madeaccount : Bool
}

class ViewingStatesModel: ObservableObject {
    @Published var states: ViewingStates

    init() {
        self.states = ViewingStates(
                                showLoginLayer: false,
                                logintohome: false,
                                logintoregistration: false,
                                startsessiontoaccount: false,
                                accounttostartsession: false,
                                logout: false,
                                madeaccount: false)
    }
    
    // Method to toggle the login layer state
    func toggleLoginLayer() {
        states.showLoginLayer.toggle()
    }
    
    func toggleLogintohome() {
        states.logintohome.toggle()
    }
    
    
}

struct Base: View {
    
    @Bindable private var coordinator = NavigationCoordinator.shared
    @EnvironmentObject var viewingStatesModel: ViewingStatesModel
    
    //If user is logged in previously or not
    
    private var accountLoggedIn: Bool = true


    var body: some View {
        NavigationStack(path: $coordinator.path) {
            BackgroundVideoView(login: 1)
                .ignoresSafeArea(.all)
                .navigationDestination(for: NavigationDestination.self) { destination in
                    coordinator.destination(for: destination)
                        .navigationBarBackButtonHidden(true)
                }
            
                .onChange(of: viewingStatesModel.states.showLoginLayer) { _ in
                    coordinator.push(accountLoggedIn ? .login : .home)
                }
                .onChange(of: viewingStatesModel.states.logintohome) { newValue in
                        coordinator.popToRoot()
                        coordinator.push(.home)
                }
                .onChange(of: viewingStatesModel.states.logintoregistration) { newValue in
                    coordinator.push(.register)
                }
                .onChange(of: viewingStatesModel.states.madeaccount) {
                    coordinator.pop()
                }
                .onChange(of: viewingStatesModel.states.startsessiontoaccount ) { newValue in
                    if viewingStatesModel.states.startsessiontoaccount == true {
                        coordinator.push(.account)
                    }
                }
                .onChange(of: viewingStatesModel.states.logout) { newValue in
                    coordinator.popToRoot()
                    coordinator.push(.login)
                    viewingStatesModel.states.logout = false
                }
                .onChange(of: viewingStatesModel.states.accounttostartsession) { _ in
                    if viewingStatesModel.states.accounttostartsession == true {
                        coordinator.pop()
                        viewingStatesModel.states.startsessiontoaccount = false
                        viewingStatesModel.states.accounttostartsession = false
                    }
                }
        }
    }
}

#Preview {
    let mockState = ViewingStatesModel()
    
    Base()
        .environmentObject(mockState)
}
