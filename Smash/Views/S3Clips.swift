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

    @State private var currentIndex: Int = 0
    
    var body: some View {
        ZStack {
            TabView(selection: $currentIndex) {
                ForEach(clipsURLs.indices, id: \.self) { index in
                    FullScreenVideoPlayerView(url: clipsURLs[index])
                        .ignoresSafeArea(.all)
                        .tag(index)
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .ignoresSafeArea(.all)
            
            Button("explore") {
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

struct FullScreenVideoPlayerView: View {
    var url: URL
    @State private var player: AVPlayer?
    
    var body: some View {
        VideoPlayerLayerView(player: player)
            .onAppear {
                player = AVPlayer(url: url)
                player?.play()
                
                loopVideo(player: player)
            }
            .onDisappear {
                player?.pause()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .ignoresSafeArea(.all)
    }
    
    private func loopVideo(player: AVPlayer?) {
        guard let player = player else { return }
        
        NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime,
                                               object: player.currentItem,
                                               queue: .main) { _ in
            player.seek(to: CMTime.zero)
            player.play()
        }
    }
}

struct VideoPlayerLayerView: UIViewRepresentable {
    var player: AVPlayer?
    
    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.videoGravity = .resizeAspectFill
        playerLayer.frame = UIScreen.main.bounds
        view.layer.addSublayer(playerLayer)
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        guard let playerLayer = uiView.layer.sublayers?.first as? AVPlayerLayer else { return }
        playerLayer.player = player
    }
}
