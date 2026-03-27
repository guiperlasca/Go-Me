//
//  Category.swift
//  GoMe
//
//  Created by Aluno-08 on 27/03/26.
//
import Foundation

enum Category: String, Identifiable, CaseIterable, Codable {
    
    var id: String { rawValue }
    
    case eletronics = "Electronics"
    case shopping = "Shopping"
    case food = "Food"
    case bills = "Bills"
    case work = "Work"
    case pets = "Dog"
    case family = "Family"
    case friends = "Friends"
    case relationship = "Relationship"
    case health = "Health"
    case entertainment = "Entertainment"
    case travel = "Travel"
    
    var imageName: String {
        switch self {
        case .eletronics: return "display.2"
        case .shopping: return "cart.fill"
        case .food: return "fork.knife"
        case .bills: return "text.page.fill"
        case .work: return "paperclip"
        case .pets: return "pawprint.fill"
        case .family: return "figure.2.and.child.holdinghands"
        case .friends: return "person.3.fill"
        case .relationship: return "figure.2.arms.open"
        case .health: return "heart.fill"
        case .entertainment: return "popcorn.fill"
        case .travel: return "airplane.up.forward"
        }
    }
}
