//
//  GoalDetailScreen.swift
//  GoMe
//

import SwiftUI
import PhotosUI

struct GoalDetailScreen: View {
    @Binding var goal: Goal
    var allWallets: [Wallet]
    var friends: [Friend]

    var onDelete: () -> Void
    var onEdit: () -> Void = {}

    @Environment(\.dismiss) private var dismiss

    @State private var selectedPhotoItem: PhotosPickerItem? = nil
    @State private var selectedImage: Image? = nil
    @State private var isEditing = false
    @State private var showMembersSheet = false

    private let fieldBackground = Color(white: 0.17)

    private var linkedWallets: [Wallet] {
        allWallets.filter { goal.linkedWalletIDs.contains($0.id) }
    }

    var body: some View {
        ZStack {
            Color("DarkBackground").ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {
                    topBar
                        .padding(.top, 10)
                        .padding(.bottom, goal.isGroup ? 16 : 24)

                    if goal.isGroup {
                        groupPhotoView
                            .padding(.bottom, 20)
                            .transition(.opacity.combined(with: .scale(scale: 0.85)))
                    }

                    // MARK: - Metrics Dashboard
                    metricsDashboard
                        .padding(.bottom, 20)

                    // MARK: - Progress Ring
                    progressSection
                        .padding(.bottom, 20)

                    form
                        .padding(.top, 6)

                    // MARK: - Members
                    if goal.isGroup {
                        membersSection
                            .padding(.top, 18)
                    }

                    // MARK: - Linked Transactions
                    if !linkedWallets.isEmpty {
                        linkedTransactionsSection
                            .padding(.top, 18)
                    }
                }
                .padding(.horizontal, 22)
                .padding(.bottom, 120)
            }

            bottomButtons
        }
        .preferredColorScheme(.dark)
        .animation(.spring(response: 0.4, dampingFraction: 0.8), value: goal.isGroup)
        .onAppear {
            if let data = goal.groupImageData,
               let uiImage = UIImage(data: data) {
                selectedImage = Image(uiImage: uiImage)
            }
        }
        .sheet(isPresented: $showMembersSheet) {
            AddMembersSheet(friends: friends, selectedMembers: $goal.members)
                .presentationDragIndicator(.visible)
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
                    .frame(width: 44, height: 44)
                    .background(
                        Circle()
                            .fill(Color.white.opacity(0.1))
                            .overlay(Circle().stroke(Color.white.opacity(0.1), lineWidth: 1))
                    )
            }

            Spacer()

            HStack(spacing: 10) {
                Image(systemName: goal.category.imageName)
                    .font(.system(size: 26, weight: .regular))

                Text(goal.name.isEmpty ? "Goal" : goal.name)
                    .font(.system(size: 24, weight: .bold, design: .rounded))
                    .lineLimit(1)
                    .minimumScaleFactor(0.7)
            }
            .foregroundStyle(.white)

            Spacer()

            Button {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.75)) {
                    isEditing.toggle()
                }
                if !isEditing { onEdit() }
            } label: {
                Image(systemName: isEditing ? "checkmark" : "pencil")
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundStyle(isEditing ? Color.primaryGreen : .white)
                    .frame(width: 44, height: 44)
                    .background(
                        Circle()
                            .fill(isEditing ? Color.primaryGreen.opacity(0.15) : Color.white.opacity(0.1))
                            .overlay(Circle().stroke(Color.white.opacity(0.1), lineWidth: 1))
                    )
            }
        }
    }

    // MARK: - Metrics Dashboard

    private var metricsDashboard: some View {
        let metrics = GoalCalculator.metrics(for: goal)

        return VStack(spacing: 12) {
            HStack(spacing: 12) {
                metricCard(
                    title: "Saved",
                    value: formatCurrency(metrics.saved),
                    color: Color.primaryGreen
                )
                metricCard(
                    title: "Remaining",
                    value: formatCurrency(metrics.remaining),
                    color: Color.primaryBlue
                )
            }

            HStack(spacing: 12) {
                metricCard(
                    title: "Progress",
                    value: String(format: "%.0f%%", metrics.percentComplete),
                    color: metrics.isCompleted ? Color.primaryGreen : Color.primaryBlue
                )
                metricCard(
                    title: "Days Left",
                    value: "\(metrics.daysLeft)",
                    color: metrics.daysLeft <= 7 ? .red : .white.opacity(0.7)
                )
            }

            if !metrics.isCompleted && metrics.daysLeft > 0 {
                HStack(spacing: 8) {
                    Image(systemName: "chart.line.uptrend.xyaxis")
                        .font(.system(size: 14))
                        .foregroundStyle(Color.primaryBlue)
                    Text("Save \(formatCurrency(metrics.dailySavingsNeeded))/day to reach your goal")
                        .font(.system(size: 13, weight: .medium))
                        .foregroundStyle(.white.opacity(0.6))
                }
                .padding(.horizontal, 14)
                .padding(.vertical, 10)
                .frame(maxWidth: .infinity)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.primaryBlue.opacity(0.08))
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.primaryBlue.opacity(0.15), lineWidth: 1)
                        )
                )
            }
        }
    }

    private func metricCard(title: String, value: String, color: Color) -> some View {
        VStack(spacing: 6) {
            Text(title)
                .font(.system(size: 12, weight: .medium))
                .foregroundStyle(.white.opacity(0.5))
            Text(value)
                .font(.system(size: 20, weight: .bold))
                .foregroundStyle(color)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 14)
        .background(
            RoundedRectangle(cornerRadius: 14)
                .fill(Color.white.opacity(0.05))
                .overlay(
                    RoundedRectangle(cornerRadius: 14)
                        .stroke(Color.white.opacity(0.06), lineWidth: 1)
                )
        )
    }

    // MARK: - Progress Section

    private var progressSection: some View {
        VStack(spacing: 10) {
            ZStack {
                Circle()
                    .stroke(Color.white.opacity(0.08), lineWidth: 8)
                    .frame(width: 100, height: 100)

                Circle()
                    .trim(from: 0, to: CGFloat(goal.progressValue))
                    .stroke(
                        goal.isCompleted ? Color.primaryGreen :
                            LinearGradient(colors: [Color.primaryBlue, Color.primaryGreen], startPoint: .leading, endPoint: .trailing),
                        style: StrokeStyle(lineWidth: 8, lineCap: .round)
                    )
                    .frame(width: 100, height: 100)
                    .rotationEffect(.degrees(-90))
                    .animation(.spring(response: 0.6), value: goal.progressValue)

                VStack(spacing: 2) {
                    Text(String(format: "%.0f%%", goal.progressValue * 100))
                        .font(.system(size: 22, weight: .bold))
                        .foregroundStyle(.white)
                    if goal.isCompleted {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.system(size: 14))
                            .foregroundStyle(Color.primaryGreen)
                    }
                }
            }

            Text("\(formatCurrency(goal.savedAmount)) of \(formatCurrency(goal.money))")
                .font(.system(size: 14, weight: .medium))
                .foregroundStyle(.white.opacity(0.6))
        }
        .frame(maxWidth: .infinity)
    }

    // MARK: - Group Photo

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
                        .frame(width: 80, height: 80)
                        .clipShape(Circle())
                        .overlay(Circle().stroke(Color.white.opacity(0.2), lineWidth: 1.5))
                } else {
                    Circle()
                        .fill(fieldBackground)
                        .frame(width: 80, height: 80)
                        .overlay(Circle().stroke(Color.white.opacity(0.12), lineWidth: 1))
                        .overlay {
                            Image(systemName: "person.2")
                                .font(.system(size: 24))
                                .foregroundStyle(Color.white.opacity(0.5))
                        }
                }

                if isEditing {
                    Circle()
                        .fill(Color.primaryBlue)
                        .frame(width: 24, height: 24)
                        .overlay {
                            Image(systemName: "photo.badge.plus")
                                .font(.system(size: 11, weight: .semibold))
                                .foregroundStyle(.white)
                        }
                        .offset(x: 2, y: 2)
                }
            }
        }
        .onChange(of: selectedPhotoItem) { _, newItem in
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
        VStack(alignment: .leading, spacing: 16) {
            categoryRow

            TextField("Goal name", text: $goal.name)
                .font(.system(size: 17))
                .foregroundStyle(.white)
                .padding(.horizontal, 16)
                .frame(height: 56)
                .background(inputBackground())
                .disabled(!isEditing)
                .opacity(isEditing ? 1 : 0.75)

            VStack(alignment: .leading, spacing: 10) {
                Text("Deadline & Target")
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundStyle(.white)

                HStack(spacing: 12) {
                    DatePicker(
                        "",
                        selection: Binding(
                            get: { goal.endDate ?? Date() },
                            set: { goal.endDate = $0 }
                        ),
                        displayedComponents: .date
                    )
                    .labelsHidden()
                    .colorScheme(.dark)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 16)
                    .frame(height: 56)
                    .background(inputBackground())
                    .disabled(!isEditing)
                    .opacity(isEditing ? 1 : 0.75)

                    TextField(
                        "$0.00",
                        value: $goal.money,
                        format: .currency(code: "USD")
                    )
                    .keyboardType(.decimalPad)
                    .font(.system(size: 17, weight: .bold))
                    .foregroundStyle(.white)
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: .infinity)
                    .frame(height: 56)
                    .background(inputBackground())
                    .disabled(!isEditing)
                    .opacity(isEditing ? 1 : 0.75)
                }
            }
            .padding(14)
            .background(
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .fill(Color.white.opacity(0.03))
            )
            .overlay {
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .stroke(Color.primaryBlue.opacity(0.3), lineWidth: 1)
            }

            VStack(alignment: .leading, spacing: 10) {
                Text("Description")
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundStyle(.white)

                TextEditor(text: $goal.details)
                    .scrollContentBackground(.hidden)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 10)
                    .frame(minHeight: 64)
                    .font(.system(size: 16))
                    .foregroundStyle(.white)
                    .background(inputBackground())
                    .disabled(!isEditing)
                    .opacity(isEditing ? 1 : 0.75)
            }

            Toggle(isOn: $goal.isGroup) {
                HStack(spacing: 10) {
                    Image(systemName: "person.2.fill")
                        .foregroundStyle(Color.primaryBlue)
                    Text("Shared goal")
                        .font(.system(size: 17))
                        .foregroundStyle(.white)
                }
            }
            .tint(Color.primaryGreen)
            .padding(.horizontal, 16)
            .frame(height: 56)
            .background(inputBackground())
            .disabled(!isEditing)
        }
    }

    // MARK: - Category Row

    private var categoryRow: some View {
        HStack(spacing: 10) {
            Label {
                Text(goal.category.rawValue)
                    .font(.system(size: 17))
            } icon: {
                Image(systemName: goal.category.imageName)
                    .font(.system(size: 18, weight: .medium))
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
                        Text("Change")
                            .font(.system(size: 15, weight: .medium))
                        Image(systemName: "chevron.up.chevron.down")
                            .font(.system(size: 12))
                    }
                    .foregroundStyle(Color.primaryBlue)
                }
                .transition(.opacity.combined(with: .scale(scale: 0.9, anchor: .trailing)))
            }
        }
        .padding(.horizontal, 16)
        .frame(height: 56)
        .background(inputBackground())
        .animation(.spring(response: 0.3), value: isEditing)
    }

    // MARK: - Members Section

    private var membersSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Members")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(.white)
                
                Text("(\(goal.members.count))")
                    .font(.system(size: 14))
                    .foregroundStyle(.white.opacity(0.4))

                Spacer()

                if isEditing {
                    Button {
                        showMembersSheet = true
                    } label: {
                        HStack(spacing: 4) {
                            Image(systemName: "person.badge.plus")
                                .font(.system(size: 13))
                            Text("Edit")
                                .font(.system(size: 14, weight: .semibold))
                        }
                        .foregroundStyle(Color.primaryBlue)
                    }
                }
            }

            if goal.members.isEmpty {
                Text("No members yet")
                    .font(.system(size: 13))
                    .foregroundStyle(.white.opacity(0.35))
            } else {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach(goal.members) { member in
                            VStack(spacing: 4) {
                                Text(member.avatarEmoji)
                                    .font(.system(size: 28))
                                    .frame(width: 46, height: 46)
                                    .background(
                                        Circle()
                                            .fill(Color.primaryBlue.opacity(0.12))
                                            .overlay(Circle().stroke(Color.white.opacity(0.1), lineWidth: 1))
                                    )
                                Text(member.name)
                                    .font(.system(size: 11))
                                    .foregroundStyle(.white.opacity(0.6))
                                    .lineLimit(1)
                            }
                            .frame(width: 56)
                        }
                    }
                }
            }
        }
        .padding(14)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white.opacity(0.04))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.white.opacity(0.06), lineWidth: 1)
                )
        )
    }

    // MARK: - Linked Transactions

    private var linkedTransactionsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Linked Transactions")
                .font(.system(size: 16, weight: .semibold))
                .foregroundStyle(.white)

            VStack(spacing: 6) {
                ForEach(linkedWallets) { wallet in
                    WalletView(wallet: wallet)
                }
            }
        }
    }

    // MARK: - Bottom Buttons

    private var bottomButtons: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                Button {
                    onDelete()
                    dismiss()
                } label: {
                    Image(systemName: "trash")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundStyle(.red.opacity(0.8))
                        .frame(width: 52, height: 52)
                        .background(
                            Circle()
                                .fill(Color.red.opacity(0.1))
                                .overlay(Circle().stroke(Color.red.opacity(0.2), lineWidth: 1))
                        )
                }
            }
        }
        .padding(.trailing, 24)
        .padding(.bottom, 30)
    }

    // MARK: - Helpers

    private func inputBackground(_ radius: CGFloat = 18) -> some View {
        RoundedRectangle(cornerRadius: radius, style: .continuous)
            .fill(Color.white.opacity(0.06))
            .overlay {
                RoundedRectangle(cornerRadius: radius, style: .continuous)
                    .stroke(Color.white.opacity(0.04), lineWidth: 1)
            }
    }

    private func formatCurrency(_ value: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "USD"
        formatter.maximumFractionDigits = 0
        return formatter.string(from: NSNumber(value: value)) ?? "$0"
    }
}

// MARK: - Preview

#Preview {
    @Previewable @State var sampleGoal: Goal = {
        let goal = Goal(name: "TV 4K", details: "TV 4k 75\"", category: .eletronics)
        goal.money = 675.0
        goal.savedAmount = 340
        goal.linkedWalletIDs = []

        var dateComponents = DateComponents()
        dateComponents.year = 2026
        dateComponents.month = 6
        dateComponents.day = 1
        goal.endDate = Calendar.current.date(from: dateComponents)

        goal.isGroup = true
        goal.members = [Friend.samples[0], Friend.samples[1]]
        return goal
    }()

    return NavigationStack {
        GoalDetailScreen(
            goal: $sampleGoal,
            allWallets: [],
            friends: Friend.samples,
            onDelete: {},
            onEdit: {}
        )
    }
}
