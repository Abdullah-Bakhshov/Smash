//
//  StartSession.swift
//  Smash
//
//  Created by Abdullah B on 01/11/2024.
//

import SwiftUI


struct StartSessionPage: View {
    
    @EnvironmentObject var viewingStatesModel: ViewingStatesModel
    
    var body: some View {
        ZStack{
            BackgroundVideoView(login: 2)
                .edgesIgnoringSafeArea(.all)
            VStack{
                    Button("🐼"){
                        viewingStatesModel.states.startsessiontoaccount = true
                    }
                    .font(.system(size:30))
                    .clipShape(Circle())
                    .frame(width: 50, height: 50)
                    .offset(x:150,y:-350)
                    .shadow(color: .black, radius: 5, x: 0, y: 10)
                    
                    Text("Home")
                        .bold()
                        .font(.system(size:20))
                        .foregroundColor(.white)
                    
                    Button("Start a Session") {
            
                    }.foregroundColor(.white)
            }
        }
    }
}


#Preview {
    StartSessionPage()
}
