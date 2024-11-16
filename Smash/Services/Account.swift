//
//  Account.swift
//  Smash
//
//  Created by Abdullah B on 07/11/2024.
//

import Foundation
import SwiftUICore
class Account {
    // if logged in or not
    var accountLoggedIn: Bool = true
    private(set) var password: String = "123"
    private(set) var username: String = "123"
    @Bindable var pointstimer = CustomTimer.shared
    @Bindable var videodata = VideoContentViewModel.shared
    var historyarray : [VideoMetaObject] = []
    var pastlength : Int
    var index : Int
    
    
    init() {
        self.pastlength = 0
        self.index = 0
    }
    // this works
    func historycheck() -> Bool{
        if self.pastlength != videodata.storage.count {
            self.pastlength = videodata.storage.count
            print("this is the object highlight \(pointstimer.objecthighlight)")
            for (index,paths) in videodata.storage.enumerated() {
                self.historyarray.append(
                    VideoMetaObject(
                        path: paths,
                        date: videodata.datehistory[paths]!,
                        duration: pointstimer.historyduration[index],
                        timearray: pointstimer.historytime[index],
                        highlightarray: pointstimer.objecthighlight[index])
                )
            }
            return true
        } else {
            print("Up to date")
            return true
        }
    }
}
