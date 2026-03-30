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
    @State private var showCategoryPicker: Bool = false

    @Environment(\.dismiss) private var dismiss

    private var filteredGoals: [Goal] {
        goals.filter { goal in
            let tabMatch: Bool = selectedTab == .personal ? !goal.isGroup : goal.isGroup
            let catMatch = selectedCategory == nil || goal.category == selectedCategory
            return tabMatch && catMatch
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
                navBar
                tabPicker
                    .padding(.top, 12)
                    .padding(.horizontal)
                categoryFilter
                    .padding(.top, 16)
                    .padding(.horizontal)

                if filteredGoals.isEmpty {
                    emptyState
                } else {
                    ScrollView {
                        LazyVGrid(columns: columns, spacing: 12) {
                            ForEach(filteredGoals) { goal in
                                GoalView(goal: goal, isSelected: goal.id == selectedGoalID)
                                    .onTapGesture { selectedGoalID = goal.id }
                                    .contextMenu {
                                        Button("Delete", systemImage: "trash", role: .destructive) {
                                            goals.removeAll { $0.id == goal.id }
                                        }
                                    }
                            }
                        }
                        .padding(.horizontal)
                        .padding(.top, 16)
                        .padding(.bottom, 90)
                    }
                }
            }

            Button { showAddGoal = true } label: {
                Image(systemName: "plus")
                    .font(.system(size: 22, weight: .semibold))
                    .foregroundStyle(.white)
                    .frame(width: 56, height: 56)
                    .background(
                        Circle()
                            .fill(Color.blackBox)
                            .overlay(Circle().stroke(Color.white.opacity(0.3), lineWidth: 1))
                            .shadow(color: .black.opacity(0.4), radius: 8, x: 0, y: 4)
                    )
            }
            .padding(.trailing, 20)
            .padding(.bottom, 28)
        }
        .navigationBarHidden(true)
        .sheet(isPresented: $showAddGoal) {
            AddGoal(goals: $goals)
                .presentationDragIndicator(.visible)
        }
        .confirmationDialog("Select Category", isPresented: $showCategoryPicker, titleVisibility: .visible) {
            Button("All") { selectedCategory = nil }
            ForEach(Category.allCases) { cat in
                Button(cat.rawValue) { selectedCategory = cat }
            }
        }
    }

    private var navBar: some View {
        HStack {
            Button { dismiss() } label: {
                Image(systemName: "chevron.left")
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundStyle(.white)
                    .frame(width: 36, height: 36)
                    .background(Circle().fill(Color.white.opacity(0.12)))
            }
            Spacer()
            Text("Goals")
                .font(.system(size: 20, weight: .bold))
                .foregroundStyle(.white)
            Spacer()
            Button { } label: {
                Image(systemName: "magnifyingglass")
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundStyle(.white)
                    .frame(width: 36, height: 36)
                    .background(Circle().fill(Color.white.opacity(0.12)))
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 12)
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
        HStack {
            Image(systemName: "list.bullet")
                .foregroundStyle(.white)
            Text("Category")
                .foregroundStyle(.white)
                .font(.system(size: 15))
            Spacer()
            Button { showCategoryPicker = true } label: {
                HStack(spacing: 4) {
                    Text(selectedCategory?.rawValue ?? "Select")
                        .foregroundStyle(Color.primaryBlue)
                        .font(.system(size: 15, weight: .semibold))
                    Image(systemName: "chevron.up.chevron.down")
                        .foregroundStyle(Color.primaryBlue)
                        .font(.system(size: 12))
                }
            }
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 12)
        .background(RoundedRectangle(cornerRadius: 14).fill(Color.white.opacity(0.08)))
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
    return GoalsScreen(goals: $goals)
}
