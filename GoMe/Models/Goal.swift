//
//  Goal.swift
//  GoMe
//
//  Created by Aluno-08 on 27/03/26.
//

import Foundation
import Observation

@Observable
class Goal: Identifiable {
    var id = UUID()
    var name: String
    var money = Double(0.00)
    var savedAmount: Double = 0
    var endDate: Date?
    var details: String
    var category: Category
    var isCompleted: Bool = false
    var isGroup: Bool = false
    var groupImageData: Data? = nil
    var members: [Friend] = []
    var linkedWalletIDs: [UUID] = []
    
    var progressValue: Double {
        guard money > 0 else { return 0 }
        return min(savedAmount / money, 1.0)
    }
    
    var daysLeft: Int {
        guard let end = endDate else { return 999 }
        return max(Calendar.current.dateComponents([.day], from: Date(), to: end).day ?? 0, 0)
    }
    
    var dailySavingsNeeded: Double {
        let remaining = max(money - savedAmount, 0)
        let days = max(daysLeft, 1)
        return remaining / Double(days)
    }
    
    init(name: String, details: String, category: Category) {
        self.name = name
        self.details = details
        self.category = category
    }
    
    func recalculate(from wallets: [Wallet]) {
        let linked = wallets.filter { linkedWalletIDs.contains($0.id) }
        savedAmount = linked.reduce(0) { $0 + $1.money }
        isCompleted = progressValue >= 1.0
    }
}
