//
//  PreviewView.swift
//  Smash
//
//  Created by Abdullah B on 06/11/2024.
//

import SwiftUI

struct PreviewView: View {
    
    @Bindable var towatch = WatchSingleton.shared
    @Bindable var pointstimer = CustomTimer.shared
    @Bindable var states = ViewingStatesModel.shared
    var path: URL = VideoContentViewModel.shared.URLReturn()
    @State var initialvalue = 0
    @State private var isUploading = false
    
    var body: some View {
        ZStack {
            
            PreviewVideoPlayer(path: path)
            Color.black.opacity(0.5)
            
            Text("Preview")
                .foregroundColor(.white)
                .font(.title)
                .offset(x: 0, y: 50)
            
            Button("Upload Clips") {
                startUpload()
            }
            .foregroundColor(.white)
            .font(.caption)
            .offset(x: 0)
            
            Button("🤞") {
                towatch.returnsendtowatch()
                states.PreviewingGameToggle()
                pointstimer.initialisetimer()
            }
            .font(.system(size: 30))
            .clipShape(Circle())
            .frame(width: 50, height: 50)
            .offset(x: -150, y: -350)
            .shadow(color: .black, radius: 5, x: 0, y: 10)
        }
        .ignoresSafeArea(.all)
    }

    
    func startUpload() {
        guard !isUploading else { return }
        isUploading = true
        Task {
            for highlight in pointstimer.highlightcliparray {
                await HighlightClip().cropandexport(highlight: highlight, videoURL: path)
            }
            isUploading = false
        }
    }
}

#Preview {
    PreviewView()
}
