//
//  GoalsScreen.swift
//  GoMe
//
//  Created by Aluno-08 on 30/03/26.
//

import SwiftUI

enum GoalTab: String, CaseIterable, Identifiable {
    case personal = "Personal"
    case group    = "Group"
    var id: String { rawValue }
}

struct GoalsScreen: View {

    @Binding var goals: [Goal]
    @Binding var wallets: [Wallet]
    @State private var selectedTab: GoalTab = .personal
    @State private var selectedCategory: Category? = nil
    @State private var selectedGoalID: UUID? = nil
    @State private var showAddGoal: Bool = false
    @State private var showingDetailGoalIndex: Int? = nil
    @State private var isSearching: Bool = false
    @State private var searchText: String = ""

    @Environment(\.dismiss) private var dismiss

    private var filteredGoals: [Goal] {
        goals.filter { goal in
            let tabMatch: Bool = selectedTab == .personal ? !goal.isGroup : goal.isGroup
            let catMatch = selectedCategory == nil || goal.category == selectedCategory
            let searchMatch = searchText.isEmpty || goal.name.localizedCaseInsensitiveContains(searchText)
            return tabMatch && catMatch && searchMatch
        }
    }

    private let columns = [
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12)
    ]

    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            Color.blackBox.ignoresSafeArea()

            VStack(spacing: 0) {
                tabPicker
                    .padding(.top, 12)
                    .padding(.horizontal)

                if isSearching {
                    searchBar
                }

                categoryFilter
                    .padding(.top, isSearching ? 8 : 16)
                    .padding(.horizontal)

                if filteredGoals.isEmpty {
                    emptyState
                } else {
                    ScrollView(showsIndicators: false) {
                        VStack(alignment: .leading, spacing: 16) {
                            
                            // MARK: - Group avatars (fixed layout)
                            if selectedTab == .group {
                                VStack(alignment: .leading, spacing: 10) {
                                    Text("Groups")
                                        .font(.system(size: 16, weight: .semibold))
                                        .foregroundStyle(.white)
                                        .padding(.horizontal)

                                    ScrollView(.horizontal, showsIndicators: false) {
                                        HStack(spacing: 14) {
                                            ForEach(filteredGoals) { goal in
                                                VStack(spacing: 8) {
                                                    if let data = goal.groupImageData,
                                                       let uiImage = UIImage(data: data) {
                                                        Image(uiImage: uiImage)
                                                            .resizable()
                                                            .scaledToFill()
                                                            .frame(width: 52, height: 52)
                                                            .clipShape(Circle())
                                                            .overlay(Circle().stroke(Color.white.opacity(0.15), lineWidth: 1))
                                                    } else {
                                                        Image(systemName: "person.2.fill")
                                                            .font(.system(size: 20))
                                                            .foregroundStyle(.white.opacity(0.5))
                                                            .frame(width: 52, height: 52)
                                                            .background(
                                                                Circle()
                                                                    .fill(Color.white.opacity(0.08))
                                                                    .overlay(Circle().stroke(Color.white.opacity(0.1), lineWidth: 1))
                                                            )
                                                    }

                                                    Text(goal.name)
                                                        .font(.system(size: 11, weight: .medium))
                                                        .foregroundStyle(.white.opacity(0.7))
                                                        .lineLimit(1)
                                                }
                                                .frame(width: 64)
                                            }
                                        }
                                        .padding(.horizontal)
                                    }
                                }
                                .padding(.bottom, 4)
                            }

                            // MARK: - Goal Grid
                            LazyVGrid(columns: columns, spacing: 12) {
                                ForEach(filteredGoals) { goal in
                                    GoalView(goal: goal, isSelected: goal.id == selectedGoalID)
                                        .onTapGesture {
                                            selectedGoalID = goal.id
                                            if let idx = goals.firstIndex(where: { $0.id == goal.id }) {
                                                showingDetailGoalIndex = idx
                                            }
                                        }
                                        .contextMenu {
                                            Button("Delete", systemImage: "trash", role: .destructive) {
                                                goals.removeAll { $0.id == goal.id }
                                            }
                                        }
                                }
                            }
                            .padding(.horizontal)
                        }
                        .padding(.top, 16)
                        .padding(.bottom, 90)
                    }
                }
            }

            // FAB
            Button {
                showAddGoal = true
            } label: {
                Image(systemName: "plus")
                    .font(.system(size: 22, weight: .semibold))
                    .foregroundStyle(.white)
                    .frame(width: 56, height: 56)
                    .background(
                        Circle()
                            .fill(
                                LinearGradient(
                                    colors: [Color.primaryBlue, Color.primaryGreen],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .shadow(color: Color.primaryBlue.opacity(0.4), radius: 12, y: 4)
                    )
            }
            .padding(.trailing, 20)
            .padding(.bottom, 28)
        }
        .navigationTitle("Goals")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                        isSearching.toggle()
                        if !isSearching { searchText = "" }
                    }
                } label: {
                    Image(systemName: isSearching ? "xmark" : "magnifyingglass")
                        .foregroundStyle(.white)
                }
            }
        }
        .preferredColorScheme(.dark)
        .sheet(isPresented: $showAddGoal) {
            AddGoal(goals: $goals, friends: [])
                .presentationDragIndicator(.visible)
        }
        .sheet(item: $showingDetailGoalIndex) { idx in
            if idx < goals.count {
                GoalDetailScreen(
                    goal: $goals[idx],
                    allWallets: wallets,
                    friends: [],
                    onDelete: {
                        goals.remove(at: idx)
                    }
                )
                .presentationDragIndicator(.visible)
            }
        }
    }

    // MARK: - Search Bar

    private var searchBar: some View {
        HStack(spacing: 10) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 15))
                .foregroundStyle(.white.opacity(0.5))
            TextField("Search goals...", text: $searchText)
                .font(.system(size: 16))
                .foregroundStyle(.white)
            if !searchText.isEmpty {
                Button {
                    searchText = ""
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .font(.system(size: 16))
                        .foregroundStyle(.white.opacity(0.4))
                }
            }
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 10)
        .background(RoundedRectangle(cornerRadius: 16).fill(Color.white.opacity(0.08)))
        .padding(.horizontal)
        .padding(.top, 12)
        .transition(.opacity.combined(with: .move(edge: .top)))
    }

    // MARK: - Tab Picker

    private var tabPicker: some View {
        HStack(spacing: 0) {
            ForEach(GoalTab.allCases) { tab in
                Button {
                    withAnimation(.easeInOut(duration: 0.2)) { selectedTab = tab }
                } label: {
                    Text(tab.rawValue)
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundStyle(selectedTab == tab ? .black : .white.opacity(0.6))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 9)
                        .background(
                            selectedTab == tab
                                ? RoundedRectangle(cornerRadius: 10).fill(Color.white)
                                : RoundedRectangle(cornerRadius: 10).fill(Color.clear)
                        )
                }
            }
        }
        .padding(4)
        .background(RoundedRectangle(cornerRadius: 14).fill(Color.white.opacity(0.1)))
    }

    // MARK: - Category Filter

    private var categoryFilter: some View {
        HStack(spacing: 12) {
            Image(systemName: selectedCategory?.imageName ?? "list.bullet")
                .foregroundStyle(.white)
                .frame(width: 32, height: 32)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.primaryBlue)
                )
            
            Text("Category")
                .foregroundStyle(.white)
                .font(.system(size: 15))
            
            Spacer()
            
            Menu {
                Button("All", systemImage: "square.grid.2x2") {
                    selectedCategory = nil
                }
                
                ForEach(Category.allCases) { cat in
                    Button(cat.rawValue, systemImage: cat.imageName) {
                        selectedCategory = cat
                    }
                }
            } label: {
                HStack(spacing: 4) {
                    Text(selectedCategory?.rawValue ?? "All")
                        .foregroundStyle(Color.primaryBlue)
                        .font(.system(size: 15, weight: .semibold))
                    Image(systemName: "chevron.up.chevron.down")
                        .foregroundStyle(Color.primaryBlue)
                        .font(.system(size: 12))
                }
            }
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 10)
        .background(RoundedRectangle(cornerRadius: 16).fill(Color.white.opacity(0.08)))
    }

    // MARK: - Empty State

    private var emptyState: some View {
        VStack(spacing: 16) {
            Spacer()
            Image(systemName: "flag.fill")
                .font(.system(size: 48))
                .foregroundStyle(.white.opacity(0.2))
            Text("No goals yet")
                .font(.system(size: 18, weight: .semibold))
                .foregroundStyle(.white.opacity(0.5))
            Text("Tap + to add your first goal")
                .font(.system(size: 14))
                .foregroundStyle(.white.opacity(0.3))
            Spacer()
        }
    }
}

extension Int: @retroactive Identifiable {
    public var id: Int { self }
}

#Preview {
    @Previewable @State var goals: [Goal] = {
        var g1 = Goal(name: "TV", details: "", category: .eletronics)
        g1.money = 675
        g1.savedAmount = 470
        g1.endDate = Calendar.current.date(byAdding: .day, value: 5, to: Date())

        var g2 = Goal(name: "Gift Laura", details: "", category: .friends)
        g2.money = 100
        g2.savedAmount = 100
        g2.isGroup = true

        var g3 = Goal(name: "Travel", details: "", category: .travel)
        g3.money = 2000
        g3.savedAmount = 400
        g3.endDate = Calendar.current.date(byAdding: .day, value: 119, to: Date())

        return [g1, g2, g3]
    }()
    @Previewable @State var wallets: [Wallet] = []
    return NavigationStack {
        GoalsScreen(goals: $goals, wallets: $wallets)
    }
}
