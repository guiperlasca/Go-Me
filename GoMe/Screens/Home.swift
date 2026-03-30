//
//  Home.swift
//  GoMe
//
//  Created by Aluno-08 on 27/03/26.
//

import Foundation
import SwiftUI

struct Home: View {

    @State private var goals: [Goal] = []
    @State private var wallets: [Wallet] = []

    @State private var addGoal: Bool = false
    @State private var addWallet: Bool = false

    var totalBalance: Double {
        wallets.reduce(0) { acc, w in w.isExpense ? acc - w.money : acc + w.money }
    }

    var monthlyExpenses: Double {
        let startOfMonth = Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: Date()))!
        return wallets
            .filter { $0.isExpense && $0.date >= startOfMonth }
            .reduce(0) { $0 + $1.money }
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    balanceCard
                    goalsSection
                    walletSection
                    Spacer(minLength: 40)
                }
                .padding(.top, 8)
                .padding(.bottom, 24)
            }
            .background(Color.blackBox)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Text("GOme")
                        .font(.system(size: 22, weight: .bold))
                        .foregroundStyle(Color.primaryBlue)
                }
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    Button("Scanner", systemImage: "squareshape.squareshape.dashed") {}
                        .foregroundStyle(.white)
                    Button("Add", systemImage: "plus") { addGoal = true }
                        .foregroundStyle(.white)
                }
            }
            .sheet(isPresented: $addGoal) {
                AddGoal(goals: $goals)
                    .presentationDragIndicator(.visible)
            }
        }
    }

    private var balanceCard: some View {
        ZStack(alignment: .bottomTrailing) {
            RoundedRectangle(cornerRadius: 24)
                .fill(
                    LinearGradient(
                        colors: [Color(red: 0.12, green: 0.22, blue: 0.28), Color(red: 0.08, green: 0.16, blue: 0.22)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )

            VStack(alignment: .leading, spacing: 4) {
                HStack(spacing: 10) {
                    Image(systemName: "person.circle.fill")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 32, height: 32)
                        .foregroundStyle(.white.opacity(0.7))

                    Text("Hello,!")
                        .font(.system(size: 15, weight: .medium))
                        .foregroundStyle(.white.opacity(0.85))

                    Spacer()
                }

                Spacer()

                Text(totalBalance, format: .currency(code: "BRL"))
                    .font(.system(size: 34, weight: .bold))
                    .foregroundStyle(.white)
            }
            .padding(20)

            if monthlyExpenses > 0 {
                Text("-$\(Int(monthlyExpenses))")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(.white.opacity(0.6))
                    .padding(.trailing, 20)
                    .padding(.bottom, 20)
            }
        }
        .frame(height: 170)
        .padding(.horizontal)
    }

    private var goalsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Goals")
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundStyle(.white)
                Spacer()
                NavigationLink(destination: GoalsScreen(goals: $goals)) {
                    Image(systemName: "chevron.right")
                        .foregroundStyle(.white.opacity(0.6))
                }
            }
            .padding(.horizontal)

            if goals.isEmpty {
                Text("No goals yet. Tap + to add one.")
                    .font(.subheadline)
                    .foregroundStyle(.white.opacity(0.4))
                    .padding(.horizontal)
            } else {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 10) {
                        ForEach(goals) { goal in
                            GoalView(goal: goal, compact: true)
                                .contextMenu {
                                    Button("Delete", systemImage: "trash", role: .destructive) {
                                        goals.removeAll { $0.id == goal.id }
                                    }
                                }
                        }
                    }
                    .padding(.horizontal)
                }
            }
        }
    }

    private var walletSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Wallet")
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundStyle(.white)
                Spacer()
                Button {
                    addWallet = true
                } label: {
                    Image(systemName: "chevron.right")
                        .foregroundStyle(.white.opacity(0.6))
                }
            }
            .padding(.horizontal)

            if wallets.isEmpty {
                Text("No transactions yet.")
                    .font(.subheadline)
                    .foregroundStyle(.white.opacity(0.4))
                    .padding(.horizontal)
            } else {
                VStack(spacing: 8) {
                    ForEach(wallets.prefix(5)) { wallet in
                        WalletView(wallet: wallet)
                            .padding(.horizontal)
                            .swipeActions(edge: .trailing) {
                                Button("Delete", systemImage: "trash", role: .destructive) {
                                    wallets.removeAll { $0.id == wallet.id }
                                }
                            }
                    }

                    if wallets.count > 5 {
                        Button("View All") {}
                            .font(.system(size: 15, weight: .semibold))
                            .foregroundStyle(Color.primaryBlue)
                            .padding(.top, 4)
                    }
                }
            }
        }
    }
}

#Preview {
    Home()
}
