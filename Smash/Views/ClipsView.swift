//  Clips.swift
//  Smash
//
//  Created by Abdullah B on 01/11/2024.
//

import SwiftUI

struct ClipsPage: View {
    @Bindable var states = ViewingStatesModel.shared
    var historydata = Account()
    @State private var waiting: Bool = false
    @State private var clipsURLs: [URL] = []
    @State private var activeVideoViewKeys: Set<Int> = []
    @State private var currentIndex: Int = 0
    @State private var selectedClipURL: URL? = nil
    @State private var showDeleteConfirmation: Bool = false
    @State private var clipToDeleteIndex: Int? = nil
    
    
    
    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(colors: [.blue, .green], startPoint: .top, endPoint: .bottom)
                    .ignoresSafeArea(.all)
                
                Text("Cmon you can't look at this page without any clips 👀")
                    .foregroundStyle(.white)
                    .fontWeight(.bold)
                    .font(.title2)
                    .multilineTextAlignment(.center)
                    .padding()
                
                    Button("clips") {
                        states.AWSClipsToggle()
                    }
                    .foregroundColor(.white)
                    .font(.title2)
                    .bold()
                    .padding()
                    .offset(y: -400)
                    .zIndex(1)

                TabView(selection: $currentIndex) {
                    ForEach(clipsURLs.indices, id: \.self) { index in
                        FullScreenVideoPlayerView(url: clipsURLs[index])
                            .onLongPressGesture {
                                selectedClipURL = clipsURLs[index]
                                clipToDeleteIndex = index
                                showDeleteConfirmation = true
                            }
                            .ignoresSafeArea(.all)
                            .tag(index)
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .ignoresSafeArea(.all)
            }
        }
        .onAppear {
            Task {
                await fetchAWSClipsWithKeys()
            }
        }
        
        .confirmationDialog("Are you sure you want to delete this clip?", isPresented: $showDeleteConfirmation, titleVisibility: .visible) {
            Button("Delete", role: .destructive) {
                deleteClip(at: clipToDeleteIndex)
            }
            Button("Cancel", role: .cancel) {
                showDeleteConfirmation = false
            }
        }
    }
    
    private func deleteClip(at index: Int?) {
        guard let index = index, let selectedURL = selectedClipURL else { return }
        
        Task {
            let success = await S3Requests().deleteFile(from: "smash-personal-clips-bucket", key: selectedURL.lastPathComponent)
            print("Deleting clip:\(selectedURL.lastPathComponent)")
            await ClientForAPI().deletingAccountClips(clipID: selectedURL.lastPathComponent)
            if success {
                clipsURLs.remove(at: index)
                print("Clip deleted successfully")
            } else {
                print("Failed to delete clip")
            }
            showDeleteConfirmation = false
        }
    }
    
    func fetchAWSClipsWithKeys() async -> [URL] {
        let s3Requests = S3Requests()
        let bucketName = "smash-personal-clips-bucket"
        
        do {
            let fileKeys = await ClientForAPI().gettingAccountClips()
            var urls: [URL] = []
            
            for key in fileKeys {
                if let url = await s3Requests.generatePreSignedURL(bucket: bucketName, key: key) {
                    urls.append(url)
                }
            }
            
            self.clipsURLs = urls
            return urls
        }
    }
    
    func fetchAWSClips() async -> [URL] {
        let s3Requests = S3Requests()
        let bucketName = "smash-app-public-clips"
        
        do {
            let fileKeyss = await s3Requests.listFiles(from: bucketName)
            print("filekeys: \(fileKeyss)")
            var urls: [URL] = []
            
            for key in fileKeyss {
                if let url = await s3Requests.generatePreSignedURL(bucket: bucketName, key: key) {
                    urls.append(url)
                }
            }
            
            self.clipsURLs = urls
            print("\(clipsURLs)")
            return urls
        }
    }
    
    
    
}
