import SwiftUI

struct HomePage: View {
    @State private var selectedTab = 1
    var body: some View {
        ZStack {
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
                ClipsPage()
                    .transition(.asymmetric(insertion: .opacity, removal: .opacity))
                    .blur(radius: selectedTab == 2 ? 0 : 10)
            default:
                MatchHistoryPage()
                    .transition(.asymmetric(insertion: .opacity, removal: .opacity))
                    .blur(radius: 0)
            }
        }
        .animation(.easeInOut(duration: 0.1), value: selectedTab)
        .gesture(DragGesture()
            .onEnded { value in
                let threshold: CGFloat = 50
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
        .overlay(
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
        )
    }

    private func changeTab(to index: Int) {
        selectedTab = index
    }
}

// Preview setup
struct HomePage_Previews: PreviewProvider {
    static var previews: some View {
        HomePage()
    }
}
