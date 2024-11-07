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
    @State private var waiter : Bool = false

    
    var body: some View {
        ZStack{
            BackgroundVideoView(login: 3)
                .edgesIgnoringSafeArea(.all)
            Spacer(minLength: 100)
            ScrollView{
                VStack{
                    Text("Match History")
                        .foregroundColor(.white)
                        .bold()
                        .font(.system(size:20))
                    if waiter{
                        ForEach(historydata.historyarray.indices, id: \.self) { count in
                            let videodata = historydata.historyarray[count]
                            Button(action: {
                                index.setter(current: count)
                                states.WatchHistoryGameToggle()
                            }) {
                                VStack(alignment: .leading, spacing: 5) {
                                    Text("Match played at: \(videodata.date)")
                                        .font(.headline)
                                        .foregroundColor(.white)
                                    Text("Duration: \(videodata.duration)")
                                        .font(.subheadline)
                                        .foregroundColor(.white.opacity(0.8))
                                }
                                .padding()
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .background(Color.white.opacity(0.8))
                                .cornerRadius(10)
                                .shadow(color: .black.opacity(0.2), radius: 8, x: 0, y: 4)
                            }
                            .opacity(0.9)
                            .padding(.horizontal)
                        }
                    }
                }
            }
        }
        .onAppear{
            waiter = historydata.historycheck() // this is accessed
        }
    }
    
    func returnpath()->URL{
        let h = historydata.historycheck()
        return historydata.historyarray[index.idx].path
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
//    MatchHistoryPage()
}
