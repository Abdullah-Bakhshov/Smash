//
//  PreviewView.swift
//  Smash
//
//  Created by Abdullah B on 06/11/2024.
//
import Foundation
import SwiftUI

struct PreviewView: View {
    
    @Bindable var pointstimer = CustomTimer.shared
    @Bindable var states = ViewingStatesModel.shared
    var path: URL = VideoContentViewModel.shared.URLReturn()
    
    var body: some View {
        ZStack {
            PreviewVideoPlayer(path: path)
            Color.black.opacity(0.5)
            Text("Preview")
                .foregroundColor(.white)
                .font(.title)

            .offset(x:0,y:50)
            Button("🤞") {
                states.PreviewingGameToggle()
                pointstimer.initialisetimer()

            }
            .font(.system(size:30))
            .clipShape(Circle())
            .frame(width: 50, height: 50)
            .offset(x:-150,y:-350)
            .shadow(color: .black, radius: 5, x: 0, y: 10)
        }.ignoresSafeArea(.all)
    }
}




#Preview {
    PreviewView()
}
