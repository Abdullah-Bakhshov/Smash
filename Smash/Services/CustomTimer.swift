//
//  CustomTimer.swift
//  Smash
//
//  Created by Abdullah B on 06/11/2024.
//

import Foundation
import Observation
import SwiftUI


@Observable
final class CustomTimer {
    
    var historytime: [[Int]] = []
    var historyduration: [Int] = []
    var duration: Int = 0
    var pointstime: [Int] = []
    var recordpoint: Bool = false
    private var timer: Timer!
    static let shared = CustomTimer()
    private var clock: Int = 0
    
    private init() {}
    
    func starttimer(){
        clock = 0
        self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(RecordTime), userInfo: nil, repeats: true)
    }
    
    @objc private func RecordTime() {
        clock += 1
        if recordpoint {
            pointstime.append(clock)
            print("Time recorded: \(clock)")
            print("array \(pointstime)")
            recordpoint = false
        }
    }

    func endtimer(){
        duration = clock
        self.timer.invalidate()
        clock = 0
    }
    
    func initialisetimer(){
        historytime.append(pointstime)
        historyduration.append(duration)
        pointstime.removeAll()
        duration = 0
    }
    
    func pointsarray() -> [Int] {
        return pointstime
    }
}

