//
//  BackgroundVideoView.swift
//  Smash
//
//  Created by Jack Rong on 01/11/2024.
//

import SwiftUI
import AVFoundation

struct BackgroundVideoPlayerView: UIViewRepresentable {
    let login: Int // class atribute
    @Binding var showloginpage: Bool
    
    func statecheck() -> String {
        // should add async but will do after
        switch login {
        case 1:
            return "intro"
        
        case 2:
            return "Homepagebackground"
            
        case 3:
            return "MatchistoryBackground"
            
        default:
            return "null"
        }
    }
    
    func makeUIView(context: Context) -> UIView { // return UIView type
        let view = UIView(frame: .zero) // making the object UIView
        // Load video from bundle asests, guard is the same as a try else statement
        
        guard let path = Bundle.main.path(forResource: statecheck(), ofType: "mp4") else {
                return view
            }

        let player = AVPlayer(url: URL(fileURLWithPath: path))  // making AVPlayer object

        // Configure the player layer
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.videoGravity = .resizeAspectFill    // setting the size of the video
        playerLayer.frame = UIScreen.main.bounds
        view.layer.addSublayer(playerLayer)     // using it as a layer background layer
        
        // Start the video
        player.play()
        
        
        NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: player.currentItem, queue: .main) { _ in
            if login > 1 {
                player.seek(to: .zero) // Reset to the beginning
                player.play() // Play again
            }else{
                showloginpage.toggle()
            }
        }
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        // Handle updates if necessary
    }
}
