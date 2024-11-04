//
//  Account.swift
//  Smash
//
//  Created by Abdullah B on 01/11/2024.
//

import SwiftUI

struct AccountSettingsPage: View {
    
    @Bindable var states = ViewingStatesModel.shared

    var body: some View {
            ZStack{
                Color.black
                    .ignoresSafeArea()
                VStack{
                    Text("Account Settings")
                        .foregroundColor(.white)
                        .bold()
                        .font(.system(size:20))
                    
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
    }
}

#Preview {
    AccountSettingsPage()
}
