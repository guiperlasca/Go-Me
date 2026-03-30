import Foundation
import SwiftUI
import SwiftData

struct AddWallet: View {
    
    @Environment(\.modelContext) var modelContext
    @Environment(\.dismiss) var dismiss
    
    @State var name: String = ""
    @State var money: Double = 0
    @State var isExpense: Bool = true
    @State var category: Category?
    @State var date = Date()
    
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
                        .background(
                            RoundedRectangle(cornerRadius: 26)
                                .foregroundStyle(.blackBox))
                        
                    }
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Amount")
                        .font(.system(.subheadline, weight: .semibold))
                        .padding(.horizontal)
                        .foregroundStyle(.white)
                    
                    TextField("0.00", value: $money, format: .currency(code: "BRL"))
                        .keyboardType(.decimalPad)
                        .padding(.vertical, 12)
                        .padding(.horizontal)
                        .foregroundStyle(.white.opacity(0.8))
                        .background(
                            RoundedRectangle(cornerRadius: 26)
                                .foregroundStyle(.blackBox)
                            
                        )
                }
                
                HStack(spacing: 12) {
                    Image(systemName: "list.bullet")
                        .foregroundStyle(.darkBackground)
                        .frame(width: 30, height: 30)
                        .background(
                            RoundedRectangle(cornerRadius: 7)
                        )
                    Text("Category")
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
                    }
                }
                .padding(.horizontal)
                .background(
                    RoundedRectangle(cornerRadius: 26)
                        .foregroundStyle(.blackBox)
                )
                
                DatePicker("Date", selection: $date, displayedComponents: [.date])
                    .datePickerStyle(.graphical)
                    .padding(.horizontal)
                
            }
            .padding(.horizontal)
            .padding(.top, 20)
        }
        .background(.darkBackground)
        .navigationTitle("New Wallet Addition")
        .preferredColorScheme(.dark)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button("Cancel", systemImage: "xmark") {
                    dismiss()
                }
            }
            
            ToolbarItem(placement: .topBarTrailing) {
                
                Button("Add", systemImage: "checkmark") {
                    if let category, !name.isEmpty {
                        let adjustedMoney = isExpense ? -abs(money) : abs(money)
                        let newWallet = Wallet(
                            name: name,
                            money: adjustedMoney,
                            date: date,
                            isExpense: isExpense,
                            category: category
                        )
                        modelContext.insert(newWallet)
                        try? modelContext.save()
                        dismiss()
                    }
                }
                .buttonStyle(.borderedProminent)
                .tint(
                    LinearGradient(
                        colors: [.primaryBlue, .primaryGreen],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ))
            }
        }
    }
}
#Preview {
    NavigationStack {
        AddWallet()
    }
}
