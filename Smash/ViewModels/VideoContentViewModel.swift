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
        aespaSession
            .common(.focus(mode: .continuousAutoFocus))
            .common(.changeMonitoring(enabled: true))
            .common(.orientation(orientation: .portrait))
            .common(.quality(preset: .high))
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
