//
//  LoginView.swift
//  Smash
//
//  Created by Jack Rong on 01/11/2024.
//

import SwiftUI
import AnimateText

struct LoginView: View {
    
    @State private var username: String = ""
    @State private var password: String = ""
    
    @State private var isLoggedIn: Bool = false
    @State private var isRegistered: Bool = false
    
    @State private var isHomePage: Bool = false
    @State private var isRagistationPage: Bool = false
    
    // Animation of the text
    
    @State private var title_text: String = ""
    @State var type: ATUnitType = .letters
    //sets the delay
    @State var userInfo: Double? = 0
    
    
    @State private var vStackOpacity: Double = 0
    
    
    @State private var showPasswordField: Bool = false
    
    func register() {
        isRegistered = true // Set to true to simulate registration success
        isRagistationPage = true
    }
    
    func authentication (username: String, password: String){
        //this is a tester piece of code just to get it working want to add websock and everything else later. Something good for scalling. ---- Can implement a hashmap with username as key and the value is the password, password we can use another algo called sha for encryption and then store it as the key value pair
        if username == "123" && password == "123"{
            isHomePage = true
            isLoggedIn = true
        }
    }
    
    @State private var showBackgroundVideo: Bool = true
    
    var body: some View {
        ZStack {
            // Background video view
            BackgroundVideoPlayerView(login: 1, showloginpage: $showBackgroundVideo)
                .edgesIgnoringSafeArea(.all) // Make it full-screen, this is where they dynamic island is
            
            VStack {
                //title animation
                AnimateText<ATCurtainEffect>($title_text, type: type, userInfo: userInfo)
                    .font(.largeTitle)
                    .foregroundColor(.white)
                    .bold()
                TextField("Username", text: $username)
                    .padding()
                    .cornerRadius(8)
                    .frame(width:200 , height: 50)
                    .foregroundColor(.white)
                    .onChange(of: username) {
                        withAnimation(.easeInOut(duration:1)) {
                            showPasswordField = !username.isEmpty
                        }
                    }
                
                if showPasswordField {
                    HStack{
                        SecureField("Password", text: $password)
                            .padding()
                            .cornerRadius(8)
                            .frame(width: 130, height: 50)
                            .foregroundColor(.white)
                            .opacity(showPasswordField ? 1 : 0) // Fade in opacity
                            .animation(.easeInOut(duration: 1), value: showPasswordField)

                        Button("💯") {
                            authentication(username: username, password: password)
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
                        register()
                    }
                    .padding()
                    .cornerRadius(4)
                    .foregroundColor(.yellow)
                    .frame(width: 200, height: 50)
                }
            }
            .frame(width:1800, height:1000)
            .background(LinearGradient(colors: [.orange, .red], startPoint: .top, endPoint: .bottom), ignoresSafeAreaEdges: .all)
            .opacity(vStackOpacity) // Bind opacity to state
            .navigationDestination(isPresented: $isHomePage) {
                HomePage().navigationBarBackButtonHidden(true)
            }
            // goes to registration page if true
            .navigationDestination(isPresented: $isRagistationPage){
                RegistrationPage()
            }
            //this happens at real time and you wanna add anything dynamic into this
            .onAppear {
                title_text = "Get Ready"
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    title_text = "Smash"
                }
                withAnimation(.easeOut(duration: 2)) {
                    vStackOpacity = 1 // Fade in
                }
            }

        }
    }
}

#Preview {
    LoginView()
}
