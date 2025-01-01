//
//  Account.swift
//  Smash
//
//  Created by Abdullah B on 07/11/2024.
//

import Foundation
import SwiftUICore

class Account {
    
    var historyarray: [VideoMetaObject] {
        get {
            if let data = UserDefaults.standard.data(forKey: "historyarray"),
               let decoded = try? JSONDecoder().decode([VideoMetaObject].self, from: data) {
                return decoded
            }
            return []
        }
        set {
            if let encoded = try? JSONEncoder().encode(newValue) {
                UserDefaults.standard.set(encoded, forKey: "historyarray")
            }
        }
    }
    
    var accountLoggedIn: Bool = true
    @Bindable var pointstimer = CustomTimer.shared
    @Bindable var videodata = VideoContentViewModel.shared
    var pastlength: Int
    var index: Int
    
    init() {
        self.pastlength = 0
        self.index = 0
    }
    
    
    func removeVideo(at index: Int) {
        guard index < historyarray.count else { return }
        var updatedArray = historyarray
        updatedArray.remove(at: index)
        historyarray = updatedArray
    }
    
    func removeInvalidPaths() {
        var updatedArray = historyarray
        updatedArray.removeAll { !FileManager.default.fileExists(atPath: $0.path.path) }
        historyarray = updatedArray
    }
    
    // History check
    func historycheck() -> Bool {
        if self.pastlength != videodata.storage.count {
            self.pastlength = videodata.storage.count
            print("this is the object highlight \(pointstimer.objecthighlight)")
            
            for (index, paths) in videodata.storage.enumerated() {
                let newMetaObject = VideoMetaObject(
                    path: paths,
                    date: videodata.datehistory[paths]!,
                    duration: pointstimer.historyduration[index],
                    timearray: pointstimer.historytime[index],
                    highlightarray: pointstimer.objecthighlight[index]
                )
                
                if !self.historyarray.contains(where: { $0.path == newMetaObject.path }) {
                    self.historyarray.append(newMetaObject)
                }
            }
            return true
        } else {
            print("Up to date")
            return true
        }
    }
}
