import SwiftUI

struct GoalDetailScreen: View {
    @Binding var goal: Goal

    var onDelete: () -> Void
    var onEdit: () -> Void = {}
    var onShareEnabled: () -> Void = {}

    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ZStack {
            Color.blackBox.ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {
                    topBar
                        .padding(.top, 10)
                        .padding(.bottom, 34)

                    form
                        .padding(.top, 6)

                    deleteButton
                        .padding(.top, 56)
                        .padding(.bottom, 28)
                }
                .padding(.horizontal, 22)
            }
        }
        .preferredColorScheme(.dark)
        .onChange(of: goal.isGroup) { oldValue, newValue in
            if newValue && !oldValue {
                onShareEnabled()
            }
        }
    }

    private var topBar: some View {
        HStack {
            Button {
                dismiss()
            } label: {
                Image(systemName: "chevron.left")
                    .font(.system(size: 20, weight: .medium))
                    .foregroundStyle(.white)
                    .frame(width: 48, height: 48)
                    .glassEffect(in: .circle)
            }

            Spacer()

            HStack(spacing: 12) {
                Image(systemName: headerSymbol)
                    .font(.system(size: 32, weight: .regular))
                
                Text(goal.name.isEmpty ? "Goal" : goal.name)
                    .font(.system(size: 28, weight: .medium, design: .rounded))
                    .lineLimit(1)
                    .minimumScaleFactor(0.7)
            }
            .foregroundStyle(.white)

            Spacer()

            Button {
                onEdit()
            } label: {
                Image(systemName: "pencil")
                    .font(.system(size: 19, weight: .semibold))
                    .foregroundStyle(.white)
                    .frame(width: 48, height: 48)
                    .glassEffect(in: .circle)
            }
        }
    }

    private var form: some View {
        VStack(alignment: .leading, spacing: 18) {
            categoryRow

            TextField("Goal name", text: $goal.name)
                .font(.system(size: 18, weight: .regular))
                .foregroundStyle(.white)
                .padding(.horizontal, 18)
                .frame(height: 64)
                .background(inputBackground())

            VStack(alignment: .leading, spacing: 12) {
                Text("Deadline")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(.white)

                HStack(spacing: 14) {
                    DatePicker(
                        "",
                        selection: Binding(
                            get: { goal.endDate ?? Date() },
                            set: { goal.endDate = $0 }
                        ),
                        displayedComponents: .date
                    )
                    .labelsHidden()
                    .datePickerStyle(.compact)
                    .colorScheme(.dark)
                    .tint(.white)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 18)
                    .frame(height: 64)
                    .background(inputBackground())

                    TextField(
                        "$ 0",
                        value: $goal.money,
                        format: .currency(code: "USD")
                    )
                    .keyboardType(.decimalPad)
                    .font(.system(size: 19, weight: .bold))
                    .foregroundStyle(.white)
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: .infinity)
                    .frame(height: 64)
                    .background(inputBackground())
                }
            }

            VStack(alignment: .leading, spacing: 12) {
                Text("Description")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(.white)

                TextEditor(text: $goal.details)
                    .scrollContentBackground(.hidden)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 12)
                    .frame(minHeight: 120)
                    .font(.system(size: 18))
                    .foregroundStyle(.white)
                    .background(inputBackground())
            }

            VStack(spacing: 16) {
                HStack {
                    Text("Shared goal")
                        .font(.system(size: 18, weight: .regular))
                        .foregroundStyle(.white)

                    Spacer()

                    Toggle("", isOn: $goal.isGroup)
                        .labelsHidden()
                        .toggleStyle(DarkKnobToggleStyle())
                }
                .padding(.horizontal, 18)
                .frame(height: 66)
                .background(inputBackground())
                
                if goal.isGroup {
                    HStack {
                        HStack(spacing: -14) {
                            ForEach(0..<3) { _ in
                                Image(systemName: "person.circle.fill")
                                    .resizable()
                                    .frame(width: 42, height: 42)
                                    .foregroundStyle(Color.primaryBlue, .white.opacity(0.1))
                                    .background(Circle().fill(Color.blackBox))
                                    .overlay(Circle().stroke(Color.blackBox, lineWidth: 2))
                            }
                        }
                        
                        Spacer()
                        
                        Button {
                            onShareEnabled()
                        } label: {
                            HStack(spacing: 8) {
                                Text("Share")
                                    .font(.system(size: 16, weight: .medium))
                                Image(systemName: "square.and.arrow.up")
                                    .font(.system(size: 16, weight: .medium))
                            }
                            .foregroundStyle(.white)
                            .padding(.horizontal, 20)
                            .frame(height: 48)
                            .glassEffect(in: Capsule())
                        }
                    }
                    .padding(.horizontal, 10)
                    .padding(.top, 4)
                    .transition(.opacity.combined(with: .move(edge: .top)))
                }
            }
            .animation(.spring(response: 0.35, dampingFraction: 0.8), value: goal.isGroup)
        }
    }

    private var categoryRow: some View {
        HStack(spacing: 10) {
            Label {
                Text(goal.category.rawValue)
                    .font(.system(size: 18, weight: .regular))
            } icon: {
                Image(systemName: goal.category.imageName)
                    .font(.system(size: 19, weight: .medium))
            }
            .foregroundStyle(Color.primaryBlue)

            Spacer()

            Menu {
                ForEach(Category.allCases) { category in
                    Button(category.rawValue, systemImage: category.imageName) {
                        goal.category = category
                    }
                }
            } label: {
                HStack(spacing: 6) {
                    Text("Select")
                        .font(.system(size: 18, weight: .medium))
                    Image(systemName: "chevron.up.chevron.down")
                        .font(.system(size: 13, weight: .semibold))
                }
                .foregroundStyle(Color.primaryBlue)
            }
        }
        .padding(.horizontal, 18)
        .frame(height: 64)
        .background(inputBackground())
    }

    private var deleteButton: some View {
        Button {
            onDelete()
            dismiss()
        } label: {
            Text("Delete")
                .font(.system(size: 21, weight: .medium))
                .foregroundStyle(.white)
                .frame(width: 210, height: 58)
                .glassEffect(in: Capsule())
        }
        .frame(maxWidth: .infinity)
    }

    private var headerSymbol: String {
        switch goal.name.trimmingCharacters(in: .whitespacesAndNewlines).lowercased() {
        case "tv", "televisao", "televisão", "television":
            return "tv"
        default:
            return goal.category.imageName
        }
    }

    private func inputBackground(_ radius: CGFloat = 22) -> some View {
        RoundedRectangle(cornerRadius: radius, style: .continuous)
            .fill(Color.white.opacity(0.065))
            .overlay {
                RoundedRectangle(cornerRadius: radius, style: .continuous)
                    .stroke(Color.white.opacity(0.035), lineWidth: 1)
            }
    }
}

struct DarkKnobToggleStyle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        Button {
            withAnimation(.spring(response: 0.28, dampingFraction: 0.85)) {
                configuration.isOn.toggle()
            }
        } label: {
            Capsule(style: .continuous)
                .fill(Color.white.opacity(0.06))
                .frame(width: 78, height: 42)
                .overlay(alignment: configuration.isOn ? .trailing : .leading) {
                    Circle()
                        .fill(.white)
                        .frame(width: 34, height: 34)
                        .padding(4)
                }
        }
        .buttonStyle(.plain)
        .accessibilityLabel(configuration.isOn ? "Shared goal enabled" : "Shared goal disabled")
    }
}

#Preview {
    @Previewable @State var sampleGoal: Goal = {
        let goal = Goal(name: "TV", details: "Tv 4k 75\"", category: .eletronics)
        goal.money = 675.0
        
        var dateComponents = DateComponents()
        dateComponents.year = 2025
        dateComponents.month = 4
        dateComponents.day = 1
        goal.endDate = Calendar.current.date(from: dateComponents)
        
        goal.isGroup = true
        return goal
    }()
    
    return NavigationStack {
        GoalDetailScreen(
            goal: $sampleGoal,
            onDelete: {},
            onEdit: {},
            onShareEnabled: {}
        )
    }
}
