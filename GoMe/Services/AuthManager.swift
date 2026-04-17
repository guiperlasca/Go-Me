//
//  AuthManager.swift
//  GoMe
//

import Foundation
import AuthenticationServices
import Observation

@Observable
class AuthManager: NSObject {
    
    static let shared = AuthManager()
    
    var isAuthenticated: Bool = false
    var currentUser: UserProfile = UserProfile()
    var isLoading: Bool = false
    
    private let userIDKey = "gome_apple_user_id"
    private let userNameKey = "gome_user_name"
    private let userEmailKey = "gome_user_email"
    
    private override init() {
        super.init()
        restoreSession()
    }
    
    // MARK: - Sign In with Apple
    
    func signInWithApple() {
        let provider = ASAuthorizationAppleIDProvider()
        let request = provider.createRequest()
        request.requestedScopes = [.fullName, .email]
        
        let controller = ASAuthorizationController(authorizationRequests: [request])
        controller.delegate = self
        controller.performRequests()
        isLoading = true
    }
    
    func signOut() {
        isAuthenticated = false
        currentUser = UserProfile()
        UserDefaults.standard.removeObject(forKey: userIDKey)
        UserDefaults.standard.removeObject(forKey: userNameKey)
        UserDefaults.standard.removeObject(forKey: userEmailKey)
    }
    
    // MARK: - Session Persistence
    
    private func restoreSession() {
        guard let userID = UserDefaults.standard.string(forKey: userIDKey) else { return }
        let name = UserDefaults.standard.string(forKey: userNameKey) ?? "User"
        let email = UserDefaults.standard.string(forKey: userEmailKey) ?? ""
        
        // Verify the credential is still valid
        let provider = ASAuthorizationAppleIDProvider()
        provider.getCredentialState(forUserID: userID) { [weak self] state, _ in
            DispatchQueue.main.async {
                if state == .authorized {
                    self?.currentUser = UserProfile(displayName: name, email: email)
                    self?.currentUser.friends = Friend.samples
                    self?.isAuthenticated = true
                }
            }
        }
    }
    
    private func saveSession(userID: String, name: String, email: String) {
        UserDefaults.standard.set(userID, forKey: userIDKey)
        UserDefaults.standard.set(name, forKey: userNameKey)
        UserDefaults.standard.set(email, forKey: userEmailKey)
    }
}

// MARK: - ASAuthorizationControllerDelegate

extension AuthManager: ASAuthorizationControllerDelegate {
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        isLoading = false
        
        guard let credential = authorization.credential as? ASAuthorizationAppleIDCredential else { return }
        
        let userID = credential.user
        let fullName = [credential.fullName?.givenName, credential.fullName?.familyName]
            .compactMap { $0 }
            .joined(separator: " ")
        let name = fullName.isEmpty ? "User" : fullName
        let email = credential.email ?? ""
        
        saveSession(userID: userID, name: name, email: email)
        
        currentUser = UserProfile(displayName: name, email: email)
        currentUser.friends = Friend.samples
        isAuthenticated = true
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        isLoading = false
        print("Sign in with Apple failed: \(error.localizedDescription)")
    }
}
