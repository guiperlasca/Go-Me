//
//  Home.swift
//  GoMe
//
//  Created by Aluno-08 on 27/03/26.
//
import SwiftUI

struct Home: View {
    
    @Binding var goals: [Goal]
    @Binding var wallets: [Wallet]
    var authManager: AuthManager
    
    @State private var addGoal: Bool = false
    @State private var addWallet: Bool = false
    
    var totalBalance: Double {
        wallets.reduce(0) { $0 + ($1.isExpense ? -$1.money : $1.money) }
    }

    var totalExpenses: Double {
        wallets.filter { $0.isExpense }.reduce(0) { $0 + $1.money }
    }
    
    var totalIncome: Double {
        wallets.filter { !$0.isExpense }.reduce(0) { $0 + $1.money }
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.blackBox.ignoresSafeArea()
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 24) {
                        
                        // MARK: - Header
                        HStack {
                            Text("GOMe")
                                .font(.system(size: 22, weight: .bold, design: .rounded))
                                .foregroundStyle(
                                    LinearGradient(
                                        colors: [Color.primaryBlue, Color.primaryGreen],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                            
                            Spacer()
                            
                            HStack(spacing: 14) {
                                Button { addWallet = true } label: {
                                    Image(systemName: "wallet.bifold")
                                        .font(.system(size: 17, weight: .semibold))
                                        .foregroundStyle(.white)
                                }
                                Button { addGoal = true } label: {
                                    Image(systemName: "plus")
                                        .font(.system(size: 17, weight: .semibold))
                                        .foregroundStyle(.white)
                                }
                            }
                            .padding(.horizontal, 14)
                            .padding(.vertical, 8)
                            .background(
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(Color.white.opacity(0.08))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 20)
                                            .stroke(Color.white.opacity(0.12), lineWidth: 1)
                                    )
                            )
                        }
                        .padding(.horizontal)
                        
                        // MARK: - Balance Card
                        balanceCard
                        
                        // MARK: - Quick Stats
                        quickStats
                    
                        // MARK: - Goals Section
                        goalsSection
                        
                        // MARK: - Wallet Section
                        walletSection
                    }
                    .padding(.vertical)
                }
            }
            .sheet(isPresented: $addGoal) {
                AddGoal(goals: $goals, friends: authManager.currentUser.friends)
                    .presentationDragIndicator(.visible)
            }
            .sheet(isPresented: $addWallet) {
                AddWallet(wallets: $wallets, goals: $goals)
                    .presentationDragIndicator(.visible)
            }
            .onChange(of: wallets.count) {
                GoalCalculator.recalculateAll(goals: goals, wallets: wallets)
            }
        }
    }
    
    // MARK: - Balance Card
    
    private var balanceCard: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 24)
                .fill(
                    LinearGradient(
                        colors: [Color.primaryBlue.opacity(0.35), Color.primaryGreen.opacity(0.25)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 24)
                        .stroke(Color.white.opacity(0.1), lineWidth: 1)
                )
                .frame(height: 180)
            
            VStack(alignment: .leading, spacing: 14) {
                HStack {
                    Text(authManager.currentUser.avatarEmoji)
                        .font(.system(size: 28))
                        .frame(width: 36, height: 36)

                    Text("Hello, \(authManager.currentUser.displayName)!")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundStyle(.white.opacity(0.85))
                    
                    Spacer()
                }
                
                Text(totalBalance, format: .currency(code: "USD"))
                    .font(.system(size: 36, weight: .bold))
                    .foregroundStyle(.white)
                    .contentTransition(.numericText())
                
                HStack {
                    HStack(spacing: 4) {
                        Image(systemName: "arrow.up.circle.fill")
                            .font(.system(size: 14))
                            .foregroundStyle(Color.primaryGreen)
                        Text(totalIncome, format: .currency(code: "USD"))
                            .font(.system(size: 14, weight: .medium))
                            .foregroundStyle(Color.primaryGreen)
                    }
                    
                    Spacer()
                    
                    HStack(spacing: 4) {
                        Image(systemName: "arrow.down.circle.fill")
                            .font(.system(size: 14))
                            .foregroundStyle(.red.opacity(0.8))
                        Text(totalExpenses, format: .currency(code: "USD"))
                            .font(.system(size: 14, weight: .medium))
                            .foregroundStyle(.red.opacity(0.8))
                    }
                }
            }
            .padding(24)
        }
        .padding(.horizontal)
    }
    
    // MARK: - Quick Stats
    
    private var quickStats: some View {
        HStack(spacing: 12) {
            miniStatCard(
                icon: "target",
                value: "\(goals.count)",
                label: "Goals",
                color: Color.primaryBlue
            )
            miniStatCard(
                icon: "checkmark.circle.fill",
                value: "\(goals.filter { $0.isCompleted }.count)",
                label: "Done",
                color: Color.primaryGreen
            )
            miniStatCard(
                icon: "person.2.fill",
                value: "\(goals.filter { $0.isGroup }.count)",
                label: "Groups",
                color: Color.primaryBlue
            )
        }
        .padding(.horizontal)
    }
    
    private func miniStatCard(icon: String, value: String, label: String, color: Color) -> some View {
        VStack(spacing: 6) {
            Image(systemName: icon)
                .font(.system(size: 18, weight: .medium))
                .foregroundStyle(color)
            Text(value)
                .font(.system(size: 18, weight: .bold))
                .foregroundStyle(.white)
            Text(label)
                .font(.system(size: 11))
                .foregroundStyle(.white.opacity(0.45))
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 14)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white.opacity(0.05))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.white.opacity(0.06), lineWidth: 1)
                )
        )
    }
    
    // MARK: - Goals Section
    
    private var goalsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Goals")
                    .foregroundStyle(.white)
                    .font(.system(size: 17, weight: .semibold))
                Spacer()
            }
            .padding(.horizontal)
            
            if goals.isEmpty {
                emptyCard(icon: "flag.fill", text: "No goals yet", sub: "Tap + to create your first goal")
            } else {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach(goals) { goal in
                            GoalView(goal: goal, compact: true)
                        }
                    }
                    .padding(.horizontal)
                }
            }
        }
    }
    
    // MARK: - Wallet Section
    
    private var walletSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Recent Transactions")
                    .foregroundStyle(.white)
                    .font(.system(size: 17, weight: .semibold))
                Spacer()
            }
            .padding(.horizontal)

            if wallets.isEmpty {
                emptyCard(icon: "creditcard.fill", text: "No transactions yet", sub: "Tap the wallet icon to add one")
            } else {
                VStack(spacing: 6) {
                    ForEach(wallets.prefix(5)) { wallet in
                        WalletView(wallet: wallet)
                    }
                }
                .padding(.horizontal)
            }
        }
    }
    
    private func emptyCard(icon: String, text: String, sub: String) -> some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 28))
                .foregroundStyle(.white.opacity(0.2))
            Text(text)
                .font(.system(size: 14, weight: .medium))
                .foregroundStyle(.white.opacity(0.4))
            Text(sub)
                .font(.system(size: 12))
                .foregroundStyle(.white.opacity(0.25))
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 28)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white.opacity(0.03))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.white.opacity(0.05), lineWidth: 1)
                )
        )
        .padding(.horizontal)
    }
}

#Preview {
    @Previewable @State var goals: [Goal] = []
    @Previewable @State var wallets: [Wallet] = []
    Home(goals: $goals, wallets: $wallets, authManager: AuthManager.shared)
}
