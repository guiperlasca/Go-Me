import Foundation
import SwiftUI

struct AddWallet: View {

    @Binding var wallets: [Wallet]
    @Environment(\.dismiss) var dismiss

    @State var name: String = ""
    @State var isExpense: Bool = true
    @State var category: Category?
    @State var date = Date()
    @State private var moneyAmount: Double = 0

    private let fieldBackground = Color(white: 0.17)

    // Accent color muda conforme o tipo
    private var accentColor: Color {
        isExpense ? Color.primaryBlue : Color.primaryGreen
    }

    var body: some View {
        ZStack {
            Color.blackBox.ignoresSafeArea()

            VStack(spacing: 0) {
                // MARK: - Top Bar
                topBar
                    .padding(.top, 10)
                    .padding(.horizontal, 22)
                    .padding(.bottom, 28)

                ScrollView(showsIndicators: false) {
                    VStack(spacing: 16) {

                        // MARK: - Segmented Picker
                        Picker("Type", selection: $isExpense) {
                            Text("Expenses").tag(true)
                            Text("Received").tag(false)
                        }
                        .pickerStyle(.segmented)
                        .padding(.horizontal, 22)
                        .onChange(of: isExpense) { _, _ in
                            // Limpa campos ao trocar de tipo
                            name = ""
                            category = nil
                            moneyAmount = 0
                            date = Date()
                        }

                        // MARK: - Category Row
                        HStack(spacing: 12) {
                            Image(systemName: category?.imageName ?? "list.bullet")
                                .foregroundStyle(.white)
                                .frame(width: 32, height: 32)
                                .background(
                                    RoundedRectangle(cornerRadius: 8)
                                        .foregroundStyle(accentColor)
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

                        // MARK: - Name Field
                        TextField(isExpense ? "Expense name" : "Income name", text: $name)
                            .foregroundStyle(.white)
                            .padding(.horizontal, 18)
                            .frame(height: 56)
                            .background(Capsule().fill(fieldBackground))
                            .padding(.horizontal, 22)

                        // MARK: - Date + Amount Row
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Date")
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

                                TextField("$ 0,00", value: $moneyAmount, format: .currency(code: "USD"))
                                    .keyboardType(.decimalPad)
                                    .foregroundStyle(.white.opacity(0.8))
                                    .multilineTextAlignment(.center)
                                    .padding(.horizontal, 16)
                                    .frame(height: 56)
                                    .frame(maxWidth: .infinity)
                                    .background(Capsule().fill(fieldBackground))
                            }
                            .padding(.horizontal, 22)
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
                    .glassEffect(in: .circle)
            }

            Spacer()

            Text("Add Wallet")
                .font(.system(size: 28, weight: .bold))
                .foregroundStyle(.white)

            Spacer()

            Button {
                guard let cat = category, !name.isEmpty else { return }
                let w = Wallet(
                    name: name,
                    money: moneyAmount,
                    date: date,
                    isExpense: isExpense,
                    category: cat
                )
                wallets.append(w)
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
    return AddWallet(wallets: $wallets)
}
