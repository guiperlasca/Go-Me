import Foundation
import SwiftUI
import CurrencyField

struct AddWallet: View {
    
    @Binding var wallets: [Wallet]
    @Environment(\.dismiss) var dismiss
    
    @State var name: String = ""
    @State var money: Decimal = 0
    @State private var moneyDecimal: Int = 0
    @State var isExpense: Bool = true
    @State var category: Category?
    @State var date = Date()
    
    private let fieldBackground = Color(white: 0.17)
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    
                    Picker("Type", selection: $isExpense) {
                        Text("Expense").tag(true)
                        Text("Income").tag(false)
                    }
                    .pickerStyle(.segmented)
                    .padding(.horizontal)
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text(isExpense ? "Expense Name" : "Income Name")
                            .font(.system(.subheadline, weight: .semibold))
                            .padding(.horizontal)
                            .foregroundStyle(.white)
                        
                        TextField(
                            isExpense ? "Your expense name here" : "Your income name here",
                            text: $name
                        )
                        .padding(.vertical, 12)
                        .padding(.horizontal)
                        .background(RoundedRectangle(cornerRadius: 16).foregroundStyle(fieldBackground))
                    }
                    .padding(.horizontal)
                    
                    HStack {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Amount")
                                .font(.system(.subheadline, weight: .semibold))
                                .padding(.horizontal)
                                .foregroundStyle(.white)
                            
                            CurrencyField(value: $moneyDecimal)
                                .keyboardType(.decimalPad)
                                .padding(.vertical, 16)
                                .padding(.horizontal, 36)
                                .foregroundStyle(.white.opacity(0.8))
                                .background(RoundedRectangle(cornerRadius: 16).foregroundStyle(fieldBackground))
                        }
                        .padding(.horizontal)
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Deadline")
                                .font(.system(.subheadline, weight: .bold))
                                .padding(.horizontal, 4)
                            
                            HStack(spacing: 12) {
                                DatePicker(
                                    "",
                                    selection: $date,
                                    displayedComponents: [.date]
                                )
                                .labelsHidden()
                                .padding(.vertical, 10)
                                .padding(.horizontal, 8)
                                .background(
                                    RoundedRectangle(cornerRadius: 16)
                                        .foregroundStyle(fieldBackground)
                                )
                            }
                        }
                    }
                            HStack(spacing: 12) {
                                Image(systemName: category?.imageName ?? "list.bullet")
                                    .foregroundStyle(.white)
                                    .frame(width: 30, height: 30)
                                    .background(RoundedRectangle(cornerRadius: 7).foregroundStyle(fieldBackground))
                                
                                Text("Category")
                                    .foregroundStyle(.white)
                                    .padding(.vertical, 11)
                                
                                Spacer()
                                
                                Menu {
                                    ForEach(Category.allCases) { cat in
                                        Button(cat.rawValue, systemImage: cat.imageName) {
                                            self.category = cat
                                        }
                                    }
                                } label: {
                                    HStack {
                                        Text(category?.rawValue ?? "Select")
                                        Image(systemName: "chevron.up.chevron.down")
                                    }
                                    .foregroundStyle(Color.primaryBlue)
                                }
                            }
                        
                        .background(Color.blackBox.ignoresSafeArea())
                        .navigationTitle("New Transaction")
                        .preferredColorScheme(.dark)
                        .navigationBarTitleDisplayMode(.inline)
                        .toolbar {
                            ToolbarItem(placement: .topBarLeading) {
                                Button("Cancel", systemImage: "xmark") { dismiss() }
                            }
                            ToolbarItem(placement: .topBarTrailing) {
                                Button("Add", systemImage: "checkmark") {
                                    guard let cat = category, !name.isEmpty else { return }
                                    let w = Wallet(name: name, money: NSDecimalNumber(decimal: Decimal(moneyDecimal)).doubleValue, date: date, isExpense: isExpense, category: cat)
                                    wallets.append(w)
                                    dismiss()
                                }
                                .buttonStyle(.borderedProminent)
                                .tint(
                                    LinearGradient(
                                        colors: [.primaryBlue, .primaryGreen],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                            }
                        }
                    }
                }
            }
    }
}

#Preview {
    @Previewable @State var wallets: [Wallet] = []
    return AddWallet(wallets: $wallets)
}
