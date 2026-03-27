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
    @State private var scanner: Bool = false
    
    var totalBalance: Double {
        wallets.reduce(0) { $0 + $1.money }
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    
                    ZStack {
                        RoundedRectangle(cornerRadius: 24)
                            .fill(
                                LinearGradient(
                                    colors: [.primaryBlue, .primaryGreen],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(height: 180)
                        
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Image("profile-picture")
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 48, height: 48)
                                    .clipShape(Circle())
                                
                                Text("Hello user!")
                                    .font(.headline)
                                    .foregroundStyle(.white)
                                
                                Spacer()
                            }
                            
                            Spacer()
                            
                            HStack{
                                VStack (alignment: .leading) {
                                Text("Todal Balance")
                                    .font(.subheadline)
                                    .foregroundStyle(.white.opacity(0.8))
                                    Spacer()
                                Text(totalBalance, format: .currency(code: "BRL"))
                                    .font(.system(.title, weight: .bold))
                                    .foregroundStyle(.white)
                            }
                            .padding()
                                VStack {
                                    Text("Monthy expenses")
                                        .foregroundStyle(.white.opacity(0.8))
                                }
                            }
                        }
                        .padding(20)
                    }
                    .padding(.horizontal)
                
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Text("Goals")
                                .foregroundStyle(.white)
                                .font(.system(.title3, weight: .semibold))
                                Spacer()
                            Image(systemName: "chevron.right")
                                .foregroundStyle(.white)
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
                                        GoalView(goal: goal)
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
                    
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Text("Wallet")
                                .foregroundStyle(.white)
                                .font(.system(.title3, weight: .semibold))
                                Spacer()
                            Image(systemName: "chevron.right")
                                .foregroundStyle(.white)
                        }
                        .padding(.horizontal)

                        if wallets.isEmpty {
                            Text("No expenses/incomes yet.")
                                .foregroundStyle(.secondary)
                                .padding(.horizontal)
                        } else {
                            VStack(spacing: 10) {
                                ForEach(wallets) { wallet in
                                    WalletView(wallet: wallet)
                                        .padding(.horizontal)
                                        .swipeActions(edge: .trailing) {
                                            Button("Deletar", systemImage: "trash", role: .destructive) {
                                                wallets.removeAll { $0.id == wallet.id }
                                            }
                                        }
                                }
                            }
                        }
                    }
                }
                .padding(.vertical)
            }
            .background(.darkBackground)
            .navigationTitle("Home")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItemGroup(placement: .topBarTrailing) {
                    Button("AddGoal", systemImage: "plus") {
                        addGoal = true
                    }
                    Button("AddWallet", systemImage: "creditcard") {
                        addWallet = true
                    }
                }
            }
            .sheet(isPresented: $addGoal) {
                AddGoal()
                    .presentationDragIndicator(.visible)
            }
//            .sheet(isPresented: $addWallet) {
//                AddWallet()
//                    .presentationDragIndicator(.visible)
//            }
        }
    }
}

#Preview {
    Home()
}
