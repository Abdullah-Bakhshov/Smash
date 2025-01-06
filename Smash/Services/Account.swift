//
//  Account.swift
//  Smash
//
//  Created by Abdullah B on 07/11/2024.
//

import Foundation
import SwiftUICore

class Account {
    
    // Stored properties with UserDefaults integration
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
    
//    // Key-value pair for username and login state
//    var username: String {
//        get {
//            UserDefaults.standard.string(forKey: "username") ?? ""
//        }
//        set {
//            UserDefaults.standard.set(newValue, forKey: "username")
//        }
//    }
    
//    var accountLoggedIn: Bool {
//        get {
//            UserDefaults.standard.bool(forKey: "accountLoggedIn")
//        }
//        set {
//            UserDefaults.standard.set(newValue, forKey: "accountLoggedIn")
//        }
//    }
    var accountLoggedIn: Bool = false
//
    @Bindable var pointstimer = CustomTimer.shared
    @Bindable var videodata = VideoContentViewModel.shared
    var pastlength: Int
    var index: Int
    
    init() {
        self.pastlength = 0
        self.index = 0
//        self.username = GlobalAccountinfo.shared.username
//        self.accountLoggedIn = true
    }
    
//    func setAccountLoggedIn(username: String) {
//        self.username = username
//        self.accountLoggedIn = true
//    }
    
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

