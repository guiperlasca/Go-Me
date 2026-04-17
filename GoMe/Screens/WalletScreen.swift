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
    @Binding var goals: [Goal]
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
                    List {
                        ForEach(filtered) { wallet in
                            WalletView(wallet: wallet)
                                .listRowBackground(Color.clear)
                                .listRowSeparatorTint(.white.opacity(0.06))
                                .listRowInsets(EdgeInsets(top: 4, leading: 16, bottom: 4, trailing: 16))
                                .swipeActions(edge: .trailing) {
                                    Button("Delete", systemImage: "trash", role: .destructive) {
                                        wallets.removeAll { $0.id == wallet.id }
                                    }
                                }
                        }
                    }
                    .listStyle(.plain)
                    .scrollContentBackground(.hidden)
                    .padding(.top, 8)
                }
            }

            // FAB
            Button { showAddWallet = true } label: {
                Image(systemName: "plus")
                    .font(.system(size: 22, weight: .semibold))
                    .foregroundStyle(.white)
                    .frame(width: 56, height: 56)
                    .background(
                        Circle()
                            .fill(
                                LinearGradient(
                                    colors: [Color.primaryBlue, Color.primaryGreen],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .shadow(color: Color.primaryBlue.opacity(0.4), radius: 12, y: 4)
                    )
            }
            .padding(.trailing, 20)
            .padding(.bottom, 28)
        }
        .navigationBarHidden(true)
        .sheet(isPresented: $showAddWallet) {
            AddWallet(wallets: $wallets, goals: $goals)
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
            Color.clear.frame(width: 36, height: 36)
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
                .foregroundStyle(.white.opacity(0.2))
            Text("No transactions yet")
                .font(.system(size: 18, weight: .semibold))
                .foregroundStyle(.white.opacity(0.5))
            Text("Tap + to register a transaction")
                .font(.system(size: 14))
                .foregroundStyle(.white.opacity(0.3))
            Spacer()
        }
    }
}

#Preview {
    @Previewable @State var wallets: [Wallet] = [
        Wallet(name: "Pizza",       money: 26,   date: Calendar.current.date(byAdding: .day, value: -8, to: Date())!, isExpense: true,  category: .food),
        Wallet(name: "Streaming",   money: 10,   date: Calendar.current.date(byAdding: .day, value: -7, to: Date())!, isExpense: true,  category: .entertainment),
        Wallet(name: "Freelancer",  money: 100,  date: Calendar.current.date(byAdding: .day, value: -7, to: Date())!, isExpense: false, category: .work),
    ]
    @Previewable @State var goals: [Goal] = []
    return WalletScreen(wallets: $wallets, goals: $goals)
}
