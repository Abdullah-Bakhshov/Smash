//
//  WatchHomeScreen.swift
//  SmashWatchOS Watch App
//
//  Created by Abdullah B on 09/11/2024.
//

import SwiftUI
import AnimateText

struct WatchSession: View {
    
    @State var type: ATUnitType = .letters
    @State private var endgametext: String = ""
    
    @State private var yourscore = 0
    @State private var opponentscore = 0
    @State var pointshistory : [[Int]] = [[0,0]]
    
    @State private var angle = -120.0
    @State private var isAnimating = false
    @State private var opac: Double = 4
    @State private var opac2: Double = 0.0
    @State private var opac3: Double = 2.0
    @State private var opac4: Double = 0.0
    @State private var wavegone = false
    @State private var textOffset: CGFloat = 0
    @State private var winningorlosingtransformation: CGFloat = 0
    @State private var textscore: Bool = false
    @State private var lostpoint: Bool = false
    @State private var wonpoint: Bool = false
    @State private var recordedpoint: Bool = false
    @State private var recordedtext = 15
    @State private var winsize = 15
    @State private var lossesize = 15
    @State private var backgroundcolor = ["0D00A4","44FFD2"]
    @State private var winningorlosingsize = 30
    @State private var emojisize = 0
    
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [Color(hex: backgroundcolor[0]), Color(hex: backgroundcolor[1])]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            Text("👋")
                .font(.system(size: 120))
                .rotationEffect(.degrees(angle), anchor: .bottomTrailing)
                .opacity(opac)
                .onAppear { startWaveAnimation()
                    resetvariables()
                }
            if yourscore != 21 && opponentscore != 21 {
                if wavegone {
                    VStack() {
                        Text(textscore ? "\(yourscore) : \(opponentscore)" : "Good Luck 🫡")
                            .shadow(radius: 10)
                            .font(.system(size: 20))
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .opacity(opac2)
                            .offset(y: textOffset)
                            .onAppear {
                                withAnimation(.spring(duration: 0.7)) {
                                    opac2 = 1.0
                                    textOffset = -10
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                                        withAnimation(.easeInOut) { textscore = true }
                                    }
                                }
                            }
                        Button(wonpoint ? "🎉" : "Point Won!") {
                            withAnimation {
                                yourscore += 1
                                pointshistory.append([yourscore, opponentscore])
                                SessionManager.shared.sendingpointdata()
                                winsize = 70
                                wonpoint = true
                                let temp = backgroundcolor
                                backgroundcolor = ["95F9E3","416165"]
                                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                                    withAnimation {
                                        wonpoint = false
                                        winsize = 15
                                        backgroundcolor = temp
                                    }
                                }
                            }
                        }
                        .sensoryFeedback(.impact(flexibility: .solid, intensity: .greatestFiniteMagnitude), trigger: yourscore)
                        .shadow(radius: 10)
                        .font(.system(size: CGFloat(winsize)))
                        Button(lostpoint ? "😔" : "Point Lost!") {
                            withAnimation {
                                opponentscore += 1
                                pointshistory.append([yourscore, opponentscore])
                                SessionManager.shared.sendingpointdata()
                                lossesize = 70
                                lostpoint = true
                                let temp = backgroundcolor
                                backgroundcolor = ["F9DBBD","DA627D"]
                                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                                    withAnimation {
                                        lostpoint = false
                                        lossesize = 15
                                        backgroundcolor = temp
                                    }
                                }
                            }
                        }
                        .sensoryFeedback(.impact(flexibility: .solid, intensity: .greatestFiniteMagnitude), trigger: opponentscore)
                        .shadow(radius: 10)
                        .font(.system(size: CGFloat(lossesize)))
                        Button(recordedpoint ? "🤳" : "Clip Last Point!") {
                            SessionManager.shared.sendingclipdata()
                            withAnimation {
                                recordedtext = 70
                                recordedpoint = true
                                let temp = backgroundcolor
                                backgroundcolor = ["129490","CE1483"]
                                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                                    withAnimation {
                                        recordedpoint = false
                                        recordedtext = 15
                                        backgroundcolor = temp
                                    }
                                }
                            }
                        }
                        .shadow(radius: 10)
                        .font(.system(size: CGFloat(recordedtext)))
                        .sensoryFeedback(.impact(flexibility: .solid, intensity: .greatestFiniteMagnitude), trigger: recordedpoint)
                        
                    }
                    .opacity(opac3)
                }
            }
            else {
                AnimateText<ATOffsetEffect>($endgametext, type: type, userInfo: nil)
                    .font(.system(size: CGFloat(winningorlosingsize) ))
                    .foregroundColor(.white)
                    .fontWeight(.bold)
                    .padding()
                    .opacity(opac4)
                    .offset(y: winningorlosingtransformation - 70)
                    .sensoryFeedback(.impact(flexibility: .solid, intensity: .greatestFiniteMagnitude), trigger: yourscore == 21 || opponentscore == 21)
                
                Text(yourscore == 21 ? "🎉" : "🫣")
                    .font(.system(size: CGFloat(emojisize)))
                    .foregroundColor(.white)
                    .fontWeight(.bold)
                    .padding()
                    .opacity(opac4 + 30)
                    .offset(y: winningorlosingtransformation)
                    .onAppear {
                        withAnimation(.spring(duration: 0.7)) {
                            backgroundcolor = yourscore == 21 ? ["ECF39E", "4F772D"] : ["FDF0D5", "C1121F"]
                            opac4 = 1.0
                            winningorlosingtransformation = 20
                            winningorlosingsize = 40
                            emojisize = 60
                            endgametext = yourscore == 21 ? "Insane" : "Unlucky"
                            SessionManager.shared.historyscoredata = pointshistory
                            SessionManager.shared.sendingscoredata()
                        }
                    }
            }
        }
        .frame(width: 300, height: 300)
    }
    
    func startWaveAnimation() {
        withAnimation(
            Animation.easeInOut(duration: 2)
                .repeatForever(autoreverses: true)
        ) {
            isAnimating.toggle()
        }
        Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true) { timer in
            let time = Date().timeIntervalSinceReferenceDate
            angle = 15 * sin(time * 8)
            if opac > 0 {
                opac -= 0.02
            } else {
                timer.invalidate()
                wavegone = true
                opac = 0
            }
        }
    }
    
    
    func resetvariables() {
        type = .letters
        endgametext = ""
        yourscore = 0
        opponentscore = 0
        pointshistory = [[0,0]]
        angle = -120.0
        isAnimating = false
        opac = 4
        opac2 = 0.0
        opac3 = 2.0
        opac4 = 0.0
        wavegone = false
        textOffset = 0
        winningorlosingtransformation = 0
        textscore = false
        lostpoint = false
        wonpoint = false
        recordedpoint = false
        recordedtext = 15
        winsize = 15
        lossesize = 15
        backgroundcolor = ["0D00A4","44FFD2"]
        winningorlosingsize = 30
        emojisize = 0
    }
}


#Preview {
    WatchSession()
}
