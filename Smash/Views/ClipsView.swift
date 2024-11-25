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
            
            // locally stored clips
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
                // we will do a get request to aws over here
                waiting = historydata.historycheck()
            }
        }
    }
}
// we add the POST to aws here
struct ClipRowView: View {
    var rowIndex: Int
    var historyData: Account

    var body: some View {
        let highlightClipArray = historyData.historyarray[rowIndex].highlightarray
        ForEach(highlightClipArray.indices, id: \.self) { columnIndex in
            let highlight = highlightClipArray[columnIndex]
            VideoView(h: highlight, p: historyData.historyarray[rowIndex].path)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .ignoresSafeArea(.all)
                .onAppear {
                    Task {
                        await HighlightClip().cropandexport(highlight: highlight, videoURL: historyData.historyarray[rowIndex].path)
                    }
                }
        }
    }
}

struct VideoView: View {
    var h: [Int]
    var p: URL
    var body: some View {
        PreviewVideoPlayer(path: p, highlight: h)
            .ignoresSafeArea(.all)
    }
}



/*/
 figure out a way to shorten the clip so we can get a highlight only done this now
 
 if I am going to use aws what i can do is i can make a array of highlight urls and do a for loop and use a
 get request for each video when the app is initialised and then use a post to upload a video and append the
 array for urls and
 
 */


#Preview {
    ClipsPage()
}
