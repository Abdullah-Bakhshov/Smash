//
//  S3Clips.swift
//  Smash
//
//  Created by Abdullah B on 22/12/2024.
//

import SwiftUI
import AVKit

struct PreSignedURLView: View {
    @State var clipsURLs: [URL] = []
    @Bindable var states = ViewingStatesModel.shared

    @State private var currentIndex: Int = 0 // Track the current index of the video
    
    var body: some View {
        ZStack {
            TabView(selection: $currentIndex) {
                ForEach(clipsURLs.indices, id: \.self) { index in
                    VideoPlayerView(url: clipsURLs[index])
                        .tag(index) // Tag for each video
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .ignoresSafeArea(.all)
            
            Button("My Clips"){
                states.AWSClipsToggle()
            }
            .foregroundColor(.white)
            .font(.title2)
            .bold()
            .padding()
            .zIndex(1)
            .offset(y: -400)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .ignoresSafeArea(.all)
        .onAppear {
            Task {
                await clipsURLs = ClipsPage().fetchAWSClips()
            }
        }
    }
}


struct VideoPlayerView: View {
    var url: URL
    @State private var player: AVPlayer?
    
    var body: some View {
        VideoPlayer(player: player)
            .onAppear {
                // Setup the player and start playback
                player = AVPlayer(url: url)
                player?.play()
                
                // Set up looping behavior
                loopVideo(player: player)
            }
            .onDisappear {
                player?.pause()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .ignoresSafeArea(.all)
    }
    
    // Method to loop the video using NotificationCenter
    private func loopVideo(player: AVPlayer?) {
        guard let player = player else { return }
        
        // Register for the AVPlayerItemDidPlayToEndTime notification
        NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime,
                                               object: player.currentItem,
                                               queue: .main) { _ in
            // When the video finishes, seek back to the start and play again
            player.seek(to: CMTime.zero)
            player.play()
        }
    }
}




