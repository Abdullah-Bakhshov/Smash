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
final class VideoContentViewModel {
    
    static let shared = VideoContentViewModel()
    
    public var storage : [URL] = []
    public var history : [Date : URL] = [ : ]
    let aespaSession: AespaSession
    var start: Bool = false
    var preview: some View {
        aespaSession.interactivePreview()
    }

    private init() {
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
                    self.storage.append(file.path!)
                    self.history[file.creationDate] = file.path!
                    print(self.storage)
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
    
    func URLReturn () -> URL {
        let url = storage.last
        return url!
    }
}



#Preview {
    VideoSystem()
}
