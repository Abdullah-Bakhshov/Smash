//
//  Account.swift
//  Smash
//
//  Created by Abdullah B on 01/11/2024.
//

import SwiftUI

struct AccountSettingsPage: View {
    
    @Bindable var states = ViewingStatesModel.shared
    @State var isPublic: String = "Loading..."
    var body: some View {
        ZStack{
            Color.black
                .ignoresSafeArea()
            VStack{
                Text("Account Settings")
                    .foregroundColor(.white)
                    .bold()
                    .font(.system(size:20))
                    .padding()
                
                Button(isPublic == "true" ? "Account is Public" : "Account is Private") {
                    if isPublic == "true" {
                        Task {
                            await ClientForAPI().togglingProfilePublic(status: true)
                            isPublic = "false"
                        }
                    } else if isPublic == "false" {
                        Task {
                            await ClientForAPI().togglingProfilePublic(status: false)
                            isPublic = "true"
                        }
                    }
                }
                .foregroundStyle(.white)
                
                Button("Logout"){
                    states.reset()
                }
                .foregroundStyle(.white)
                .padding()
                
                Button("Back"){
                    states.AccountBackToHomeToggle(back: 1)
                }
                .foregroundStyle(.white)
            }
        }
        .onAppear {
            Task { isPublic = await String(ClientForAPI().checkingIfProfilePublic(username: GlobalAccountinfo.shared.username))
            }
        }
    }
}

#Preview {
    AccountSettingsPage()
}
