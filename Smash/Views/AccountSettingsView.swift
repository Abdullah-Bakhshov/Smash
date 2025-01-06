//
//  Account.swift
//  Smash
//
//  Created by Abdullah B on 01/11/2024.
//

import SwiftUI

struct AccountSettingsPage: View {
    @Bindable var states = ViewingStatesModel.shared
    @State private var isPublic: String = "Loading..."
    @Environment(\.colorScheme) var colorScheme
    
    private let backgroundColor = Color.black.opacity(0.95)
    
    var body: some View {
        ZStack {
            backgroundColor
                .ignoresSafeArea()
            
            VStack(spacing: 24) {
                header
                Divider()
                    .background(Color.gray.opacity(0.3))
                    .padding(.horizontal)
                
                settingsContent
                Spacer()
                footer
            }
            .padding(.top, 40)
        }
        .onAppear {
            Task {
                isPublic = await String(ClientForAPI().checkingIfProfilePublic(username: GlobalAccountinfo.shared.username))
            }
        }
    }
    
    private var header: some View {
        Text("Account Settings")
            .font(.system(size: 24, weight: .bold, design: .rounded))
            .foregroundColor(.white)
    }
    
    private var settingsContent: some View {
        VStack(spacing: 16) {
            privacyToggle
        }
        .padding(.horizontal)
    }
    
    private var privacyToggle: some View {
        Button(action: togglePrivacy) {
            HStack {
                Image(systemName: isPublic == "true" ? "globe" : "lock.fill")
                    .foregroundColor(.white)
                    .font(.system(size: 20))
                
                Text(isPublic == "true" ? "Public Account" : "Private Account")
                    .foregroundColor(.white)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .foregroundColor(.gray)
                    .font(.system(size: 14))
            }
            .padding()
            .background(Color.white.opacity(0.1))
            .cornerRadius(12)
        }
    }
    
    private var footer: some View {
        VStack(spacing: 16) {
            Button(action: {
//                let account = Account()
//                account.setAccountLoggedIn(username: "")
                states.reset()
            }) {
                Text("Logout")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.red)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.white.opacity(0.1))
                    .cornerRadius(12)
            }
            
            Button(action: { states.AccountBackToHomeToggle(back: 1) }) {
                Text("Back")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.white)
                    .padding(.bottom, 8)
            }
        }
        .padding(.horizontal)
        .padding(.bottom, 32)
    }
    
    private func togglePrivacy() {
        Task {
            if isPublic == "true" {
                await ClientForAPI().togglingProfilePublic(status: true)
                isPublic = "false"
            } else if isPublic == "false" {
                await ClientForAPI().togglingProfilePublic(status: false)
                isPublic = "true"
            }
        }
    }
}

#Preview {
    AccountSettingsPage()
}
