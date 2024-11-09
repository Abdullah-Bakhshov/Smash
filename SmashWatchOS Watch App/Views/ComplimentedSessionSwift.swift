import SwiftUI

struct ContentView: View {
    
    @State private var yourscore = 0
    @State private var opponentscore = 0
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
    @State var pointshistory : [[Int]] = [[0,0]]
    @State var winningorlosingsize = 30
    @State var emojisize = 0
    
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
                .onAppear { startWaveAnimation() }

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
                        .shadow(radius: 10)
                        .font(.system(size: CGFloat(winsize)))
                        Button(lostpoint ? "😔" : "Point Lost!") {
                            withAnimation {
                                opponentscore += 1
                                pointshistory.append([yourscore, opponentscore])
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
                        .shadow(radius: 10)
                        .font(.system(size: CGFloat(lossesize)))
                        Button(recordedpoint ? "🤳" : "Clip Last Point!") {
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
                    }
                    .opacity(opac3)
                }
            }
            else {
                NavigationStack {
                    Text(yourscore == 21 ? "Insane" : "Unlucky")
                        .font(.system(size: CGFloat(winningorlosingsize) ))
                        .foregroundColor(.white)
                        .fontWeight(.bold)
                        .padding()
                        .opacity(opac4)
                        .offset(y: winningorlosingtransformation + 10)
                    
                    Text(yourscore == 21 ? "🎉" : "🫣")
                        .font(.system(size: CGFloat(emojisize)))
                        .foregroundColor(.white)
                        .fontWeight(.bold)
                        .padding()
                        .opacity(opac4 + 30)
                        .offset(y: winningorlosingtransformation)
                
                }
                .onAppear {
                    withAnimation(.spring(duration: 0.7)) {
                        backgroundcolor = yourscore == 21 ? ["ECF39E", "4F772D"] : ["FDF0D5", "C1121F"]
                        opac4 = 1.0
                        winningorlosingtransformation = -20
                        winningorlosingsize = 40
                        emojisize = 60
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
}

#Preview {
    ContentView()
}
