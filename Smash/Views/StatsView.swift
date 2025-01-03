//
//  SwiftUIView.swift
//  Smash
//
//  Created by Abdullah B on 03/01/2025.
//

import SwiftUI

struct StatsView: View {
    
    @Bindable var states = ViewingStatesModel.shared
    @State private var opac: Double = 4
    @State private var opac1: Double = 2
    @State private var opac2: Double = 2
    @State private var angle = -120.0
    @State private var isAnimating = false
    @State private var wavegone = false
    @State private var showRectangles = false
    @State private var rectanglesVisible = [Bool](repeating: false, count: 5)
    @State private var rectangleTexts = [
        ("loading...", "Total hours played"),
        ("loading...", "Games won"),
        ("loading...", "Longest rally"),
        ("loading...", "Average match score"),
        ("loading...", "Average session")
    ]
    
    
    var body: some View {
        ZStack {
            LinearGradient(colors: [.blue, .cyan], startPoint: .bottom, endPoint: .top)
                .ignoresSafeArea(.all)
            
            VStack {
                Text("Hey, here's your summary for today 😁")
                    .foregroundColor(.white)
                    .font(.title)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                    .padding()
                    .opacity(opac1)
                    .onAppear {
                        withAnimation(.easeIn(duration: 2.5)) {
                            opac1 = 1.0
                        }
                    }
                
                Spacer()
            }
            
            if showRectangles {
                Button("🤞") {
                    states.StatsToggle()
                }
                .font(.system(size: 30))
                .clipShape(Circle())
                .frame(width: 50, height: 50)
                .opacity(opac2)
                .offset(x: -150, y: -360)
                .shadow(color: .black.opacity(0.5), radius: 5, x: 0, y: 10)
                .onAppear {
                    withAnimation(.easeIn(duration: 2.5)) {
                        opac2 = 1.0
                    }
                }
                
                VStack(spacing: 20) {
                    ForEach(0..<rectanglesVisible.count, id: \.self) { index in
                        createRectangle(for: index)
                            .onAppear {
                                DispatchQueue.main.asyncAfter(deadline: .now() + Double(index) * 0.3) {
                                    rectanglesVisible[index] = true
                                }
                            }
                    }
                }
            }
            
            Text("👋")
                .font(.system(size: 200))
                .rotationEffect(.degrees(angle), anchor: .bottomTrailing)
                .shadow(color: .black.opacity(0.3), radius: 10, x: 0, y: 10)
                .opacity(opac)
                .onAppear {
                    startWaveAnimation()
                    resetvariables()
                }
        }
        .onAppear{
            Task {
                let temp = await ClientForAPI().getUserStats()
                for (index, result) in temp.enumerated() {
                    rectangleTexts[index].0 = result
                }
            }
        }
    }
    
    private func createRectangle(for index: Int) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.white.opacity(0.4))
                .frame(width: 350, height: 110)
                .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 5)
            
            HStack {
                VStack(alignment: .leading) {
                    Text(rectangleTexts[index].1)
                        .font(.footnote)
                        .foregroundColor(.white)
                        .padding(.horizontal, 40)
                    Text(rectangleTexts[index].0)
                        .bold()
                        .font(.title2)
                        .foregroundColor(.white)
                        .padding(.horizontal, 50)
                    
                }
                Spacer()
            }
            .padding()
        }
        .opacity(rectanglesVisible[index] ? 1.0 : 0.0)
        .animation(.easeInOut(duration: 0.5).delay(Double(index) * 0.1), value: rectanglesVisible[index])
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
                opac1 -= 0.02
                if opac1 <= 0 {
                    timer.invalidate()
                    wavegone = true
                    opac = 0
                    opac1 = 0
                    fadeInRectangles()
                }
            }
        }
    }
    
    func fadeInRectangles() {
        showRectangles = true
        for index in rectanglesVisible.indices {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(index) * 0.5) {
                rectanglesVisible[index] = true
            }
        }
    }
    
    func resetvariables() {
        angle = -120.0
        isAnimating = false
        opac = 4
        wavegone = false
        showRectangles = false
        rectanglesVisible = [Bool](repeating: false, count: rectanglesVisible.count)
    }
}

#Preview {
    StatsView()
}
