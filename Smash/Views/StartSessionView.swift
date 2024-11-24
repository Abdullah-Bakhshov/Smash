//
//  StartSession.swift
//  Smash
//
//  Created by Abdullah B on 06/11/2024.
//

import SwiftUI
import Aespa

struct VideoSystem: View {
    
    private var viewModel = VideoContentViewModel.shared
    private var permissionManager = PermissionManager()
    @Bindable var states = ViewingStatesModel.shared
    @Bindable var pointstimer = CustomTimer.shared
    @Bindable var sendtowatch = WatchSingleton.shared
    
    var body: some View {
        ZStack {
            viewModel.preview
                .frame(minWidth: 0,
                       maxWidth: .infinity,
                       minHeight: 0,
                       maxHeight: .infinity)
                .edgesIgnoringSafeArea(.all)
            Text("\(Int(pointstimer.clock / 60)) : \(pointstimer.clock % 60)")
                .offset(x:150,y:-350)
            
            
            Button(action: {
                buttonaction()
            } ) {
                Image(systemName: viewModel.start ? "stop.circle" : "record.circle")
                    .resizable()
                    .frame(width: 60, height: 60)
                    .foregroundColor(viewModel.start ? .red : .white)
            }
            .background(Color.clear)
            .clipShape(Circle())
            .contentShape(Circle())
            .offset(x: 0, y: 340)
            HStack(alignment: .bottom, spacing: 150){
                Button(viewModel.start ? "Point" : ""){
                    pointstimer.recordpoint = true
                }
                .font(.system(size:30))
                .foregroundColor(.white)
                .bold()
                
                Button(viewModel.start ? "Clip" : ""){
                    pointstimer.highlightclip()
                }
                .font(.system(size:30))
                .foregroundColor(.white)
                .bold()
            }
            .offset(x: -7, y: 340)
            Button("🤞") {
                states.StartingGameToggle()
            }
            .font(.system(size:30))
            .clipShape(Circle())
            .frame(width: 50, height: 50)
            .offset(x:-150,y:-350)
            .shadow(color: .black, radius: 5, x: 0, y: 10)
        }
        .ignoresSafeArea(.all)
    }
    
    func buttonaction(){
        viewModel.start.toggle()
        if viewModel.start {
            pointstimer.starttimer()
            sendtowatch.returnsendtowatch()
        }
        viewModel.StartandStopRecording()
        // This can cause errors if it takes longer to append a video to the array
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            if !viewModel.start {
                pointstimer.endtimer()
                states.PreviewingGameToggle()
            }
        }
    }
}


#Preview {
    VideoSystem()
}
