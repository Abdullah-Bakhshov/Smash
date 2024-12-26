//
//  MatchHistory.swift
//  Smash
//
//  Created by Abdullah B on 01/11/2024.
//

import SwiftUI

struct MatchHistoryPage: View {
    
    @Bindable var index = Index.shared
    @Bindable var states = ViewingStatesModel.shared
    var historydata = Account()
    @State private var waiter: Bool = false
    
    var body: some View {
        ZStack {
            BackgroundVideoView(login: 3)
                .edgesIgnoringSafeArea(.all)
            ScrollView {
                VStack {
                    Spacer(minLength: 250)
                    Text("Match History")
                        .foregroundColor(.white)
                        .bold()
                        .font(.system(size: 20))
                        .padding()
                    if waiter {
                        // Clean invalid paths before rendering
                        ForEach(historydata.historyarray.indices, id: \.self) { count in
                            let videodata = historydata.historyarray[count]
                            if FileManager.default.fileExists(atPath: videodata.path.path) {
                                HStack {
                                    Button(action: {
                                        index.setter(current: count)
                                        states.WatchHistoryGameToggle()
                                    }) {
                                        VStack(alignment: .leading, spacing: 5) {
                                            Text("Match played at: \(videodata.date)")
                                                .font(.headline)
                                                .foregroundColor(.white)
                                            Text("Duration: \(Int(videodata.duration / 60)) : \(videodata.duration % 60)")
                                                .font(.subheadline)
                                                .foregroundColor(.white.opacity(0.8))
                                        }
                                        .padding()
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .background(Color.white.opacity(0.3))
                                        .cornerRadius(10)
                                        .shadow(color: .black.opacity(0.2), radius: 8, x: 0, y: 4)
                                    }
                                    .opacity(0.8)
                                    .padding(.horizontal)
                                    Spacer()
                                    Button(action: {
                                        deleteVideo(at: count)
                                    }) {
                                        Image(systemName: "trash")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 24, height: 24)
                                            .foregroundColor(.white)
                                            .padding(20)
                                            .background(RoundedRectangle(cornerRadius: 12).fill(Color.red))
                                            .shadow(color: Color.black.opacity(0.2), radius: 6, x: 3, y: 3)
                                    }
                                    .padding(.horizontal)
                                }
                            }
                        }
                    }
                }
            }
        }
        .onAppear {
            waiter = historydata.historycheck()
            cleanInvalidPaths()
        }
    }

    func cleanInvalidPaths() {
        historydata.removeInvalidPaths()
    }
    
    func deleteVideo(at index: Int) {
        historydata.removeVideo(at: index)
    }
    
    func returnpath() -> URL {
        _ = historydata.historycheck()
        return historydata.historyarray[index.idx].path
    }
    
    func returntimearray() -> [Int] {
        _ = historydata.historycheck()
        return historydata.historyarray[index.idx].timearray
    }
}

@Observable
class Index{
    static let shared = Index()
    var idx: Int = 0
    private init() {
    }
    func setter(current: Int){
        idx = current
    }
}



#Preview {
    MatchHistoryPage()
}
