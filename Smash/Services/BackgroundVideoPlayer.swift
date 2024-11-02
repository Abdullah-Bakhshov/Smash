//
//  BackgroundVideoView.swift
//  Smash
//
//  Created by Jack Rong on 01/11/2024.
//

import SwiftUI
import AVFoundation

struct BackgroundVideoView: UIViewRepresentable {
    let login: Int
    @EnvironmentObject var viewingStatesModel: ViewingStatesModel

    
    // refactor and make this more general
    func statecheck() -> String {
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

    func makeUIView(context: Context) -> UIView {
        let view = UIView(frame: .zero)
        guard let path = Bundle.main.path(forResource: statecheck(), ofType: "mp4") else {
            return view
        }
        let player = AVPlayer(url: URL(fileURLWithPath: path))
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.videoGravity = .resizeAspectFill
        playerLayer.frame = UIScreen.main.bounds
        view.layer.addSublayer(playerLayer)
        player.play()
        
        
        
        
        //Video Loop
        NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: player.currentItem, queue: .main) { _ in
            if login > 1 {
                player.seek(to: .zero)
                player.play()
            } else {
                DispatchQueue.main.async {
                    viewingStatesModel.states.showLoginLayer = true
                }
            }
        }

        return view
    }

    func updateUIView(_ uiView: UIView, context: Context) {

    }
}

#Preview {
    BackgroundVideoView(login: 1)
}
