//
//  FriendsSlidingView.swift
//  Smash
//
//  Created by Abdullah B on 03/01/2025.
//

import SwiftUI

struct Friend: Identifiable {
    let id = UUID()
    let name: String
}

struct FriendsSearchSheet: View {
    @State private var searchText = ""
    @Binding var isSheetPresented: Bool
    @State private var searchResults: [Friend] = []
    @State private var followingFriends: [Friend] = []
    @State private var isViewingFollowing = true

    func loadFollowingAccounts() {
        Task {
            let followingUsernames = await ClientForAPI().gettingFollowingAccounts()
            self.followingFriends = followingUsernames.map { Friend(name: $0) }
        }
    }

    func searchForFriends() {
        Task {
            let username = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
            if !username.isEmpty {
                let accountDetails = await ClientForAPI().getAccount(username: username)
                
                if !accountDetails.isEmpty && accountDetails[0] != "" {
                    let friend = Friend(name: accountDetails[0])
                    self.searchResults = [friend]
                } else {
                    self.searchResults = []
                }
            } else {
                self.searchResults = []
            }
        }
    }

    var filteredFriends: [Friend] {
        if searchText.isEmpty {
            return searchResults
        }
        return searchResults.filter { friend in
            friend.name.localizedCaseInsensitiveContains(searchText)
        }
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
                    TextField("Search friends", text: $searchText)
                        .textFieldStyle(PlainTextFieldStyle())
                        .foregroundColor(.black)
                        .onChange(of: searchText) { _, _ in
                            searchForFriends()
                        }
                }
                .padding(10)
                .background(Color.gray.opacity(0.1))
                .cornerRadius(10)
                .padding(.horizontal)
                
                ScrollView {
                    LazyVStack(spacing: 16) {
                        if isViewingFollowing {
                            ForEach(followingFriends) { friend in
                                FriendRow(friend: friend, showAddButton: false, followingFriends: $followingFriends)
                            }
                        } else {
                            ForEach(filteredFriends) { friend in
                                FriendRow(friend: friend,
                                          showAddButton: !followingFriends.contains(where: { $0.name == friend.name }),
                                          followingFriends: $followingFriends)
                            }
                        }
                    }
                    .padding(.top, 20)
                }
            }
            .navigationTitle(isViewingFollowing ? "Following" : "Search Results")
            .navigationBarTitleDisplayMode(.inline)
            .foregroundColor(.black)
            .background(
                Color.white
                    .edgesIgnoringSafeArea(.all)
            )
            .onAppear {
                if isViewingFollowing {
                    loadFollowingAccounts()
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        isViewingFollowing.toggle()
                        if isViewingFollowing {
                            loadFollowingAccounts()
                        }
                    }) {
                        Text(isViewingFollowing ? "Following" : "Search")
                            .foregroundColor(.black)
                    }
                }
            }
        }
        .accentColor(.blue)
    }
}


struct FriendRow: View {
    let friend: Friend
    let showAddButton: Bool
    @Binding var followingFriends: [Friend]

    var body: some View {
        NavigationLink(destination: PublicAccountsPage(publicAccountsUsername: friend.name)) {
            HStack(spacing: 12) {
                Circle()
                    .fill(Color.gray.opacity(0.1))
                    .frame(width: 50, height: 50)
                    .overlay(
                        Text(String(friend.name.prefix(1)))
                            .foregroundColor(.gray)
                            .font(.title2)
                    )

                VStack(alignment: .leading, spacing: 4) {
                    Text(friend.name)
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.black)
                }

                Spacer()

                if showAddButton {
                    Button(action: {
                        addFriend(friend)
                    }) {
                        Text("Add")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.white)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 6)
                            .background(Color.blue)
                            .cornerRadius(15)
                    }
                    .disabled(followingFriends.contains(where: { $0.name == friend.name }))
                }
            }
            .padding(.horizontal)
        }
        .navigationBarBackButtonHidden(true)
    }

    private func addFriend(_ friend: Friend) {
        Task {
            await ClientForAPI().followingAccount(targetusername: friend.name)
            followingFriends.append(friend)
        }
    }
}
