//
//  LoginView.swift
//  SmashWatchOS Watch App
//
//  Created by Abdullah B on 04/11/2024.
//


import SwiftUI
import AnimateText

struct LoginView: View {
    
    @Bindable var states = ViewingStatesModel.shared
    
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var isRegistered: Bool = false
    @State private var title_text: String = ""
    @State var type: ATUnitType = .letters
    @State var userInfo: Double? = 0
    @State private var vStackOpacity: Double = 0
    @State private var showPasswordField: Bool = false
    
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [.purple, .blue, .green]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing)
            .ignoresSafeArea(.all)
            ScrollView {
                VStack {
                    Spacer(minLength: 250)
                    AnimateText<ATCurtainEffect>($title_text, type: type, userInfo: userInfo)
                        .font(.largeTitle)
                        .foregroundColor(.white)
                        .bold()
                        .fixedSize()
                    TextField("Username", text: $username)
                        .padding()
                        .cornerRadius(8)
                        .frame(width: 200, height: 50)
                        .fixedSize()
                        .foregroundColor(.white)
                        .background(Color.white.opacity(0.1).cornerRadius(8))
                        .onChange(of: username) {
                            withAnimation(.easeInOut(duration: 1)) {
                                showPasswordField = !username.isEmpty
                            }
                        }
                    
                    if showPasswordField {
                        HStack {
                            SecureField("Password", text: $password)
                                .padding()
                                .cornerRadius(8)
                                .frame(width: 130, height: 50)
                                .foregroundColor(.white)
                                .fixedSize()
                                .background(Color.white.opacity(0.1).cornerRadius(8))
                                .opacity(showPasswordField ? 1 : 0)
                                .animation(.easeInOut(duration: 1), value: showPasswordField)
                            
                            Button("💯") {
                                if Authentication().check(UserName: username, Password: password) {
                                    states.LoginToHomeToggle()
                                }
                            }
                            .font(.system(size: 30))
                            .padding()
                            .cornerRadius(4)
                            .shadow(color: .black.opacity(0.3), radius: 5, x: 0, y: 0)
                            .opacity(showPasswordField ? 1 : 0)
                            .animation(.easeInOut(duration: 1), value: showPasswordField)
                        }.transition(.opacity)
                    } else {
                        Button(isRegistered ? "Registered" : "Make an Account!") {
                            isRegistered = true
                            states.ToRegistrationToggle()
                        }
                        .padding()
                        .cornerRadius(4)
                        .foregroundColor(.white)
                        .frame(width: 200, height: 50)
                    }
                }
                .opacity(vStackOpacity)
                .onAppear {
                    title_text = "Get Ready"
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                        title_text = "Smash"
                    }
                    withAnimation(.easeOut(duration: 2)) {
                        vStackOpacity = 1
                    }
                }
            }
        }
    }
}

#Preview {
    LoginView()
}

