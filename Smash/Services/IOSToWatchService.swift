//
//  WatchHomeScreen.swift
//  IOSToWatchService Watch App
//
//  Created by Abdullah B on 09/11/2024.
//


import UIKit
import WatchConnectivity
import Foundation

class ViewController: UIViewController {
    
    private var pointstimer = CustomTimer.shared
    private var viewModel = VideoContentViewModel.shared
    private var isSessionActivated = false
    private lazy var session: WCSession = {
        let session = WCSession.default
        session.delegate = self
        return session
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activateSession()
    }
    
    private func activateSession() {
        guard WCSession.isSupported() else {
            print("Watch session not supported on this device")
            return
        }
        print("Activating watch session...")
        session.activate()
    }
    
    func checkAndSendGameState() {
        activateSession()
        print("Checking game state to send...")
        print("Start value is: \(viewModel.start)")
        guard isSessionActivated, session.isReachable else {
            print("Session not ready. Activated: \(isSessionActivated), Reachable: \(session.isReachable)")
            return
        }
        
        if viewModel.start {
            sendGameStartedMessage()
        } else {
            sendGameEndedMessage()
        }
    }
    private func sendGameEndedMessage() {
        print("Attempting to send game ended message")
        let message = ["gamestarted": "false"]
        session.sendMessage(message,
                            replyHandler: { response in
            DispatchQueue.main.async {
                print("Successfully sent message to watch")
                print("Watch response: \(response)");
            }
        })
    }
    
    private func sendGameStartedMessage() {
        print("Attempting to send game started message")
        let message = ["gamestarted": "true"]
        session.sendMessage(message,
                            replyHandler: { response in
            DispatchQueue.main.async {
                print("Successfully sent message to watch")
                print("Watch response: \(response)")
            }
        },
                            errorHandler: { error in
            DispatchQueue.main.async {
                print("Failed to send message: \(error.localizedDescription)")
                self.sendBackupMessage()
            }
        }
        )
    }
    
    private func sendBackupMessage() {
        print("Attempting backup sending method...")
        let userInfo = ["gamestarted": "true"]
        do {
            try session.updateApplicationContext(userInfo)
            print("Application context updated successfully")
        } catch {
            print("Failed to update application context: \(error.localizedDescription)")
        }
    }
}

extension ViewController: WCSessionDelegate {
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        DispatchQueue.main.async {
            if let error = error {
                print("Session activation failed: \(error.localizedDescription)")
                self.isSessionActivated = false
                return
            }
            
            switch activationState {
            case .activated:
                print("Watch session fully activated!")
                self.isSessionActivated = true
                print("Session is reachable: \(session.isReachable)")
                print("Watch app is installed: \(session.isWatchAppInstalled)")
                print("iPhone is paired with watch: \(session.isPaired)")
                
                self.checkAndSendGameState()
                
            case .inactive:
                print("Watch session is inactive")
                self.isSessionActivated = false
                
            case .notActivated:
                print("Watch session is not activated")
                self.isSessionActivated = false
                
            @unknown default:
                print("Unknown activation state")
                self.isSessionActivated = false
            }
        }
    }
    
    func sessionDidBecomeInactive(_ session: WCSession) {
        DispatchQueue.main.async {
            print("Session became inactive")
            self.isSessionActivated = false
        }
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
        DispatchQueue.main.async {
            print("Session deactivated - reactivating...")
            self.isSessionActivated = false
            self.activateSession()
        }
    }
    
    
    
//    //WCSessionDelegate Methods
//    
//    // Handle messages that require a reply
//    func session(_ session: WCSession, didReceiveMessage message: [String: Any], replyHandler: @escaping ([String: Any]) -> Void) {
//        print("Received message with reply handler: \(message)")
//        handleMessage(message: message)
//        replyHandler(["status": "received"])
//    }
//    
//    // Handle messages that don't require a reply
//    func session(_ session: WCSession, didReceiveMessage message: [String: Any]) {
//        print("Received message without reply handler: \(message)")
//        handleMessage(message: message)
//    }
//    
//    private func handleMessage(message: [String: Any]) {
//        print("Processing message: \(message)")
//        DispatchQueue.main.async {
//            if let messageType = message["type"] as? String {
//                switch messageType {
//                case "historyscoredata":
//                    let historyScoreData: [[Int]] = (message["historyscoredata"] as? [[Int]]) ?? [[Int]]()
//                    print("History Score Data: \(historyScoreData)")
//                case "clipdata":
//                    self.pointstimer.highlightclip()
//                case "pointdata":
//                    self.pointstimer.recordpoint = true
//                default:
//                    print("Unknown message type")
//                }
//            } else {
//                print("Message type is missing or invalid")
//            }
//        }
//    }
}

