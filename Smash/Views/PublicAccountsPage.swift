//
//  SwiftUIView.swift
//  Smash
//
//  Created by Abdullah B on 02/01/2025.
//

import SwiftUI
import AVKit

struct PublicAccountsPage: View {
    let publicAccountsUsername: String
    @State var clips: [URL] = []
    @State private var profileImage: UIImage? = nil
    @State private var bio: String = "Skibidi"
    @State private var clicked: Bool = false
    @State private var showprofile: Bool = false

    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(gradient: Gradient(colors: [Color.yellow.opacity(1), Color.red.opacity(1)]),
                               startPoint: .topLeading,
                               endPoint: .bottomTrailing)
                .edgesIgnoringSafeArea(.all)
                VStack {
                    HStack {
                        if let profileImage = profileImage {
                            Image(uiImage: profileImage)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 100, height: 100)
                                .clipShape(Circle())
                                .overlay(Circle().stroke(Color.white, lineWidth: 4))
                                .shadow(radius: 10)
                        } else {
                            Circle()
                                .fill(Color.white.opacity(0.3))
                                .frame(width: 80, height: 80)
                                .overlay(
                                    Text(publicAccountsUsername.prefix(1))
                                        .font(.largeTitle)
                                        .foregroundColor(.white)
                                )
                                .shadow(radius: 10)
                        }
                        VStack(alignment: .leading) {
                            Text(publicAccountsUsername)
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                            Text(bio)
                                .font(.subheadline)
                                .foregroundColor(.white)
                                .lineLimit(2)
                                .truncationMode(.tail)
                        }
                        .padding(.leading, 10)
                    }
                    .padding()
                    Button(action: {
                        Task {
                            await ClientForAPI().unfollowingAccount(username: publicAccountsUsername)
                            clicked = true
                        }
                    }) {
                        Text( clicked ? "unfollowed" : "following")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: 110, maxHeight: 30)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color.white.opacity(0.5))
                                    .shadow(radius: 5)
                            )
                            .padding(.horizontal)
                    }
                    if showprofile {
                        ScrollView {
                            LazyVGrid(columns: [GridItem(.adaptive(minimum: 150))], spacing: 16) {
                                ForEach(clips, id: \.self) { clip in
                                    NavigationLink(
                                        destination: FullScreenVideoPlayerView(url: clip),
                                        label: {
                                            ClipView(clipURL: clip)
                                        }
                                    )
                                }
                            }
                            .padding()
                        }
                    } else {
                        Text("This profile is private")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .padding()
                    }
                }
                .onAppear {
                    Task {
                        clips = await ClipsPage().fetchAWSClipsWithKeys(username: publicAccountsUsername)
                        showprofile = await ClientForAPI().checkingIfProfilePublic(username: publicAccountsUsername)
                    }
                }
            }
        }
    }
}

struct ClipView: View {
    let clipURL: URL
    @State private var thumbnailImage: UIImage? = nil

    var body: some View {
        VStack {
            if let thumbnail = thumbnailImage {
                Image(uiImage: thumbnail)
                    .resizable()
                    .scaledToFill()
                    .frame(height: 200)
                    .clipped()
                    .cornerRadius(10)
            } else {
                Rectangle()
                    .fill(Color.gray.opacity(0.3))
                    .frame(height: 200)
                    .cornerRadius(10)
                    .onAppear {
                        generateThumbnail(for: clipURL)
                    }
            }
        }
        .padding(.bottom, 10)
    }

    private func generateThumbnail(for url: URL) {
        let asset = AVURLAsset(url: url)
        let generator = AVAssetImageGenerator(asset: asset)
        generator.appliesPreferredTrackTransform = true

        let time = CMTimeMake(value: 0, timescale: 1)
        generator.generateCGImagesAsynchronously(forTimes: [NSValue(time: time)]) { _, image, _, _, _ in
            if let image = image {
                DispatchQueue.main.async {
                    self.thumbnailImage = UIImage(cgImage: image)
                }
            }
        }
    }
}

#Preview {
    PublicAccountsPage(publicAccountsUsername: "123")
}
