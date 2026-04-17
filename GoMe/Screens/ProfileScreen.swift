//
//  ProfileScreen.swift
//  GoMe
//

import SwiftUI

struct ProfileScreen: View {
    
    var authManager: AuthManager
    
    @State private var isEditingName = false
    @State private var editedName: String = ""
    @State private var showAddFriend = false
    @State private var newFriendName: String = ""
    
    private let emojiOptions = ["😎", "🤩", "😊", "🥳", "🧑‍💻", "🦊", "🐱", "🌟", "🔥", "💎", "🎯", "🚀"]
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.blackBox.ignoresSafeArea()
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 24) {
                        
                        // MARK: - Avatar & Name
                        profileHeader
                            .padding(.top, 20)
                        
                        // MARK: - Stats Cards
                        statsSection
                        
                        // MARK: - Friends Section
                        friendsSection
                        
                        // MARK: - Sign Out
                        Button {
                            withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                                authManager.signOut()
                            }
                        } label: {
                            HStack(spacing: 10) {
                                Image(systemName: "rectangle.portrait.and.arrow.right")
                                    .font(.system(size: 16, weight: .medium))
                                Text("Sign Out")
                                    .font(.system(size: 16, weight: .semibold))
                            }
                            .foregroundStyle(.red.opacity(0.8))
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(Color.red.opacity(0.08))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 16)
                                            .stroke(Color.red.opacity(0.15), lineWidth: 1)
                                    )
                            )
                        }
                        .padding(.horizontal)
                        .padding(.top, 8)
                    }
                    .padding(.bottom, 100)
                }
            }
            .navigationTitle("Profile")
            .navigationBarTitleDisplayMode(.large)
            .preferredColorScheme(.dark)
            .alert("Add Friend", isPresented: $showAddFriend) {
                TextField("Friend's name", text: $newFriendName)
                Button("Add") {
                    if !newFriendName.isEmpty {
                        let emojis = ["😊", "👩🏻", "👨🏽", "👩🏼", "👦🏻", "👩🏽", "🧑🏻", "👱🏻‍♀️"]
                        let friend = Friend(name: newFriendName, avatarEmoji: emojis.randomElement()!)
                        authManager.currentUser.friends.append(friend)
                        newFriendName = ""
                    }
                }
                Button("Cancel", role: .cancel) { newFriendName = "" }
            } message: {
                Text("Enter your friend's name to add them.")
            }
        }
    }
    
    // MARK: - Profile Header
    
    private var profileHeader: some View {
        VStack(spacing: 16) {
            // Avatar
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [Color.primaryBlue.opacity(0.3), Color.primaryGreen.opacity(0.2)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 100, height: 100)
                    .overlay(
                        Circle().stroke(Color.white.opacity(0.15), lineWidth: 1.5)
                    )
                
                Text(authManager.currentUser.avatarEmoji)
                    .font(.system(size: 48))
            }
            
            // Emoji picker
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    ForEach(emojiOptions, id: \.self) { emoji in
                        Button {
                            withAnimation(.spring(response: 0.3)) {
                                authManager.currentUser.avatarEmoji = emoji
                            }
                        } label: {
                            Text(emoji)
                                .font(.system(size: 24))
                                .frame(width: 40, height: 40)
                                .background(
                                    Circle()
                                        .fill(authManager.currentUser.avatarEmoji == emoji ?
                                              Color.primaryBlue.opacity(0.3) : Color.white.opacity(0.06))
                                )
                        }
                    }
                }
                .padding(.horizontal)
            }
            
            // Name
            if isEditingName {
                HStack(spacing: 12) {
                    TextField("Your name", text: $editedName)
                        .font(.system(size: 22, weight: .bold))
                        .foregroundStyle(.white)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 10)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.white.opacity(0.08))
                        )
                    
                    Button {
                        authManager.currentUser.displayName = editedName
                        isEditingName = false
                    } label: {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.system(size: 28))
                            .foregroundStyle(Color.primaryGreen)
                    }
                }
                .padding(.horizontal, 40)
            } else {
                HStack(spacing: 8) {
                    Text(authManager.currentUser.displayName)
                        .font(.system(size: 24, weight: .bold))
                        .foregroundStyle(.white)
                    
                    Button {
                        editedName = authManager.currentUser.displayName
                        isEditingName = true
                    } label: {
                        Image(systemName: "pencil.circle")
                            .font(.system(size: 20))
                            .foregroundStyle(.white.opacity(0.4))
                    }
                }
            }
            
            if !authManager.currentUser.email.isEmpty {
                Text(authManager.currentUser.email)
                    .font(.system(size: 14))
                    .foregroundStyle(.white.opacity(0.4))
            }
        }
    }
    
    // MARK: - Stats
    
    private var statsSection: some View {
        HStack(spacing: 12) {
            statCard(value: "0", label: "Goals", icon: "target", color: Color.primaryBlue)
            statCard(value: "0", label: "Completed", icon: "checkmark.circle", color: Color.primaryGreen)
            statCard(value: "$0", label: "Saved", icon: "dollarsign.circle", color: Color.primaryBlue)
        }
        .padding(.horizontal)
    }
    
    private func statCard(value: String, label: String, icon: String, color: Color) -> some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 22, weight: .medium))
                .foregroundStyle(color)
            
            Text(value)
                .font(.system(size: 20, weight: .bold))
                .foregroundStyle(.white)
            
            Text(label)
                .font(.system(size: 12))
                .foregroundStyle(.white.opacity(0.5))
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white.opacity(0.06))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.white.opacity(0.08), lineWidth: 1)
                )
        )
    }
    
    // MARK: - Friends Section
    
    private var friendsSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack {
                Text("Friends")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundStyle(.white)
                
                Spacer()
                
                Button {
                    showAddFriend = true
                } label: {
                    Image(systemName: "person.badge.plus")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundStyle(Color.primaryBlue)
                }
            }
            .padding(.horizontal)
            
            if authManager.currentUser.friends.isEmpty {
                HStack {
                    Spacer()
                    VStack(spacing: 8) {
                        Image(systemName: "person.2.slash")
                            .font(.system(size: 32))
                            .foregroundStyle(.white.opacity(0.25))
                        Text("No friends yet")
                            .font(.system(size: 14))
                            .foregroundStyle(.white.opacity(0.4))
                    }
                    .padding(.vertical, 24)
                    Spacer()
                }
            } else {
                VStack(spacing: 0) {
                    ForEach(authManager.currentUser.friends) { friend in
                        HStack(spacing: 14) {
                            Text(friend.avatarEmoji)
                                .font(.system(size: 28))
                                .frame(width: 44, height: 44)
                                .background(
                                    Circle()
                                        .fill(Color.white.opacity(0.06))
                                )
                            
                            Text(friend.name)
                                .font(.system(size: 16, weight: .medium))
                                .foregroundStyle(.white)
                            
                            Spacer()
                            
                            Image(systemName: "chevron.right")
                                .font(.system(size: 13, weight: .medium))
                                .foregroundStyle(.white.opacity(0.3))
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 12)
                        
                        if friend.id != authManager.currentUser.friends.last?.id {
                            Divider()
                                .background(Color.white.opacity(0.06))
                                .padding(.leading, 74)
                        }
                    }
                }
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color.white.opacity(0.05))
                )
                .padding(.horizontal)
            }
        }
    }
}

#Preview {
    ProfileScreen(authManager: AuthManager.shared)
}
