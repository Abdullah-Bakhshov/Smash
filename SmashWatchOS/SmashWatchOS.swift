//
//  SmashWatchOS.swift
//  SmashWatchOS
//
//  Created by Abdullah B on 09/11/2024.
//

import AppIntents

struct SmashWatchOS: AppIntent {
    static var title: LocalizedStringResource { "SmashWatchOS" }
    
    func perform() async throws -> some IntentResult {
        return .result()
    }
}
