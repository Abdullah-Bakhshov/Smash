//
//  Account.swift
//  Smash
//
//  Created by Abdullah B on 01/11/2024.
//

import SwiftUI

struct AccountSettingsPage: View {
    @EnvironmentObject var viewingStatesModel: ViewingStatesModel
    
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
                        viewingStatesModel.states.logout = true
                        viewingStatesModel.states.logintohome = false
                        viewingStatesModel.states.logintoregistration = false
                        viewingStatesModel.states.startsessiontoaccount = false
                        viewingStatesModel.states.accounttostartsession = false
                        viewingStatesModel.states.madeaccount = false

                    }
                    .foregroundStyle(.white)
                    .padding()
                    
                    Button("Back"){
                        viewingStatesModel.states.accounttostartsession = true

                    }
                    .foregroundStyle(.white)
                }
            }
    }
}

#Preview {
    AccountSettingsPage()
}
