//
//  VideoSystem.swift
//  Smash
//
//  Created by Abdullah B on 05/11/2024.
//

import SwiftUI
import Aespa
import Observation

@Observable
class VideoContentViewModel {
    let aespaSession: AespaSession
    var start: Bool = false
    var preview: some View {
        aespaSession.interactivePreview()
    }

    init() {
        let option = AespaOption(albumName: "Badminton clips")
        self.aespaSession = Aespa.session(with: option)
        
        SetUp()
    }

    func SetUp() {
        aespaSession
            .common(.focus(mode: .continuousAutoFocus))
            .common(.changeMonitoring(enabled: true))
            .common(.orientation(orientation: .portrait))
            .common(.quality(preset: .high))
    }
    
    
    func StartandStopRecording() {
        if start {
            aespaSession.startRecording()
        }
        else {
            aespaSession.stopRecording { result in
                switch result {
                case .success(let file):
                    print(file.path!)
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
}



#Preview {
    VideoSystem()
}
