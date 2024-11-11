import SwiftUI

struct WatchBase: View {
    @Bindable private var coordinator = WatchNavigationCoordinator.shared
    @Bindable private var state = WatchState.shared
    @StateObject private var sessionManager = SessionManager.shared
    
    
    
    var body: some View {
        NavigationStack(path: $coordinator.path) {
            
            WatchHomeScreen()
                .navigationDestination(for: NavigationDestination.self) { destination in
                    coordinator.destination(for: destination)
                        .navigationBarBackButtonHidden(true)
                }
            
                .onChange(of: state.home) { _, _ in
                    if state.home {
                        coordinator.push(.watchhomescreen)
                    } else {
                        coordinator.popToRoot()
                        coordinator.push(.watchsession)
                    }
                }
        }
    }
}
