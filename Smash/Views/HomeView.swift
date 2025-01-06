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
    @State var sheetpresent = false
    
    var body: some View {
        ZStack{
            BackgroundVideoView(login: 2)
                .edgesIgnoringSafeArea(.all)
            
            VStack{
                Button(action: {
                    states.AccountsettingToggle()
                }) {
                    Text("🙅‍♂️")
                        .font(.system(size: 25))
                        .frame(width: 50, height: 50)
                        .background(
                            LinearGradient(gradient: Gradient(colors: [Color.white.opacity(0.2), Color.orange]), startPoint: .top, endPoint: .bottom)
                        )
                        .clipShape(Circle())
                        .shadow(color: .black.opacity(0.2), radius: 10, x: 0, y: 5)
                }
                .offset(x: 150, y: -320)

                Button(action: {
                    states.StatsToggle()
                }) {
                    Text("〽️")
                        .font(.system(size: 25))
                        .frame(width: 50, height: 50)
                        .background(
                            LinearGradient(gradient: Gradient(colors: [Color.white.opacity(0.2), Color.orange]), startPoint: .top, endPoint: .bottom)
                        )
                        .clipShape(Circle())
                        .shadow(color: .black.opacity(0.2), radius: 10, x: 0, y: 5)
                }
                .offset(x: 150, y: -300)
                
                Button(action: {
                    sheetpresent = true
                }) {
                    Text("🧑‍🤝‍🧑")
                        .font(.system(size: 25))
                        .frame(width: 50, height: 50)
                        .background(
                            LinearGradient(gradient: Gradient(colors: [Color.white.opacity(0.2), Color.orange]), startPoint: .top, endPoint: .bottom)
                        )
                        .clipShape(Circle())
                        .shadow(color: .black.opacity(0.2), radius: 10, x: 0, y: 5)
                }
                .offset(x: 150, y: -280)
                
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
                .sheet(isPresented: $sheetpresent) {
                                        FriendsSearchSheet(isSheetPresented: $sheetpresent)
                                            .presentationDetents([.medium, .large])
                                            .presentationDragIndicator(.visible)
                                    }
            }
        }
    }
}

#Preview {
    StartSessionPage()
}
