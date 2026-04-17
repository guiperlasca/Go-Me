//
//  GoalCalculator.swift
//  GoMe
//

import Foundation

enum GoalCalculator {
    
    /// Recalculates all goals based on linked wallet transactions
    static func recalculateAll(goals: [Goal], wallets: [Wallet]) {
        for goal in goals {
            goal.recalculate(from: wallets)
        }
    }
    
    /// Links a wallet entry to a goal and recalculates
    static func linkWallet(_ wallet: Wallet, to goal: Goal, wallets: [Wallet]) {
        wallet.linkedGoalID = goal.id
        if !goal.linkedWalletIDs.contains(wallet.id) {
            goal.linkedWalletIDs.append(wallet.id)
        }
        goal.recalculate(from: wallets)
    }
    
    /// Unlinks a wallet entry from a goal and recalculates
    static func unlinkWallet(_ wallet: Wallet, from goal: Goal, wallets: [Wallet]) {
        wallet.linkedGoalID = nil
        goal.linkedWalletIDs.removeAll { $0 == wallet.id }
        goal.recalculate(from: wallets)
    }
    
    /// Returns summary metrics for a goal
    static func metrics(for goal: Goal) -> GoalMetrics {
        let remaining = max(goal.money - goal.savedAmount, 0)
        let percentComplete = goal.progressValue * 100
        let daysLeft = goal.daysLeft
        let dailyNeeded = goal.dailySavingsNeeded
        
        return GoalMetrics(
            saved: goal.savedAmount,
            target: goal.money,
            remaining: remaining,
            percentComplete: percentComplete,
            daysLeft: daysLeft,
            dailySavingsNeeded: dailyNeeded,
            isCompleted: goal.isCompleted
        )
    }
}

struct GoalMetrics {
    let saved: Double
    let target: Double
    let remaining: Double
    let percentComplete: Double
    let daysLeft: Int
    let dailySavingsNeeded: Double
    let isCompleted: Bool
}
