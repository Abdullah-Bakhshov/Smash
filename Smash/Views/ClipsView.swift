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
    @State private var clipsURLs: [URL] = []  // Store pre-signed URLs here
    
    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(colors: [.blue, .green], startPoint: .top, endPoint: .bottom)
                    .ignoresSafeArea(.all)
                Text("Cmon you can't look at this page without any clips 👀")
                    .foregroundStyle(.white)
                    .fontWeight(.bold)
                    .font(.title2)
                    .multilineTextAlignment(.center)
                    .padding()
                
                Button("fyp"){
                    states.AWSClipsToggle()
                }
                .foregroundColor(.white)
                .font(.title2)
                .bold()
                .padding()
                .zIndex(1)
                .offset(y: -400)
                
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
            }
        }
        .onAppear {
            waiting = historydata.historycheck()
        }
    }
    
    // Fetch pre-signed URLs for AWS stored clips
    func fetchAWSClips() async -> [URL] {
        let s3Requests = S3Requests()
        let bucketName = "smash-app-public-clips"
        
        do {
            let fileKeys = await s3Requests.listFiles(from: bucketName)
            var urls: [URL] = []
            
            for key in fileKeys {
                if let url = await s3Requests.generatePreSignedURL(bucket: bucketName, key: key) {
                    urls.append(url)
                }
            }
            
            self.clipsURLs = urls
            return urls
        }
    }
}

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


#Preview {
    ClipsPage()
}
