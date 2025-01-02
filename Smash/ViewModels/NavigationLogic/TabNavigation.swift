//
//  HomePage.swift
//  SmashWatchOS Watch App
//
//  Created by Abdullah B on 09/11/2024.
//

import SwiftUI

struct HomePage: View {
    @State var selectedTab = 1
    var clipspage = ClipsPage()
    @State private var isSheetPresented = false
    
    var body: some View {
        ZStack {
            switch selectedTab {
            case 0:
                MatchHistoryPage()
                    .transition(.asymmetric(insertion: .opacity, removal: .opacity))
                    .blur(radius: selectedTab == 0 ? 0 : 10)
            case 1:
                StartSessionPage(isSheetPresented: $isSheetPresented)
                    .transition(.asymmetric(insertion: .opacity, removal: .opacity))
                    .blur(radius: selectedTab == 1 ? 0 : 10)
            case 2:
                clipspage
                    .transition(.asymmetric(insertion: .opacity, removal: .opacity))
                    .blur(radius: selectedTab == 2 ? 0 : 10)
            default:
                MatchHistoryPage()
                    .transition(.asymmetric(insertion: .opacity, removal: .opacity))
                    .blur(radius: 0)
            }
            overlayTabButtons
        }
        .animation(.easeInOut(duration: 0.1), value: selectedTab)
        .gesture(
            DragGesture()
                .onEnded { value in
                    handleSwipeGesture(value)
                }
        )
        .sheet(isPresented: $isSheetPresented) {
            FriendsSearchSheet(isSheetPresented: $isSheetPresented)
                .presentationDetents([.medium, .large])
                .presentationDragIndicator(.visible)
        }
    }
    
    private var overlayTabButtons: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                Button(action: {
                    changeTab(to: 0)
                }) {
                    Text("🏛️")
                        .padding()
                        .foregroundColor(selectedTab == 0 ? .blue : .gray)
                }
                Spacer()
                Button(action: {
                    changeTab(to: 1)
                }) {
                    Text("🏸")
                        .padding()
                        .foregroundColor(selectedTab == 1 ? .blue : .gray)
                }
                Spacer()
                Button(action: {
                    changeTab(to: 2)
                }) {
                    Text("📸")
                        .padding()
                        .foregroundColor(selectedTab == 2 ? .blue : .gray)
                }
                Spacer()
            }
        }
    }
    
    private func changeTab(to index: Int) {
        selectedTab = index
    }
    
    private func handleSwipeGesture(_ value: DragGesture.Value) {
        let horizontalThreshold: CGFloat = 30
        let verticalThreshold: CGFloat = 50
        
        if abs(value.translation.width) > abs(value.translation.height) {
            if value.translation.width < -horizontalThreshold {
                if selectedTab < 2 {
                    changeTab(to: selectedTab + 1)
                }
            } else if value.translation.width > horizontalThreshold {
                if selectedTab > 0 {
                    changeTab(to: selectedTab - 1)
                }
            }
        } else if value.translation.height < -verticalThreshold {
            isSheetPresented = true
        }
    }
}
