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
    @Binding var timeatpoint: Int
    
    init(path: URL, highlight: [Int] = [0, 0], timeatpoint: Binding<Int>? = nil) {
        self.path = path
        self.highlight = highlight
        _timeatpoint = timeatpoint ?? .constant(highlight[0])
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIView(context: Context) -> UIView {
        
        let view = UIView(frame: .zero)
        let player = AVPlayer(url: path)
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.videoGravity = .resizeAspectFill
        playerLayer.frame = UIScreen.main.bounds
        view.layer.addSublayer(playerLayer)
        context.coordinator.player = player
        if timeatpoint > 0 && highlight[1] == 0 && highlight[0] == 0{
            player.seek(to: CMTime(seconds: Double(timeatpoint), preferredTimescale: 600))
        }
        
        if highlight[0] != 0 || highlight[1] != 0 {
            let startTime = CMTime(seconds: Double(highlight[0]), preferredTimescale: 600)
            let endTime = CMTime(seconds: Double(highlight[1]), preferredTimescale: 600)
            
            player.seek(to: startTime)
            
            // loop
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
        context.coordinator.player?.seek(to: CMTime(seconds: Double(timeatpoint), preferredTimescale: 600))
    }
    
    class Coordinator: NSObject {
        var parent: PreviewVideoPlayer
        var player: AVPlayer?
        
        init(_ parent: PreviewVideoPlayer) {
            self.parent = parent
        }
    }
}

