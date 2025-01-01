//
//  Registration.swift
//  Smash
//
//  Created by Abdullah B on 01/11/2024.
//

import SwiftUI

struct RegistrationPage: View {
    
    @Bindable var states = ViewingStatesModel.shared
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var makeaccountbutton: String = "Make Account"
    
    var body: some View {
        VStack{
            Text("Register")
                .font(.system(size: 30, weight: .bold))
                .foregroundStyle(.white)
                .padding()
            
            TextField("Username", text: $username)
                .padding()
                .cornerRadius(8)
                .frame(width: 200, height: 50)
                .fixedSize()
                .foregroundColor(.white)
                .background(Color.white.opacity(0.1).cornerRadius(8))

            
            SecureField("Password", text: $password)
                .padding()
                .cornerRadius(8)
                .frame(width: 200, height: 50)
                .fixedSize()
                .foregroundColor(.white)
                .background(Color.white.opacity(0.1).cornerRadius(8))
            
            
            Button(makeaccountbutton){
                if !Authentication().userNameInUse(username: username) {
                    Task {
                        await ClientForAPI().makeAccount(username: username, password: password)
                    }
                    states.MadeAccountToggle()
                } else {
                    makeaccountbutton = "account already in use"
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        makeaccountbutton = "Make Account"
                    }
                }
            }
            .padding()
            .foregroundStyle(.white)
            
            Button("Back"){
                states.MadeAccountToggle()
            }
            .foregroundStyle(.white)
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(LinearGradient(colors: [.blue, .red], startPoint: .top, endPoint: .bottom), ignoresSafeAreaEdges: .all)
    }
}


#Preview {
    RegistrationPage()
}
