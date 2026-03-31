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

                categoryFilter
                    .padding(.top, isSearching ? 8 : 16)
                    .padding(.horizontal)

                if filteredGoals.isEmpty {
                    emptyState
                } else {
                    ScrollView {
                        VStack(alignment: .leading, spacing: 16) {
                            if selectedTab == .group {
                                Text("Groups")
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundStyle(.white)
                                    .padding(.horizontal)

                                ScrollView(.horizontal, showsIndicators: false) {
                                    HStack(spacing: 16) {
                                        ForEach(filteredGoals) { goal in
                                            if let data = goal.groupImageData,
                                               let uiImage = UIImage(data: data) {
                                                Image(uiImage: uiImage)
                                                    .resizable()
                                                    .scaledToFill()
                                                    .frame(width: 56, height: 56)
                                                    .clipShape(Circle())
                                                    .overlay(Circle().stroke(Color.white.opacity(0.15), lineWidth: 1))
                                            } else {
                                                Image(systemName: "person.2.badge.plus")
                                                    .font(.system(size: 22))
                                                    .foregroundStyle(.white.opacity(0.5))
                                                    .frame(width: 56, height: 56)
                                                    .background(
                                                        Circle()
                                                            .fill(Color.white.opacity(0.08))
                                                            .overlay(Circle().stroke(Color.white.opacity(0.1), lineWidth: 1))
                                                    )
                                            }
                                        }
                                    }
                                    .padding(.horizontal)
                                }
                            }

                            LazyVGrid(columns: columns, spacing: 12) {
                                ForEach(filteredGoals) { goal in
                                    let groupImg: UIImage? = {
                                        guard let data = goal.groupImageData else { return nil }
                                        return UIImage(data: data)
                                    }()
                                    GoalView(goal: goal, isSelected: goal.id == selectedGoalID, groupImage: groupImg)
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

            Button {
                showAddGoal = true
            } label: {
                Image(systemName: "plus")
                    .font(.system(size: 22, weight: .semibold))
                    .foregroundStyle(.white)
                    .frame(width: 56, height: 56)
                    .glassEffect(in: .circle)
            }
            .padding(.trailing, 20)
            .padding(.bottom, 28)
        }
        .navigationTitle("Goals")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button { dismiss() } label: {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundStyle(.white)
                }
            }
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                        isSearching.toggle()
                        if !isSearching { searchText = "" }
                    }
                } label: {
                    Image(systemName: isSearching ? "xmark" : "magnifyingglass")
                }
            }
        }
        .preferredColorScheme(.dark)
        .sheet(isPresented: $showAddGoal) {
            AddGoal(goals: $goals)
                .presentationDragIndicator(.visible)
        }
        .sheet(item: $showingDetailGoalIndex) { idx in
            if idx < goals.count {
                GoalDetailScreen(
                    goal: $goals[idx],
                    onDelete: {
                        goals.remove(at: idx)
                    }
                )
                .presentationDragIndicator(.visible)
            }
        }
    }

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

    private var categoryFilter: some View {
        HStack(spacing: 12) {
            Image(systemName: selectedCategory?.imageName ?? "list.bullet")
                .foregroundStyle(.white)
                .frame(width: 32, height: 32)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .foregroundStyle(Color.primaryBlue)
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

    private var emptyState: some View {
        VStack(spacing: 16) {
            Spacer()
            Image(systemName: "flag.fill")
                .font(.system(size: 48))
                .foregroundStyle(.white.opacity(0.3))
            Text("No goals yet")
                .font(.headline)
                .foregroundStyle(.white.opacity(0.5))
            Text("Tap + to add your first goal")
                .font(.subheadline)
                .foregroundStyle(.white.opacity(0.35))
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
        g1.progressValue = 0.70
        g1.endDate = Calendar.current.date(byAdding: .day, value: 5, to: Date())

        var g2 = Goal(name: "Gift Laura", details: "", category: .friends)
        g2.progressValue = 1.0
        g2.isCompleted = true
        g2.isGroup = true

        var g3 = Goal(name: "Travel", details: "", category: .travel)
        g3.progressValue = 0.20
        g3.endDate = Calendar.current.date(byAdding: .day, value: 119, to: Date())

        return [g1, g2, g3]
    }()
    return NavigationStack {
        GoalsScreen(goals: $goals)
    }
}
