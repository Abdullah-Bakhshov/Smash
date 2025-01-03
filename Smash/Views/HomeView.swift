//
//  StartSession.swift
//  Smash
//
//  Created by Abdullah B on 01/11/2024.
//

import SwiftUI

struct StartSessionPage: View {
    
    @Bindable var states = ViewingStatesModel.shared
    var permissionManager = PermissionManager()
    @Binding var isSheetPresented: Bool
    
    var body: some View {
        ZStack{
            BackgroundVideoView(login: 2)
                .edgesIgnoringSafeArea(.all)
            VStack{
                Button("🙅‍♂️") {
                    states.AccountsettingToggle()
                }
                .font(.system(size: 25))
                .frame(width: 40, height: 40)
                .background(Color.white)
                .clipShape(Circle())
                .overlay(
                    Circle()
                        .stroke(Color.gray, lineWidth: 3)
                )
                .shadow(color: .black.opacity(0.4), radius: 5, x: 0, y: 5)
                .offset(x: 150, y: -350)
                
                Text("Home")
                    .bold()
                    .font(.system(size:20))
                    .foregroundColor(.white)
                
                Button("Start a Session") {
                    Task {
                        if await permissionManager.permisionforvideo {
                            states.StartingGameToggle()
                        }
                    }
                }.foregroundColor(.white)
            }
        }
    }
}
