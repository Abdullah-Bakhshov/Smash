//
//  WatchHomeScreen.swift
//  SmashHomeScreen Watch App
//
//  Created by Abdullah B on 09/11/2024.
//

import SwiftUI
import AnimateText

struct WatchHomeScreen: View {
    @State var type: ATUnitType = .letters
    @State private var title_text: String = ""
    @State var userInfo: Double? = 0
    
    var body: some View {
        ZStack(){
            LinearGradient(
                gradient: Gradient(colors: [Color(hex: "ffb600"), Color(hex: "ff4800")]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            AnimateText<ATCurtainEffect>($title_text, type: type, userInfo: userInfo)
                .font(.largeTitle)
                .foregroundColor(.white)
                .bold()
                .offset(x: 0, y: -5)
        }
        .onAppear {
            title_text = "Get Ready"
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                title_text = "Smash"
            }
        }
        .frame(width: 300, height: 300)
    }
}

#Preview {
    WatchHomeScreen()
}
