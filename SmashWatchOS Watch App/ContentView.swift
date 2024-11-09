import SwiftUI

struct ContentView: View {
    
    @State private var yourscore = 0
    @State private var opponentscore = 0
    @State private var angle = -120.0
    @State private var isAnimating = false
    @State private var opac: Double = 4
    @State private var opac2: Double = 0.0
    @State private var wavegone = false
    @State private var textOffset: CGFloat = 0
    @State private var textscore: Bool = false
    @State private var lostpoint: Bool = false
    @State private var wonpoint: Bool = false
    @State private var recordedpoint: Bool = false
    @State private var recordedtext = 15
    @State private var winsize = 15
    @State private var lossesize = 15
    @State private var backgroundcolor = ["0D00A4","44FFD2"]
    

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
                .onAppear {
                    startWaveAnimation()
                    }
            if yourscore != 21 && opponentscore != 21 {
                if wavegone {
                    NavigationStack{
                        Text( textscore ? "\(yourscore) : \(opponentscore)" : "Good Luck 🫡")
                            .font(.system(size: 20))
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .opacity(opac2)
                            .offset(y: textOffset)
                            .onAppear {
                                withAnimation(.spring(duration: 0.7)) {
                                    opac2 = 1.0
                                    textOffset = -10
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0){
                                        withAnimation(.snappy) {
                                            textscore = true
                                        }
                                    }
                                }
                            }
                        Button(wonpoint ? "🎉" : "Point Won!"){
                            yourscore += 1
                            winsize = 70
                            wonpoint = true
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0){
                                withAnimation(.snappy) {
                                    wonpoint = false
                                    winsize = 15
                                }
                            }
                        }
                        .font(.system(size: CGFloat(winsize)))
                        .onAppear {
                            withAnimation(.spring(duration: 0.7)) {
                                opac2 = 1.0
                            }
                        }
                        Button(lostpoint ? "😔" : "Point Lost!"){
                            opponentscore += 1
                            lossesize = 70
                            lostpoint = true
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0){
                                withAnimation(.snappy) {
                                    lostpoint = false
                                    lossesize = 15
                                }
                            }
                        }
                        .font(.system(size: CGFloat(lossesize)))
                        .onAppear {
                            withAnimation(.spring(duration: 0.7)) {
                                opac2 = 1.0
                            }
                        }
                        Button(recordedpoint ? "🤳" : "Clip Last Point!"){
                            recordedtext = 70
                            recordedpoint = true
                            let temp = backgroundcolor
                            backgroundcolor = ["CE1483","129490"]
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0){
                                withAnimation(.snappy) {
                                    recordedpoint = false
                                    recordedtext = 15
                                    backgroundcolor = temp
                                }
                            }
                        }
                        .font(.system(size: CGFloat(recordedtext)))
                        .onAppear {
                            withAnimation(.spring(duration: 0.7)) {
                                opac2 = 1.0
                            }
                        }
                    }
                }
            }
            else if yourscore == 21 {
                //ill make a cheacky stack and do it that way
                LinearGradient(
                    gradient: Gradient(colors: [Color(hex: "A14DA0"), Color(hex: "DE0D92")]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                NavigationStack{
                    Text("Insane!")
                        .font(.system(size: 40))
                        .foregroundColor(.white)
                        .fontWeight(.bold)
                        .padding()
                }
            } else {
                LinearGradient(
                    gradient: Gradient(colors: [Color(hex: "9E1946"), Color(hex: "710627")]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                NavigationStack{
                    Text("Unlucky!")
                        .font(.system(size: 40))
                        .foregroundColor(.white)
                        .fontWeight(.bold)
                        .padding()
                }
            }
        }.frame(width: 300, height: 300)
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
