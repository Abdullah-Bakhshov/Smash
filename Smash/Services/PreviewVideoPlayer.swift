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
    @Binding var isPlaying: Bool
    @Binding var timeatpoint: Int

    init(path: URL, highlight: [Int] = [0, 0], timeatpoint: Binding<Int>? = nil, isPlaying: Binding<Bool> = .constant(true)) {
        self.path = path
        self.highlight = highlight
        _timeatpoint = timeatpoint ?? .constant(highlight[0])
        _isPlaying = isPlaying
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
        setupPlayer(player: player)
        return view
    }

    func updateUIView(_ uiView: UIViewType, context: Context) {
        context.coordinator.updatePlaybackState(isPlaying: isPlaying)
        context.coordinator.updateTime(to: timeatpoint)
    }

    private func setupPlayer(player: AVPlayer) {
        if highlight[0] != 0 || highlight[1] != 0 {
            let startTime = CMTime(seconds: Double(highlight[0]), preferredTimescale: 600)
            let endTime = CMTime(seconds: Double(highlight[1]), preferredTimescale: 600)

            player.seek(to: startTime)
            player.addPeriodicTimeObserver(forInterval: CMTime(seconds: 0.1, preferredTimescale: 600), queue: .main) { time in
                if time >= endTime {
                    player.seek(to: startTime)
                }
            }
        } else if timeatpoint > 0 {
            player.seek(to: CMTime(seconds: Double(timeatpoint), preferredTimescale: 600))
        }
        player.play()
    }

    class Coordinator: NSObject {
        var parent: PreviewVideoPlayer
        var player: AVPlayer?

        init(_ parent: PreviewVideoPlayer) {
            self.parent = parent
        }
    }
}

extension PreviewVideoPlayer.Coordinator {
    /// Update the playback state based on `isPlaying`.
    func updatePlaybackState(isPlaying: Bool) {
        if isPlaying {
            player?.play()
        } else {
            player?.pause()
        }
    }

    /// Seek the player to a specific time.
    func updateTime(to time: Int) {
        guard let player = player else { return }
        let cmTime = CMTime(seconds: Double(time), preferredTimescale: 600)
        player.seek(to: cmTime)
    }
}

extension PreviewVideoPlayer {
    /// Pause playback using the `context` coordinator.
    func stop(context: Context) {
        DispatchQueue.main.async {
            context.coordinator.updatePlaybackState(isPlaying: false)
        }
    }

    /// Start playback using the `context` coordinator.
    func start(context: Context) {
        DispatchQueue.main.async {
            context.coordinator.updatePlaybackState(isPlaying: true)
        }
    }
}

