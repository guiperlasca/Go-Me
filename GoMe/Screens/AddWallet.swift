//
//  AddWallet.swift
//  GoMe
//

import Foundation
import SwiftUI

struct AddWallet: View {

    @Binding var wallets: [Wallet]
    @Binding var goals: [Goal]
    @Environment(\.dismiss) var dismiss

    @State var name: String = ""
    @State var isExpense: Bool = true
    @State var category: Category?
    @State var date = Date()
    @State private var moneyAmount: Double = 0
    @State private var linkedGoal: Goal? = nil

    private let fieldBackground = Color(white: 0.17)

    private var accentColor: Color {
        isExpense ? Color.primaryBlue : Color.primaryGreen
    }

    var body: some View {
        ZStack {
            Color.blackBox.ignoresSafeArea()

            VStack(spacing: 0) {
                topBar
                    .padding(.top, 10)
                    .padding(.horizontal, 22)
                    .padding(.bottom, 28)

                ScrollView(showsIndicators: false) {
                    VStack(spacing: 16) {

                        // MARK: - Type Picker
                        Picker("Type", selection: $isExpense) {
                            Text("Expense").tag(true)
                            Text("Income").tag(false)
                        }
                        .pickerStyle(.segmented)
                        .padding(.horizontal, 22)
                        .onChange(of: isExpense) { _, _ in
                            name = ""
                            category = nil
                            moneyAmount = 0
                            date = Date()
                            linkedGoal = nil
                        }

                        // MARK: - Category
                        HStack(spacing: 12) {
                            Image(systemName: category?.imageName ?? "list.bullet")
                                .foregroundStyle(.white)
                                .frame(width: 32, height: 32)
                                .background(
                                    RoundedRectangle(cornerRadius: 8)
                                        .fill(accentColor)
                                )

                            Text("Category")
                                .foregroundStyle(.white)

                            Spacer()

                            Menu {
                                ForEach(Category.allCases) { cat in
                                    Button(cat.rawValue, systemImage: cat.imageName) {
                                        self.category = cat
                                    }
                                }
                            } label: {
                                HStack(spacing: 4) {
                                    Text(category?.rawValue ?? "Select")
                                    Image(systemName: "chevron.up.chevron.down")
                                }
                                .foregroundStyle(accentColor)
                            }
                        }
                        .padding(.horizontal, 16)
                        .frame(height: 56)
                        .background(Capsule().fill(fieldBackground))
                        .padding(.horizontal, 22)

                        // MARK: - Name
                        TextField(isExpense ? "Expense name" : "Income name", text: $name)
                            .foregroundStyle(.white)
                            .padding(.horizontal, 18)
                            .frame(height: 56)
                            .background(Capsule().fill(fieldBackground))
                            .padding(.horizontal, 22)

                        // MARK: - Date + Amount
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Date & Amount")
                                .font(.system(size: 16, weight: .bold))
                                .foregroundStyle(.white)
                                .padding(.horizontal, 22)

                            HStack(spacing: 12) {
                                DatePicker("", selection: $date, displayedComponents: [.date])
                                    .labelsHidden()
                                    .colorScheme(.dark)
                                    .padding(.horizontal, 16)
                                    .frame(height: 56)
                                    .frame(maxWidth: .infinity)
                                    .background(Capsule().fill(fieldBackground))

                                TextField("$0.00", value: $moneyAmount, format: .currency(code: "USD"))
                                    .keyboardType(.decimalPad)
                                    .foregroundStyle(.white.opacity(0.9))
                                    .font(.system(size: 17, weight: .semibold))
                                    .multilineTextAlignment(.center)
                                    .padding(.horizontal, 16)
                                    .frame(height: 56)
                                    .frame(maxWidth: .infinity)
                                    .background(Capsule().fill(fieldBackground))
                            }
                            .padding(.horizontal, 22)
                        }
                        
                        // MARK: - Link to Goal
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Link to Goal")
                                .font(.system(size: 16, weight: .bold))
                                .foregroundStyle(.white)
                                .padding(.horizontal, 22)
                            
                            if goals.isEmpty {
                                Text("No goals available. Create one first.")
                                    .font(.system(size: 14))
                                    .foregroundStyle(.white.opacity(0.35))
                                    .padding(.horizontal, 22)
                            } else {
                                HStack(spacing: 12) {
                                    Image(systemName: "link")
                                        .foregroundStyle(.white.opacity(0.6))
                                        .frame(width: 32, height: 32)
                                    
                                    Text(linkedGoal?.name ?? "None")
                                        .foregroundStyle(.white.opacity(linkedGoal == nil ? 0.45 : 1))
                                    
                                    Spacer()
                                    
                                    Menu {
                                        Button("None") {
                                            linkedGoal = nil
                                        }
                                        ForEach(goals) { goal in
                                            Button {
                                                linkedGoal = goal
                                            } label: {
                                                Label(goal.name, systemImage: goal.category.imageName)
                                            }
                                        }
                                    } label: {
                                        HStack(spacing: 4) {
                                            Text("Select")
                                            Image(systemName: "chevron.up.chevron.down")
                                        }
                                        .font(.system(size: 14, weight: .semibold))
                                        .foregroundStyle(accentColor)
                                    }
                                }
                                .padding(.horizontal, 16)
                                .frame(height: 56)
                                .background(Capsule().fill(fieldBackground))
                                .padding(.horizontal, 22)
                                
                                if linkedGoal != nil {
                                    HStack(spacing: 6) {
                                        Image(systemName: "info.circle")
                                            .font(.system(size: 12))
                                        Text("This amount will count toward the goal's progress")
                                            .font(.system(size: 12))
                                    }
                                    .foregroundStyle(Color.primaryGreen.opacity(0.7))
                                    .padding(.horizontal, 26)
                                }
                            }
                        }
                    }
                    .padding(.bottom, 40)
                    .animation(.spring(response: 0.3, dampingFraction: 0.8), value: isExpense)
                }
            }
        }
        .preferredColorScheme(.dark)
    }

    // MARK: - Top Bar

    private var topBar: some View {
        HStack {
            Button { dismiss() } label: {
                Image(systemName: "xmark")
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundStyle(.white)
                    .frame(width: 48, height: 48)
                    .background(
                        Circle()
                            .fill(Color.white.opacity(0.1))
                            .overlay(Circle().stroke(Color.white.opacity(0.1), lineWidth: 1))
                    )
            }

            Spacer()

            Text("Add Transaction")
                .font(.system(size: 22, weight: .bold))
                .foregroundStyle(.white)

            Spacer()

            Button {
                guard let cat = category, !name.isEmpty, moneyAmount > 0 else { return }
                let w = Wallet(
                    name: name,
                    money: moneyAmount,
                    date: date,
                    isExpense: isExpense,
                    category: cat,
                    linkedGoalID: linkedGoal?.id
                )
                wallets.append(w)
                
                // Link to goal and recalculate
                if let goal = linkedGoal {
                    GoalCalculator.linkWallet(w, to: goal, wallets: wallets)
                }
                
                dismiss()
            } label: {
                Image(systemName: "checkmark")
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundStyle(.white)
                    .frame(width: 48, height: 48)
                    .background(Circle().fill(accentColor))
            }
        }
    }
}

#Preview {
    @Previewable @State var wallets: [Wallet] = []
    @Previewable @State var goals: [Goal] = [
        Goal(name: "TV 4K", details: "TV 75\"", category: .eletronics)
    ]
    return AddWallet(wallets: $wallets, goals: $goals)
}
