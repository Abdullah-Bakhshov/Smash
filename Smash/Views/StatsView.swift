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
    @State private var messageOpacity: Double = 2
    @State private var headerOpacity: Double = 0
    @State private var angle = -120.0
    @State private var isAnimating = false
    @State private var showStats = false
    @State private var statsOpacity = [Bool](repeating: false, count: 5)
    @State private var statsData = [
        ("loading...", "Total hours played", "clock.fill"),
        ("loading...", "Games won", "trophy.fill"),
        ("loading...", "Longest rally", "flame.fill"),
        ("loading...", "Average match score", "chart.bar.fill"),
        ("loading...", "Average session", "timer.square")
    ]
    
    private let gradient = LinearGradient(
        colors: [.blue, .cyan],
        startPoint: .bottom,
        endPoint: .top
    )
    
    var body: some View {
        ZStack {
            gradient
                .ignoresSafeArea()
            
            VStack(spacing: 30) {
                if showStats {
                    HStack {
                        Button(action: { states.StatsToggle() }) {
                            Image(systemName: "chevron.left")
                                .font(.system(size: 24, weight: .semibold))
                                .foregroundColor(.white)
                                .padding(12)
                                .background(Color.white.opacity(0.2))
                                .clipShape(Circle())
                        }
                        Spacer()
                    }
                    .padding(.horizontal)
                    .padding(.top, 60)
                    .opacity(headerOpacity)
                    
                    Text("Your Stats")
                        .font(.system(size: 28, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                        .opacity(headerOpacity)
                    
                    statsSection
                }
                Spacer()
            }
            
            if !showStats {
                VStack() {
                    Text("Hey, This is how you're doing so far!")
                        .font(.system(size: 28, weight: .bold, design: .rounded))
                        .multilineTextAlignment(.center)
                        .foregroundColor(.white)
                        .padding(.horizontal)
                        .opacity(messageOpacity)
                        .padding()
                                        
                    Text("👋")
                        .font(.system(size: 200))
                        .rotationEffect(.degrees(angle), anchor: .bottomTrailing)
                        .shadow(color: .black.opacity(0.3), radius: 10, x: 0, y: 10)
                        .opacity(opac)
                    

                }
            }
        }
        .onAppear {
            startWaveAnimation()
            fetchStats()
        }
    }
    
    private var statsSection: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 20) {
                ForEach(0..<statsData.count, id: \.self) { index in
                    StatCard(
                        icon: statsData[index].2,
                        title: statsData[index].1,
                        value: statsData[index].0
                    )
                    .opacity(statsOpacity[index] ? 1 : 0)
                    .offset(y: statsOpacity[index] ? 0 : 50)
                }
            }
            .padding(.horizontal)
        }
    }
    
    private func startWaveAnimation() {
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
                messageOpacity -= 0.02
                if messageOpacity <= 0 {
                    timer.invalidate()
                    showStats = true
                    withAnimation(.easeIn(duration: 0.5)) {
                        headerOpacity = 1
                    }
                    animateStatsIn()
                }
            }
        }
    }
    
    private func animateStatsIn() {
        for index in statsOpacity.indices {
            withAnimation(.spring(duration: 0.6).delay(Double(index) * 0.1)) {
                statsOpacity[index] = true
            }
        }
    }
    
    private func fetchStats() {
        Task {
            let stats = await ClientForAPI().getUserStats()
            for (index, stat) in stats.enumerated() {
                statsData[index].0 = stat
            }
        }
    }
}

struct StatCard: View {
    let icon: String
    let title: String
    let value: String
    
    var body: some View {
        HStack(spacing: 20) {
            Image(systemName: icon)
                .font(.system(size: 24))
                .foregroundColor(.white)
                .frame(width: 50, height: 50)
                .background(Color.white.opacity(0.2))
                .clipShape(Circle())
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.white.opacity(0.8))
                Text(value)
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(.white)
            }
            Spacer()
        }
        .padding()
        .background(Color.white.opacity(0.15))
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color.white.opacity(0.1), lineWidth: 1)
        )
    }
}
