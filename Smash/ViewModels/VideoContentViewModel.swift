//
//  VideoSystem.swift
//  Smash
//
//  Created by Abdullah B on 05/11/2024.
//

import SwiftUI
import Aespa
import Observation
import AVFAudio

@Observable
final class VideoContentViewModel {
    
    static let shared = VideoContentViewModel()
    public var storage : [URL] = []
    public var datehistory : [URL : Date] = [ : ]
    public var thumbnailhistory : [URL : Image] = [ : ]
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
        configureAudioSession()
        aespaSession
            .common(.focus(mode: .continuousAutoFocus))
            .common(.changeMonitoring(enabled: true))
            .common(.orientation(orientation: .portrait))
            .common(.quality(preset: .high))
        aespaSession.video(.unmute)
    }
    
    private func configureAudioSession() {
        do {
            let audioSession = AVAudioSession.sharedInstance()
            try audioSession.setCategory(.playAndRecord, options: [.defaultToSpeaker, .allowBluetooth])
            try audioSession.setMode(.videoRecording) // change between voice chat or video recording
            try audioSession.setActive(true)
            
            if audioSession.mode == .voiceChat {
                print("AGC control is active. Ensure no unnecessary processing happens.")
            }
        } catch {
            print("Failed to configure AVAudioSession: \(error)")
        }
    }
    
    @objc func StartandStopRecording() {
        if start {
            aespaSession.startRecording()
        } else {
            StoppingRecord{}
        }
    }
    
    func StoppingRecord(completion: @escaping () -> Void) {
        aespaSession.stopRecording { result in
            switch result {
            case .success(let file):
                print(file.path!)
                self.storage.append(file.path!)
                self.datehistory[file.path!] = file.creationDate
                self.thumbnailhistory[file.path!] = file.thumbnailImage
                print(self.storage)
                completion()
                
            case .failure(let error):
                print(error)
                completion()
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
