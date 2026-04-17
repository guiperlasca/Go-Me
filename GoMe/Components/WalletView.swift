//
//  WalletView.swift
//  GoMe
//
//  Created by Aluno-08 on 27/03/26.
//

import Foundation
import SwiftUI

struct WalletView: View {
    var wallet: Wallet

    private var relativeDate: String {
        let days = Calendar.current.dateComponents([.day], from: wallet.date, to: Date()).day ?? 0
        if days == 0 { return "Today" }
        if days == 1 { return "Yesterday" }
        return "\(days) days ago"
    }

    var body: some View {
        HStack(alignment: .center, spacing: 14) {
            ZStack {
                Circle()
                    .fill(
                        wallet.isExpense
                            ? Color.primaryBlue.opacity(0.12)
                            : Color.primaryGreen.opacity(0.12)
                    )
                    .frame(width: 42, height: 42)
                Image(systemName: wallet.category.imageName)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundStyle(wallet.isExpense ? Color.primaryBlue : Color.primaryGreen)
            }

            VStack(alignment: .leading, spacing: 3) {
                Text(wallet.name)
                    .font(.system(size: 15, weight: .medium))
                    .foregroundStyle(.white)
                
                HStack(spacing: 6) {
                    Text(relativeDate)
                        .font(.system(size: 12))
                        .foregroundStyle(.white.opacity(0.4))
                    
                    if wallet.linkedGoalID != nil {
                        HStack(spacing: 3) {
                            Image(systemName: "link")
                                .font(.system(size: 9))
                            Text("linked")
                                .font(.system(size: 10))
                        }
                        .foregroundStyle(Color.primaryBlue.opacity(0.7))
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(
                            Capsule()
                                .fill(Color.primaryBlue.opacity(0.1))
                        )
                    }
                }
            }

            Spacer()

            Text(wallet.money, format: .currency(code: "USD"))
                .font(.system(size: 15, weight: .semibold))
                .foregroundStyle(wallet.isExpense ? .white.opacity(0.9) : Color.primaryGreen)
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white.opacity(0.05))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.white.opacity(0.04), lineWidth: 1)
                )
        )
    }
}

#Preview {
    VStack(spacing: 8) {
        WalletView(wallet: Wallet(name: "Pizza", money: 26, date: Date(), isExpense: true, category: .food))
        WalletView(wallet: Wallet(name: "Freelance", money: 500, date: Date(), isExpense: false, category: .work, linkedGoalID: UUID()))
    }
    .padding()
    .background(Color.blackBox)
}
