//
//  MatchHistoryVideoView.swift
//  Smash
//
//  Created by Abdullah B on 07/11/2024.
//

import SwiftUI

struct MatchHistoryVideoView: View {
    
    @Bindable var states = ViewingStatesModel.shared
    var matchpath = MatchHistoryPage()
    var body: some View {
        ZStack{
            let path = matchpath.returnpath()
            PreviewVideoPlayer(path: path)
            Button("🤞") {
                states.WatchHistoryGameToggle()
            }
            .font(.system(size:30))
            .clipShape(Circle())
            .frame(width: 50, height: 50)
            .offset(x:-150,y:-350)
            .shadow(color: .black, radius: 5, x: 0, y: 10)
        }
        .ignoresSafeArea(.all)
    }
}

#Preview {
    //    MatchHistoryVideoView()
}
