//
//  PreviewVideoPlayer.swift
//  Smash
//
//  Created by Abdullah B on 06/11/2024.
//

import SwiftUI
import AVFoundation

struct PreviewVideoPlayer: UIViewRepresentable {
    let path: URL
    var highlight: [Int] = [0, 0]
    
    func makeUIView(context: Context) -> UIView {
        let view = UIView(frame: .zero)
        let player = AVPlayer(url: path)
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.videoGravity = .resizeAspectFill
        playerLayer.frame = UIScreen.main.bounds
        view.layer.addSublayer(playerLayer)
        
        if highlight[0] != 0 || highlight[1] != 0 {
            let startTime = CMTime(seconds: Double(highlight[0]), preferredTimescale: 600)
            let endTime = CMTime(seconds: Double(highlight[1]), preferredTimescale: 600)
            
            player.seek(to: startTime)
            
            // Add periodic time observer to monitor playback position
            player.addPeriodicTimeObserver(forInterval: CMTime(seconds: 0.1, preferredTimescale: 600), queue: .main) { time in
                if time >= endTime {
                    player.seek(to: startTime)
                }
            }
        }
        player.play()
        return view
    }
    func updateUIView(_ uiView: UIViewType, context: Context) {
    }
}
