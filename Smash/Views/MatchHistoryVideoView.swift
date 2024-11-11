//
//  MatchHistoryVideoView.swift
//  Smash
//
//  Created by Abdullah B on 07/11/2024.
//

import SwiftUI

struct MatchHistoryVideoView: View {
    
    @Bindable var states = ViewingStatesModel.shared
    @State var index = 0
    @State var timearray: [Int] = [0]
    
    var matchpath = MatchHistoryPage()
    var body: some View {
        ZStack {
            let path = matchpath.returnpath()
            PreviewVideoPlayer(path: path, timeatpoint: $timearray[index])
            Button("🤞") {
                states.WatchHistoryGameToggle()
            }
            .font(.system(size: 30))
            .clipShape(Circle())
            .frame(width: 50, height: 50)
            .offset(x: -150, y: -350)
            .shadow(color: .black, radius: 5, x: 0, y: 10)
        }
        .onAppear() {
            timearray = matchpath.returntimearray()
            print(timearray)
        }
        .ignoresSafeArea(.all)
        .onTapGesture(count: 1) {
            if index < timearray.count - 1 {
                index += 1
            }
        }
        .onTapGesture(count: 2) {
            if index > 0 {
                index -= 1
            }
        }
    }
}

#Preview {
    MatchHistoryVideoView()
}


