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
    
    var body: some View {
        ZStack {
            // The view changes based on the selected tab
            switch selectedTab {
            case 0:
                MatchHistoryPage()
                    .transition(.asymmetric(insertion: .opacity, removal: .opacity))
                    .blur(radius: selectedTab == 0 ? 0 : 10) // No blur when selected
            case 1:
                StartSessionPage()
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
            
            // Hide tab view and buttons when on Clips page (selectedTab == 2)
            if selectedTab != 2 {
                overlayTabButtons
            }
        }
        .animation(.easeInOut(duration: 0.1), value: selectedTab)
        .gesture(DragGesture()
            .onEnded { value in
                let threshold: CGFloat = 30
                if value.translation.width < -threshold {
                    if selectedTab < 2 {
                        changeTab(to: selectedTab + 1)
                    }
                } else if value.translation.width > threshold {
                    if selectedTab > 0 {
                        changeTab(to: selectedTab - 1)
                    }
                }
            }
        )
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
}

struct HomePage_Previews: PreviewProvider {
    static var previews: some View {
        HomePage()
    }
}


