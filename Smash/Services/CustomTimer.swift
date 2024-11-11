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
    
    var objecthighligt: [[[Int]]] = []
    var highlightcliparray: [[Int]] = []
    var historytime: [[Int]] = []
    var historyduration: [Int] = []
    var pointstime: [Int] = [0]
    var recordpoint: Bool = false
    private var timer: Timer?
    static let shared = CustomTimer()
    private(set) var clock: Int = 0
    
    private init() {}
    
    func starttimer() {
        timer?.invalidate()
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
    
    func endtimer() {
        historyduration.append(clock)
        timer?.invalidate()
        timer = nil
        clock = 0
    }
    
    func initialisetimer() {
        pointstime.append(clock)
//        historyduration.append(clock)
        objecthighligt.append(highlightcliparray)
        historytime.append(pointstime)
        pointstime.removeAll()
        highlightcliparray.removeAll()
        pointstime.append(clock)
        timer?.invalidate()
        clock = 0
    }
    
    func pointsarray() -> [Int] {
        return pointstime
    }
    
    func highlightclip() {
        let temp = Array(pointstime.suffix(2))
        if temp.count > 1 {
            highlightcliparray.append(temp)
            print("\(highlightcliparray)")
        }
    }
}


