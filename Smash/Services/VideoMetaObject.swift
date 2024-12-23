//
//  VideoMetaObject.swift
//  Smash
//
//  Created by Abdullah B on 07/11/2024.
//

import Foundation
import SwiftUI

struct VideoMetaObject: Hashable, Codable {
    let path: URL
    let date: Date
    let duration: Int
    let timearray: [Int]
    let highlightarray: [[Int]]
}
