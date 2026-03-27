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
    
    var body: some View {
        HStack(alignment: .center, spacing: 16) {
            Image(systemName: wallet.category.imageName)
            
            VStack(alignment: .leading, spacing: 4) {                  Text(wallet.name)
                    .foregroundStyle(.primary)
                Text(wallet.date, style: .date)
                    .foregroundStyle(.secondary)
            }
            
            Spacer()
            
            Text(wallet.money, format: .currency(code: "BRL"))
                .foregroundStyle(wallet.money < 0 ? .red : .green)
        }
        .padding()
        .glassEffect(in: .rect(cornerRadius: 16.0))
    }
}

#Preview {
    WalletView(wallet: Wallet(name: "Mercado", money: -150.00, category: .food))
}
