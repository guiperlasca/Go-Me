//
//  UserProfile.swift
//  GoMe
//

import Foundation

@Observable
class UserProfile {
    var id = UUID()
    var displayName: String
    var email: String
    var avatarEmoji: String = "😎"
    var friends: [Friend] = []
    
    init(displayName: String = "User", email: String = "") {
        self.displayName = displayName
        self.email = email
    }
}
