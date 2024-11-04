//
//  Registration.swift
//  Smash
//
//  Created by Abdullah B on 01/11/2024.
//

import SwiftUI

struct RegistrationPage: View {
    
    @Bindable var states = ViewingStatesModel.shared

    var body: some View {
        VStack{
            Text("Register")
                .font(.system(size: 20, weight: .bold))
                .foregroundStyle(.white)
                .padding()
            Button("Make Account !"){
                states.MadeAccountToggle()
            }
            .foregroundStyle(.white)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(LinearGradient(colors: [.blue, .purple], startPoint: .top, endPoint: .bottom), ignoresSafeAreaEdges: .all)
}
    }


#Preview {
    RegistrationPage()
}
