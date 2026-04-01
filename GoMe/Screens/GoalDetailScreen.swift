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
    @State private var isEditing = false

    private let fieldBackground = Color(white: 0.17)

    private var goalShareURL: String {
        if goal.groupCode == nil {
            goal.groupCode = UUID().uuidString.prefix(6).uppercased()
        }
        return "Join my GoMe goal group! Open: gome://join?code=\(goal.groupCode!)"
    }

    var body: some View {
        ZStack {
            Color("DarkBackground").ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {
                    topBar
                        .padding(.top, 10)
                        .padding(.bottom, goal.isGroup ? 16 : 34)

                    // Group photo pinned to top center when isGroup
                    if goal.isGroup {
                        groupPhotoView
                            .padding(.bottom, 24)
                            .transition(.opacity.combined(with: .scale(scale: 0.85)))
                    }

                    form
                        .padding(.top, 6)
                }
                .padding(.horizontal, 22)
                .padding(.bottom, 120)
            }

            bottomButtons
        }
        .preferredColorScheme(.dark)
        .animation(.spring(response: 0.4, dampingFraction: 0.8), value: goal.isGroup)
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

    // MARK: - Top Bar

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

            // Pencil toggles editing mode; shows checkmark to confirm
            Button {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.75)) {
                    isEditing.toggle()
                }
                if !isEditing { onEdit() }
            } label: {
                Image(systemName: isEditing ? "checkmark" : "pencil")
                    .font(.system(size: 19, weight: .semibold))
                    .foregroundStyle(isEditing ? Color.green : .white)
                    .frame(width: 48, height: 48)
                    .glassEffect(in: .circle)
            }
        }
    }

    // MARK: - Group Photo (top center)

    private var groupPhotoView: some View {
        PhotosPicker(
            selection: isEditing ? $selectedPhotoItem : .constant(nil),
            matching: .images
        ) {
            ZStack(alignment: .bottomTrailing) {
                if let selectedImage {
                    selectedImage
                        .resizable()
                        .scaledToFill()
                        .frame(width: 90, height: 90)
                        .clipShape(Circle())
                        .overlay(Circle().stroke(Color.white.opacity(0.2), lineWidth: 1.5))
                } else {
                    Circle()
                        .fill(fieldBackground)
                        .frame(width: 90, height: 90)
                        .overlay(Circle().stroke(Color.white.opacity(0.12), lineWidth: 1))
                        .overlay {
                            Image(systemName: "person.2")
                                .font(.system(size: 28))
                                .foregroundStyle(Color.white.opacity(0.5))
                        }
                }

                if isEditing {
                    Circle()
                        .fill(Color.primaryBlue)
                        .frame(width: 28, height: 28)
                        .overlay {
                            Image(systemName: "photo.badge.plus")
                                .font(.system(size: 13, weight: .semibold))
                                .foregroundStyle(.white)
                        }
                        .offset(x: 2, y: 2)
                }
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
        .frame(maxWidth: .infinity)
    }

    // MARK: - Form

    private var form: some View {
        VStack(alignment: .leading, spacing: 18) {
            categoryRow

            TextField("Goal name", text: $goal.name)
                .font(.system(size: 18, weight: .regular))
                .foregroundStyle(.white)
                .padding(.horizontal, 18)
                .frame(height: 64)
                .background(inputBackground())
                .disabled(!isEditing)
                .opacity(isEditing ? 1 : 0.75)

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
                    .disabled(!isEditing)
                    .opacity(isEditing ? 1 : 0.75)

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
                    .disabled(!isEditing)
                    .opacity(isEditing ? 1 : 0.75)
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
                    .frame(minHeight: 72)
                    .font(.system(size: 18))
                    .foregroundStyle(.white)
                    .background(inputBackground())
                    .disabled(!isEditing)
                    .opacity(isEditing ? 1 : 0.75)
            }

            // Shared goal toggle — same pattern as AddGoal
            Toggle(isOn: $goal.isGroup) {
                Text("Shared goal")
                    .font(.system(size: 18, weight: .regular))
                    .foregroundStyle(.white)
            }
            .tint(.green)
            .padding(.horizontal, 18)
            .frame(height: 66)
            .background(inputBackground())
            .disabled(!isEditing)
        }
    }

    // MARK: - Category Row

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

            if isEditing {
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
                .transition(.opacity.combined(with: .scale(scale: 0.9, anchor: .trailing)))
            }
        }
        .padding(.horizontal, 18)
        .frame(height: 64)
        .background(inputBackground())
        .animation(.spring(response: 0.3, dampingFraction: 0.8), value: isEditing)
    }

    // MARK: - Bottom Buttons (Trash + Share side by side)

    private var bottomButtons: some View {
        VStack {
            Spacer()
            HStack(alignment: .center) {
                Spacer()

                if goal.isGroup {
                    ShareLink(item: goalShareURL) {
                        HStack(spacing: 8) {
                            Image(systemName: "link")
                                .font(.system(size: 15, weight: .semibold))
                            Text("Share")
                                .font(.system(size: 15, weight: .semibold))
                        }
                        .foregroundStyle(.white)
                        .padding(.horizontal, 20)
                        .frame(height: 56)
                        .background(
                            Capsule()
                                .fill(Color.white.opacity(0.08))
                                .overlay(Capsule().stroke(Color.white.opacity(0.12), lineWidth: 1))
                        )
                    }
                    .transition(.opacity.combined(with: .move(edge: .trailing)))
                    .padding(.trailing, 10)
                }

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
        .animation(.spring(response: 0.4, dampingFraction: 0.8), value: goal.isGroup)
    }

    // MARK: - Helpers

    private func inputBackground(_ radius: CGFloat = 22) -> some View {
        RoundedRectangle(cornerRadius: radius, style: .continuous)
            .fill(Color.white.opacity(0.065))
            .overlay {
                RoundedRectangle(cornerRadius: radius, style: .continuous)
                    .stroke(Color.white.opacity(0.035), lineWidth: 1)
            }
    }
}

// MARK: - Preview

#Preview {
    @Previewable @State var sampleGoal: Goal = {
        let goal = Goal(name: "TV 4K", details: "TV 4k 75\"", category: .eletronics)
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
