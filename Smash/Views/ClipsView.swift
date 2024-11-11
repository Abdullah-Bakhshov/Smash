//
//  Clips.swift
//  Smash
//
//  Created by Abdullah B on 01/11/2024.
//

import SwiftUI

struct ClipsPage: View {
    
    @Bindable var states = ViewingStatesModel.shared
    var historydata = Account()
    @State private var waiting: Bool = false
    
    var body: some View {
        ZStack{
            LinearGradient(colors: [.blue, .green], startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea(.all)
            VStack {
                Text("Cmon you can't look at this page without any clips 👀")
                    .foregroundStyle(.white)
                    .fontWeight(.bold)
                    .font(.title2)
                    .multilineTextAlignment(.center)
                    .padding()
            }
            TabView {
                if waiting {
                    ForEach(historydata.historyarray.indices, id: \.self) { rowIndex in
                        ClipRowView(rowIndex: rowIndex, historyData: historydata)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .ignoresSafeArea(.all)
                    }
                }
                
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            .ignoresSafeArea(.all)
            .onAppear {
                waiting = historydata.historycheck()
            }
        }
    }
}

struct ClipRowView: View {
    var rowIndex: Int
    var historyData: Account
    var body: some View {
        let highlightClipArray = historyData.historyarray[rowIndex].highlightarray
        ForEach(highlightClipArray.indices, id: \.self) { columnIndex in
            VideoView(h: highlightClipArray[columnIndex], p: historyData.historyarray[rowIndex].path)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .ignoresSafeArea(.all)
        }
        
    }
}

struct VideoView: View {
    var h: [Int]
    var p: URL
    @State var i = 0
    var body: some View {
        PreviewVideoPlayer(path: p, highlight: h, timeatpoint: $i)
            .ignoresSafeArea(.all)
    }
}



#Preview {
    ClipsPage()
}
