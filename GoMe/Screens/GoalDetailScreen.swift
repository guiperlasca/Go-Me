import SwiftUI
import PhotosUI

struct GoalDetailScreen: View {
    @Binding var goal: Goal

    var onDelete: () -> Void
    var onEdit: () -> Void = {}
    var onShareEnabled: () -> Void = {}

    @Environment(\.dismiss) private var dismiss

    @State private var selectedPhotoItem: PhotosPickerItem? = nil
    @State private var selectedImage: Image? = nil

    private let fieldBackground = Color(white: 0.17)

    private var goalShareURL: String {
        if goal.groupCode == nil {
            goal.groupCode = UUID().uuidString.prefix(6).uppercased()
        }
        return "Join my GoMe goal group! Open: gome://join?code=\(goal.groupCode!)"
    }

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
                }
                .padding(.horizontal, 22)
                .padding(.bottom, 100)
            }

            trashButton
        }
        .preferredColorScheme(.dark)
        .onChange(of: goal.isGroup) { oldValue, newValue in
            if newValue && !oldValue {
                onShareEnabled()
            }
        }
        .onAppear {
            if let data = goal.groupImageData,
               let uiImage = UIImage(data: data) {
                selectedImage = Image(uiImage: uiImage)
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
                Image(systemName: goal.category.imageName)
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
            .padding(14)
            .background(
                RoundedRectangle(cornerRadius: 22, style: .continuous)
                    .fill(Color.white.opacity(0.03))
            )
            .overlay {
                RoundedRectangle(cornerRadius: 22, style: .continuous)
                    .stroke(Color.primaryBlue, lineWidth: 1.5)
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
                    VStack(spacing: 16) {
                        PhotosPicker(selection: $selectedPhotoItem, matching: .images) {
                            if let selectedImage {
                                selectedImage
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 72, height: 72)
                                    .clipShape(Circle())
                                    .overlay(Circle().stroke(Color.white.opacity(0.15), lineWidth: 1))
                            } else {
                                Image(systemName: "photo.badge.plus")
                                    .font(.system(size: 26))
                                    .foregroundStyle(.white)
                                    .frame(width: 72, height: 72)
                                    .background(
                                        Circle()
                                            .fill(fieldBackground)
                                            .overlay(Circle().stroke(Color.white.opacity(0.15), lineWidth: 1))
                                    )
                            }
                        }
                        .onChange(of: selectedPhotoItem) { newItem in
                            Task {
                                if let data = try? await newItem?.loadTransferable(type: Data.self),
                                   let uiImage = UIImage(data: data) {
                                    goal.groupImageData = data
                                    selectedImage = Image(uiImage: uiImage)
                                }
                            }
                        }

                        ShareLink(item: goalShareURL) {
                            HStack(spacing: 8) {
                                Image(systemName: "link")
                                    .font(.system(size: 16, weight: .semibold))
                                Text("Share")
                                    .font(.system(size: 16, weight: .semibold))
                            }
                            .foregroundStyle(.white)
                            .padding(.horizontal, 40)
                            .padding(.vertical, 14)
                            .background(
                                Capsule()
                                    .fill(fieldBackground)
                                    .overlay(Capsule().stroke(Color.white.opacity(0.15), lineWidth: 1))
                            )
                        }
                        .padding(.top, 16)
                    }
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


    private var trashButton: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                Button {
                    onDelete()
                    dismiss()
                } label: {
                    Image(systemName: "trash")
                        .font(.system(size: 20, weight: .medium))
                        .foregroundStyle(.white)
                        .frame(width: 56, height: 56)
                        .glassEffect(in: .circle)
                }
            }
        }
        .padding(.trailing, 26)
        .padding(.bottom, 30)
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
