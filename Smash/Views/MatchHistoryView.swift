//
//  MatchHistory.swift
//  Smash
//
//  Created by Abdullah B on 01/11/2024.
//

import SwiftUI

struct MatchHistoryPage: View {
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
