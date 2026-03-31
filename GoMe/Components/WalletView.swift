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
        return "\(days) ago"
    }

    var body: some View {
        HStack(alignment: .center, spacing: 14) {
            ZStack {
                Circle()
                    .fill(Color.white.opacity(0.08))
                    .frame(width: 40, height: 40)
                Image(systemName: wallet.category.imageName)
                    .font(.system(size: 16))
                    .foregroundStyle(.white.opacity(0.8))
            }

            VStack(alignment: .leading, spacing: 3) {
                Text(wallet.name)
                    .font(.system(size: 15, weight: .medium))
                    .foregroundStyle(.white)
                Text(relativeDate)
                    .font(.system(size: 12))
                    .foregroundStyle(.white.opacity(0.45))
            }

            Spacer()

            Text("\(wallet.isExpense ? "-" : "+")$ \(Int(abs(wallet.money)))")
                .font(.system(size: 15, weight: .semibold))
                .foregroundStyle(wallet.isExpense ? Color.white.opacity(0.9) : Color.primaryGreen)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white.opacity(0.06))
        )
    }
}

#Preview {
    WalletView(wallet: Wallet(name: "Pizza", money: 26, date: Date(), isExpense: true, category: .food))
        .padding()
        .background(Color.blackBox)
}
