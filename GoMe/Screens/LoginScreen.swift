//
//  LoginScreen.swift
//  GoMe
//

import SwiftUI
import AuthenticationServices

struct LoginScreen: View {
    
    var authManager: AuthManager
    
    @State private var animateGradient = false
    @State private var showContent = false
    
    var body: some View {
        ZStack {
            // Animated gradient background
            LinearGradient(
                colors: [
                    Color.blackBox,
                    Color.primaryBlue.opacity(0.15),
                    Color.blackBox
                ],
                startPoint: animateGradient ? .topLeading : .bottomTrailing,
                endPoint: animateGradient ? .bottomTrailing : .topLeading
            )
            .ignoresSafeArea()
            .onAppear {
                withAnimation(.easeInOut(duration: 4).repeatForever(autoreverses: true)) {
                    animateGradient.toggle()
                }
            }
            
            VStack(spacing: 0) {
                
                Spacer()
                
                // App Icon / Logo area
                VStack(spacing: 20) {
                    ZStack {
                        Circle()
                            .fill(
                                LinearGradient(
                                    colors: [Color.primaryBlue, Color.primaryGreen],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: 100, height: 100)
                            .shadow(color: Color.primaryBlue.opacity(0.4), radius: 30, y: 10)
                        
                        Image(systemName: "flag.checkered")
                            .font(.system(size: 44, weight: .medium))
                            .foregroundStyle(.white)
                    }
                    .scaleEffect(showContent ? 1 : 0.5)
                    .opacity(showContent ? 1 : 0)
                    
                    VStack(spacing: 8) {
                        Text("GOMe")
                            .font(.system(size: 42, weight: .bold, design: .rounded))
                            .foregroundStyle(
                                LinearGradient(
                                    colors: [Color.primaryBlue, Color.primaryGreen],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                        
                        Text("Track goals. Save together.")
                            .font(.system(size: 17, weight: .medium))
                            .foregroundStyle(.white.opacity(0.6))
                    }
                    .offset(y: showContent ? 0 : 20)
                    .opacity(showContent ? 1 : 0)
                }
                
                Spacer()
                
                // Features highlights
                VStack(spacing: 16) {
                    featureRow(icon: "target", title: "Set Goals", subtitle: "Personal or with friends")
                    featureRow(icon: "chart.line.uptrend.xyaxis", title: "Track Progress", subtitle: "Real-time metrics & insights")
                    featureRow(icon: "person.2.fill", title: "Group Savings", subtitle: "Invite friends to save together")
                }
                .padding(.horizontal, 32)
                .offset(y: showContent ? 0 : 30)
                .opacity(showContent ? 1 : 0)
                
                Spacer()
                
                // Sign in with Apple button
                VStack(spacing: 16) {
                    SignInWithAppleButton(.signIn) { request in
                        request.requestedScopes = [.fullName, .email]
                    } onCompletion: { result in
                        switch result {
                        case .success(let authorization):
                            handleAuthorization(authorization)
                        case .failure(let error):
                            print("Sign in failed: \(error)")
                        }
                    }
                    .signInWithAppleButtonStyle(.white)
                    .frame(height: 56)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .padding(.horizontal, 32)
                    
                    if authManager.isLoading {
                        ProgressView()
                            .tint(.white)
                    }
                    
                    Text("Your data stays private and secure.")
                        .font(.system(size: 13))
                        .foregroundStyle(.white.opacity(0.35))
                }
                .padding(.bottom, 50)
                .offset(y: showContent ? 0 : 40)
                .opacity(showContent ? 1 : 0)
            }
        }
        .onAppear {
            withAnimation(.spring(response: 0.8, dampingFraction: 0.7).delay(0.2)) {
                showContent = true
            }
        }
    }
    
    private func featureRow(icon: String, title: String, subtitle: String) -> some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.system(size: 20, weight: .medium))
                .foregroundStyle(Color.primaryBlue)
                .frame(width: 44, height: 44)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.white.opacity(0.06))
                )
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(.white)
                Text(subtitle)
                    .font(.system(size: 13))
                    .foregroundStyle(.white.opacity(0.5))
            }
            
            Spacer()
        }
    }
    
    private func handleAuthorization(_ authorization: ASAuthorization) {
        guard let credential = authorization.credential as? ASAuthorizationAppleIDCredential else { return }
        
        let userID = credential.user
        let fullName = [credential.fullName?.givenName, credential.fullName?.familyName]
            .compactMap { $0 }
            .joined(separator: " ")
        let name = fullName.isEmpty ? "User" : fullName
        let email = credential.email ?? ""
        
        UserDefaults.standard.set(userID, forKey: "gome_apple_user_id")
        UserDefaults.standard.set(name, forKey: "gome_user_name")
        UserDefaults.standard.set(email, forKey: "gome_user_email")
        
        authManager.currentUser = UserProfile(displayName: name, email: email)
        authManager.currentUser.friends = Friend.samples
        authManager.isAuthenticated = true
    }
}

#Preview {
    LoginScreen(authManager: AuthManager.shared)
}
