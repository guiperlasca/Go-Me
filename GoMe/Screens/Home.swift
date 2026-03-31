//
//  Home.swift
//  GoMe
//
//  Created by Aluno-08 on 27/03/26.
//
import SwiftUI

struct Home: View {
    
    @State private var goals: [Goal] = []
    @State private var wallets: [Wallet] = []
    
    @State private var addGoal: Bool = false
    @State private var addWallet: Bool = false
    @State private var scanner: Bool = false
    
    var totalBalance: Double {
        wallets.reduce(0) { $0 + ($1.isExpense ? -$1.money : $1.money) }
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.blackBox.ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        
                        // MARK: - Custom Top Bar
                        HStack {
                            Text("GOMe")
                                .font(.system(size: 20, weight: .semibold))
                                .foregroundStyle(Color.primaryBlue)
                            
                            Spacer()
                            
                            HStack(spacing: 16) {
                                Button { addWallet = true } label: {
                                    Image(systemName: "wallet.bifold")
                                        .font(.system(size: 18, weight: .semibold))
                                        .foregroundStyle(.white)
                                }
                                Button { addGoal = true } label: {
                                    Image(systemName: "plus")
                                        .font(.system(size: 18, weight: .semibold))
                                        .foregroundStyle(.white)
                                }
                            }
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                            .background(
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(Color.white.opacity(0.08))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 20)
                                            .stroke(Color.white.opacity(0.15), lineWidth: 1)
                                    )
                            )
                        }
                        .padding(.horizontal)
                        
                        // MARK: - Balance Card
                        ZStack {
                            RoundedRectangle(cornerRadius: 24)
                                .fill(
                                    LinearGradient(
                                        colors: [Color.primaryBlue.opacity(0.4), Color.primaryGreen.opacity(0.3)],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .frame(height: 180)
                            
                            VStack(alignment: .leading, spacing: 16) {
                                HStack {
                                    Image(systemName: "person.circle.fill")
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 32, height: 32)
                                        .foregroundStyle(.white.opacity(0.8))

                                    Text("Hello, user!")
                                        .font(.subheadline)
                                        .fontWeight(.medium)
                                        .foregroundStyle(.white)
                                    
                                    Spacer()
                                }
                                
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(totalBalance, format: .currency(code: "USD"))
                                        .font(.system(size: 38, weight: .bold))
                                        .foregroundStyle(.white)
                                }
                                
                                HStack {
                                    Spacer()
                                    Text("-$0.00")
                                        .font(.system(size: 22, weight: .medium))
                                        .foregroundStyle(.white)
                                }
                            }
                            .padding(24)
                        }
                        .padding(.horizontal)
                    
                        // MARK: - Goals Section
                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                Text("Goals")
                                    .foregroundStyle(.white)
                                    .font(.system(size: 16, weight: .medium))
                                Spacer()
                                NavigationLink(destination: GoalsScreen(goals: $goals)) {
                                    Image(systemName: "chevron.right")
                                        .foregroundStyle(.white.opacity(0.6))
                                }
                            }
                            .padding(.horizontal)
                            
                            if goals.isEmpty {
                                Text("No goals added.")
                                    .foregroundStyle(.secondary)
                                    .padding(.horizontal)
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
                        
                        // MARK: - Wallet
                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                Text("Wallet")
                                    .foregroundStyle(.white)
                                    .font(.system(size: 16, weight: .medium))
                                Spacer()
                                NavigationLink(destination: WalletScreen(wallets: $wallets)) {
                                    Image(systemName: "chevron.right")
                                        .foregroundStyle(.white.opacity(0.6))
                                }
                            }
                            .padding(.horizontal)

                            if wallets.isEmpty {
                                Text("No expenses/incomes yet.")
                                    .foregroundStyle(.secondary)
                                    .padding(.horizontal)
                            } else {
                                VStack(spacing: 8) {
                                    ForEach(wallets) { wallet in
                                        WalletView(wallet: wallet)
                                    }
                                }
                                .padding(.horizontal)
                                
                                NavigationLink(destination: WalletScreen(wallets: $wallets)) {
                                    Text("View All")
                                        .font(.system(size: 15, weight: .semibold))
                                        .foregroundStyle(Color.primaryBlue)
                                        .padding(.vertical, 16)
                                        .frame(maxWidth: .infinity)
                                }
                            }
                        }
                    }
                    .padding(.vertical)
                }
            }
            .sheet(isPresented: $addGoal) {
                AddGoal(goals: $goals)
                    .presentationDragIndicator(.visible)
            }
            .sheet(isPresented: $addWallet) {
                AddWallet(wallets: $wallets)
                    .presentationDragIndicator(.visible)
            }
        }
    }
}

#Preview {
    Home()
}
