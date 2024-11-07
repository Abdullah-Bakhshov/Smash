//
//  MatchHistory.swift
//  Smash
//
//  Created by Abdullah B on 01/11/2024.
//

import SwiftUI

struct MatchHistoryPage: View {
    
    // use the history in this to get all the history data
    @Bindable var viewmodel = VideoContentViewModel.shared
    @State private var showloginlayer: Bool = false
    var body: some View {
        ZStack{
            BackgroundVideoView(login: 3)
                .edgesIgnoringSafeArea(.all)
            Text("Match History")
                .foregroundColor(.white)
                .bold()
                .font(.system(size:20))
            
            
            
        }
    }
}

#Preview {
    MatchHistoryPage()
}
