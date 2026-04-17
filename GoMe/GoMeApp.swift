//
//  GoMeApp.swift
//  GoMe
//
//  Created by Aluno-08 on 27/03/26.
//

import SwiftUI

@main
struct GoMeApp: App {
    
    @State private var authManager = AuthManager.shared
    
    var body: some Scene {
        WindowGroup {
            Group {
                if authManager.isAuthenticated {
                    MainTabView(authManager: authManager)
                        .transition(.opacity)
                } else {
                    LoginScreen(authManager: authManager)
                        .transition(.opacity)
                }
            }
            .animation(.easeInOut(duration: 0.4), value: authManager.isAuthenticated)
        }
    }
}
