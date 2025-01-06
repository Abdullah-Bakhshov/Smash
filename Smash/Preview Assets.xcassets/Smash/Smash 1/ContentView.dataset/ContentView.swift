//
//  ContentView.swift
//  Smash
//
//  Created by Abdullah B on 29/10/2024.
//

import SwiftUI





struct ContentView: View {

    // State is something that when used will keep track of what ever is declared and will adjust the view accordingly
    
    @State private var Username: String = ""
    @State private var WrongUsername: Int = 0
    
    @State private var Password: String = ""
    @State private var WrongPassword: Int = 0
    
    @State private var isLoggedIn: Bool = false
    
    @State private var isRegistered: Bool = false
    
    func login() {
        isLoggedIn = false
    }
    
    func register() {
        isRegistered = false
    }
    
    var body: some View {   //some is equivelent to auto or void*, return some type however has to be a type
        
        NavigationView {
            
            VStack {
                Text("Smash")
                
                
                Button(isLoggedIn ? "Logged in" : "Login") {
                    login()
                }
                .padding()
                Button(isRegistered ? "Registered" : "Make a Account!"){
                    register()
                }
            }
            
        }

    }
}

#Preview {
    ContentView()
}
