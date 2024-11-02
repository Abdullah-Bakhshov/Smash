//
//  Clips.swift
//  Smash
//
//  Created by Abdullah B on 01/11/2024.
//

import SwiftUI

struct ClipsPage: View {
    var body: some View {
        VStack{
            Text("clips page")
                .foregroundColor(.white)
                .font(.largeTitle)
                .bold()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(LinearGradient(colors: [.blue, .green], startPoint: .top, endPoint: .bottom), ignoresSafeAreaEdges: .all)
    }
}

#Preview {
    ClipsPage()
}
