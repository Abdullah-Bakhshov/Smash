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
    @State private var clipsURLs: [URL] = []
    @State private var currentClipIndex: Int? = nil
    @State private var activeVideoViewKeys: Set<Int> = []

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

                HStack {
                    Button("clips") {
                        goToBlankPageAndToggle {
                            states.AWSClipsToggle()
                        }
                    }
                    .foregroundColor(.white)
                    .font(.title2)
                    .bold()
                    .padding()
                    .offset(y: -400)

                    Button("home") {
                        goToBlankPageAndToggle {
                            states.ClipstoHomeToggle()
                        }
                    }
                    .foregroundColor(.white)
                    .font(.title2)
                    .bold()
                    .padding()
                    .offset(y: -400)
                }
                .zIndex(1)

                if waiting && !historydata.historyarray.isEmpty {
                    TabView(selection: $currentClipIndex) {
                        ForEach(historydata.historyarray.indices, id: \.self) { rowIndex in
                            let highlightClipArray = historydata.historyarray[rowIndex].highlightarray
                            ForEach(highlightClipArray.indices, id: \.self) { columnIndex in
                                let videoKey = rowIndex * 1000 + columnIndex
                                let highlight = highlightClipArray[columnIndex]

                                VideoView(
                                    h: highlight,
                                    p: historydata.historyarray[rowIndex].path,
                                    isActive: Binding(
                                        get: { currentClipIndex == videoKey },
                                        set: { newValue in
                                            if newValue == false {
                                                activeVideoViewKeys.remove(videoKey)
                                            } else {
                                                activeVideoViewKeys.insert(videoKey)
                                            }
                                        }
                                    ),
                                    destroyAction: {
                                        activeVideoViewKeys.remove(videoKey)
                                    }
                                )
                                .id(videoKey)
                                .onAppear {
                                    activeVideoViewKeys.insert(videoKey)
                                }
                                .onDisappear {
                                    if currentClipIndex != videoKey {
                                        activeVideoViewKeys.remove(videoKey)
                                    }
                                }
                                .tag(videoKey)
                            }
                        }
                        
                        Color.black
                            .tag(999)
                            .transition(.opacity)
                            .zIndex(0)
                            .ignoresSafeArea(.all)
                    }
                    .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
                    .ignoresSafeArea(.all)
                } else {
                    Text("Cmon you can't look at this page without any clips 👀")
                        .foregroundStyle(.white)
                        .fontWeight(.bold)
                        .font(.title2)
                        .multilineTextAlignment(.center)
                        .padding()
                }
            }
        }
        .onAppear {
            activeVideoViewKeys.removeAll()
            waiting = historydata.historycheck()
        }
        .onDisappear {
            currentClipIndex = nil
            activeVideoViewKeys.removeAll()
        }
    }

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
    
    private func goToBlankPageAndToggle(action: @escaping () -> Void) {
        currentClipIndex = 999
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            action()
        }
    }
}

struct VideoView: View {
    var h: [Int]
    var p: URL
    @Binding var isActive: Bool
    var destroyAction: () -> Void
    
    var body: some View {
        PreviewVideoPlayer(path: p, highlight: h, isPlaying: $isActive)
            .onAppear {
                isActive = true
            }
            .onDisappear {
                isActive = false
                destroyAction()
            }
            .ignoresSafeArea(.all)
    }
}
