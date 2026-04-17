//
//  MainTabView.swift
//  GoMe
//

import SwiftUI

struct MainTabView: View {
    
    var authManager: AuthManager
    
    @State var goals: [Goal] = []
    @State var wallets: [Wallet] = []
    @State private var selectedTab: Int = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            
            Home(goals: $goals, wallets: $wallets, authManager: authManager)
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Home")
                }
                .tag(0)
            
            GoalsScreen(goals: $goals, wallets: $wallets)
                .tabItem {
                    Image(systemName: "target")
                    Text("Goals")
                }
                .tag(1)
            
            ProfileScreen(authManager: authManager)
                .tabItem {
                    Image(systemName: "person.fill")
                    Text("Profile")
                }
                .tag(2)
        }
        .tint(Color.primaryBlue)
        .preferredColorScheme(.dark)
    }
}

#Preview {
    MainTabView(authManager: AuthManager.shared)
}
