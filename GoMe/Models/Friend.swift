//
//  Friend.swift
//  GoMe
//

import Foundation

struct Friend: Identifiable, Equatable, Hashable {
    var id = UUID()
    var name: String
    var avatarEmoji: String = "😊"
    
    static let samples: [Friend] = [
        Friend(name: "Amanda", avatarEmoji: "👩🏻"),
        Friend(name: "Pedro", avatarEmoji: "👨🏽"),
        Friend(name: "Ana", avatarEmoji: "👩🏼"),
        Friend(name: "Lucas", avatarEmoji: "👦🏻"),
        Friend(name: "Maria", avatarEmoji: "👩🏽"),
    ]
}
