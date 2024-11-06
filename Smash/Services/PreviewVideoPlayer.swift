//
//  PreviewVideoPlayer.swift
//  Smash
//
//  Created by Abdullah B on 06/11/2024.
//

import SwiftUI
import AVFoundation

struct PreviewVideoPlayer: UIViewRepresentable{

    let path : URL
    
    func makeUIView(context: Context) -> UIView {

        let view = UIView(frame: .zero)
        let player = AVPlayer(url: path)
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.videoGravity = .resizeAspectFill
        playerLayer.frame = UIScreen.main.bounds
        view.layer.addSublayer(playerLayer)
        player.play()
        return view
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
    }
    
}
