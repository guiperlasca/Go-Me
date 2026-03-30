//
//  WalletScreen.swift
//  GoMe
//
//  Created by Aluno-08 on 30/03/26.
//

import SwiftUI

enum WalletTab: String, CaseIterable, Identifiable {
    case expenses = "Expenses"
    case received = "Received"
    var id: String { rawValue }
}

struct WalletScreen: View {

    @Binding var wallets: [Wallet]
    @State private var selectedTab: WalletTab = .expenses
    @State private var showAddWallet: Bool = false

    @Environment(\.dismiss) private var dismiss

    private var filtered: [Wallet] {
        switch selectedTab {
        case .expenses: return wallets.filter { $0.isExpense }
        case .received: return wallets.filter { !$0.isExpense }
        }
    }

    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            Color.blackBox.ignoresSafeArea()

            VStack(spacing: 0) {
                navBar
                tabPicker
                    .padding(.top, 12)
                    .padding(.horizontal)

                if filtered.isEmpty {
                    emptyState
                } else {
                    ScrollView {
                        VStack(spacing: 8) {
                            ForEach(filtered) { wallet in
                                WalletView(wallet: wallet)
                                    .padding(.horizontal)
                                    .swipeActions(edge: .trailing) {
                                        Button("Delete", systemImage: "trash", role: .destructive) {
                                            wallets.removeAll { $0.id == wallet.id }
                                        }
                                    }
                            }
                        }
                        .padding(.top, 16)
                        .padding(.bottom, 100)
                    }
                }
            }

            bottomBar
        }
        .navigationBarHidden(true)
        .sheet(isPresented: $showAddWallet) {
            AddWallet(wallets: $wallets)
                .presentationDragIndicator(.visible)
        }
    }

    private var navBar: some View {
        HStack {
            Button { dismiss() } label: {
                Image(systemName: "chevron.left")
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundStyle(.white)
                    .frame(width: 36, height: 36)
                    .background(Circle().fill(Color.white.opacity(0.12)))
            }
            Spacer()
            Text("Wallet")
                .font(.system(size: 20, weight: .bold))
                .foregroundStyle(.white)
            Spacer()
            Button {} label: {
                Image(systemName: "magnifyingglass")
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundStyle(.white)
                    .frame(width: 36, height: 36)
                    .background(Circle().fill(Color.white.opacity(0.12)))
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 12)
    }

    private var tabPicker: some View {
        HStack(spacing: 0) {
            ForEach(WalletTab.allCases) { tab in
                Button {
                    withAnimation(.easeInOut(duration: 0.2)) { selectedTab = tab }
                } label: {
                    Text(tab.rawValue)
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundStyle(selectedTab == tab ? .black : .white.opacity(0.6))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 9)
                        .background(
                            selectedTab == tab
                                ? RoundedRectangle(cornerRadius: 10).fill(Color.white)
                                : RoundedRectangle(cornerRadius: 10).fill(Color.clear)
                        )
                }
            }
        }
        .padding(4)
        .background(RoundedRectangle(cornerRadius: 14).fill(Color.white.opacity(0.1)))
    }

    private var emptyState: some View {
        VStack(spacing: 16) {
            Spacer()
            Image(systemName: "creditcard.fill")
                .font(.system(size: 48))
                .foregroundStyle(.white.opacity(0.3))
            Text("No transactions yet")
                .font(.headline)
                .foregroundStyle(.white.opacity(0.5))
            Text("Tap + to register a transaction")
                .font(.subheadline)
                .foregroundStyle(.white.opacity(0.35))
            Spacer()
        }
    }

    private var bottomBar: some View {
        HStack(spacing: 12) {
            Spacer()
            Button {} label: {
                Image(systemName: "squareshape.squareshape.dashed")
                    .font(.system(size: 20))
                    .foregroundStyle(.white)
                    .frame(width: 48, height: 48)
                    .background(Circle().fill(Color.white.opacity(0.1)).overlay(Circle().stroke(Color.white.opacity(0.25), lineWidth: 1)))
            }
            Button { showAddWallet = true } label: {
                Image(systemName: "plus")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundStyle(.white)
                    .frame(width: 48, height: 48)
                    .background(Circle().fill(Color.white.opacity(0.1)).overlay(Circle().stroke(Color.white.opacity(0.25), lineWidth: 1)))
            }
        }
        .padding(.horizontal, 20)
        .padding(.bottom, 28)
    }
}

#Preview {
    @Previewable @State var wallets: [Wallet] = [
        Wallet(name: "Pizza",       money: 26,   date: Calendar.current.date(byAdding: .day, value: -8, to: Date())!, isExpense: true,  category: .food),
        Wallet(name: "Streaming",   money: 10,   date: Calendar.current.date(byAdding: .day, value: -7, to: Date())!, isExpense: true,  category: .entertainment),
        Wallet(name: "Freelancer",  money: 100,  date: Calendar.current.date(byAdding: .day, value: -7, to: Date())!, isExpense: false, category: .work),
        Wallet(name: "Coffe",       money: 8,    date: Calendar.current.date(byAdding: .day, value: -7, to: Date())!, isExpense: true,  category: .food),
        Wallet(name: "Health",      money: 50,   date: Calendar.current.date(byAdding: .day, value: -6, to: Date())!, isExpense: true,  category: .health),
        Wallet(name: "Burger",      money: 10,   date: Calendar.current.date(byAdding: .day, value: -5, to: Date())!, isExpense: true,  category: .food),
        Wallet(name: "Payday",      money: 2001, date: Calendar.current.date(byAdding: .day, value: -5, to: Date())!, isExpense: false, category: .work),
    ]
    return WalletScreen(wallets: $wallets)
}
