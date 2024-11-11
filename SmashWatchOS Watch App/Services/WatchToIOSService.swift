//
//  WatchToIOSService.swift
//  SmashWatchOS Watch App
//
//  Created by Abdullah B on 09/11/2024.
//



import SwiftUI
import WatchConnectivity

class SessionManager: NSObject, ObservableObject, WCSessionDelegate {
    
    static let shared = SessionManager()
    @Bindable private var state = WatchState.shared
    @Published var isConnected = false
    @State var historyscoredata: [[Int]] = []
    @State var cliphighlight: Bool = false
    
    private override init() {
        super.init()
        if WCSession.isSupported() {
            WCSession.default.delegate = self
            WCSession.default.activate()
        }
    }
    
    // WCSessionDelegate Methods
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        DispatchQueue.main.async {
            self.isConnected = (activationState == .activated)
            print("Watch session activated: \(self.isConnected)")
            print("Session reachable: \(session.isReachable)")
        }
    }
    
    // Handle messages that require a reply
    func session(_ session: WCSession, didReceiveMessage message: [String: Any], replyHandler: @escaping ([String: Any]) -> Void) {
        print("Received message with reply handler: \(message)")
        handleMessage(message: message)
        replyHandler(["status": "received"])
    }
    
    // Handle messages that don't require a reply
    func session(_ session: WCSession, didReceiveMessage message: [String: Any]) {
        print("Received message without reply handler: \(message)")
        handleMessage(message: message)
    }
    
    private func handleMessage(message: [String: Any]) {
        print("Processing message: \(message)")
        DispatchQueue.main.async {
            if message.keys.contains("gamestarted") {
                let gameStartedValue = (message["gamestarted"] as? Bool) ?? true
                print("Game started value: \(gameStartedValue)")
                if gameStartedValue == true {
                    self.state.toggleHome()
                } else if gameStartedValue == false && self.state.home == true {
                    self.state.toggleHome()
                }
            }
        }
    }
    
    // Send Message Methods
    
    func sendMessage(_ message: [String: Any], replyHandler: (([String: Any]) -> Void)? = nil, errorHandler: ((Error) -> Void)? = nil) {
        guard WCSession.default.isReachable else {
            print("Watch session is not reachable")
            return
        }
        
        print("Sending message: \(message)")
        
        if let replyHandler = replyHandler {
            WCSession.default.sendMessage(message, replyHandler: replyHandler) { error in
                print("Error sending message: \(error.localizedDescription)")
                errorHandler?(error)
            }
        } else {
            do {
                try WCSession.default.updateApplicationContext(message)
                print("Message sent successfully via application context")
            } catch {
                print("Error sending application context: \(error.localizedDescription)")
                // Fallback to sendMessage
                WCSession.default.sendMessage(message, replyHandler: nil) { error in
                    print("Error in fallback send: \(error.localizedDescription)")
                }
            }
        }
    }
    
    // Add application context handling
    func session(_ session: WCSession, didReceiveApplicationContext applicationContext: [String : Any]) {
        print("Received application context: \(applicationContext)")
        handleMessage(message: applicationContext)
    }
    
    
    func sendingscoredata() {
        if historyscoredata.count > 0 {
            let message: [String: Any] = ["historyscoredata": historyscoredata]
            WCSession.default.sendMessage(message, replyHandler: nil, errorHandler: nil)
        }
    }
    
    func sendingclipdata() {
        let message: [String: Any] = ["clipdata": "true"]
        WCSession.default.sendMessage(message, replyHandler: nil, errorHandler: nil)
    }
    
    func sendingpointdata() {
        let message: [String: Any] = ["pointdata": "true"]
        WCSession.default.sendMessage(message, replyHandler: nil, errorHandler: nil)
    }
    
    func sendingendgamedata() {
        let message: [String: Any] = ["endgamedata": "true"]
        WCSession.default.sendMessage(message, replyHandler: nil, errorHandler: nil)
    }
}
