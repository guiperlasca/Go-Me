//
//  GoalView.swift
//  GoMe
//
//  Created by Aluno-08 on 27/03/26.
//

import Foundation
import SwiftUI

struct GoalView: View {

    var goal: Goal
    var isSelected: Bool = false
    var compact: Bool = false

    private var daysLeft: Int {
        goal.daysLeft
    }

    private var progressColor: Color {
        if goal.isCompleted { return Color.primaryGreen }
        if daysLeft <= 7    { return .red }
        return Color.primaryGreen
    }

    var body: some View {
        if compact {
            compactCard
        } else {
            fullCard
        }
    }

    // MARK: - Compact Card (Home horizontal scroll)
    
    private var compactCard: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 6) {
                Image(systemName: goal.category.imageName)
                    .font(.system(size: 14))
                    .foregroundStyle(Color.primaryBlue)
                Text(goal.name)
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(.white)
                    .lineLimit(1)
            }

            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 3)
                        .fill(Color.white.opacity(0.12))
                        .frame(height: 3)
                    RoundedRectangle(cornerRadius: 3)
                        .fill(progressColor)
                        .frame(width: geo.size.width * CGFloat(goal.progressValue), height: 3)
                        .animation(.spring(response: 0.5), value: goal.progressValue)
                }
            }
            .frame(height: 3)

            HStack {
                Text(goal.savedAmount, format: .currency(code: "USD").precision(.fractionLength(0)))
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundStyle(.white.opacity(0.7))
                Spacer()
                Text(goal.progressValue, format: .percent.precision(.fractionLength(0)))
                    .font(.system(size: 11, weight: .bold))
                    .foregroundStyle(progressColor)
            }
        }
        .padding(12)
        .frame(width: 130, height: 82)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white.opacity(0.06))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.white.opacity(0.06), lineWidth: 1)
                )
        )
    }

    // MARK: - Full Card (Goals grid)

    private var fullCard: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 8) {
                Image(systemName: goal.category.imageName)
                    .font(.system(size: 18))
                    .foregroundStyle(Color.primaryBlue)
                Text(goal.name)
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundStyle(.white)
                    .lineLimit(1)
                
                Spacer()
                
                if goal.isGroup {
                    Image(systemName: "person.2.fill")
                        .font(.system(size: 12))
                        .foregroundStyle(.white.opacity(0.4))
                }
            }

            Spacer()

            // Saved / Target
            Text("\(formatCurrency(goal.savedAmount)) / \(formatCurrency(goal.money))")
                .font(.system(size: 12, weight: .medium))
                .foregroundStyle(.white.opacity(0.55))

            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 3)
                        .fill(Color.white.opacity(0.12))
                        .frame(height: 4)
                    RoundedRectangle(cornerRadius: 3)
                        .fill(
                            LinearGradient(
                                colors: [Color.primaryBlue, progressColor],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .frame(width: geo.size.width * CGFloat(goal.progressValue), height: 4)
                        .animation(.spring(response: 0.5), value: goal.progressValue)
                }
            }
            .frame(height: 4)

            HStack(spacing: 0) {
                if goal.isCompleted {
                    HStack(spacing: 4) {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.system(size: 11))
                        Text("Completed")
                            .font(.system(size: 12))
                    }
                    .foregroundStyle(Color.primaryGreen)
                } else {
                    Text("\(daysLeft) days left")
                        .foregroundStyle(daysLeft <= 7 ? .red : Color.white.opacity(0.45))
                        .font(.system(size: 12))
                }
                Spacer()
                Text(goal.progressValue, format: .percent.precision(.fractionLength(0)))
                    .foregroundStyle(.white)
                    .font(.system(size: 12, weight: .bold))
            }
        }
        .padding(14)
        .frame(height: 130)
        .background(
            RoundedRectangle(cornerRadius: 18)
                .fill(Color.white.opacity(0.06))
                .overlay(
                    RoundedRectangle(cornerRadius: 18)
                        .stroke(isSelected ? Color.primaryBlue : Color.white.opacity(0.05), lineWidth: isSelected ? 2 : 1)
                )
        )
    }

    private func formatCurrency(_ value: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "USD"
        formatter.maximumFractionDigits = 0
        return formatter.string(from: NSNumber(value: value)) ?? "$0"
    }
}

#Preview {
    @Previewable @State var goal: Goal = {
        var g = Goal(name: "TV 4K", details: "", category: .eletronics)
        g.money = 675
        g.savedAmount = 470
        g.endDate = Calendar.current.date(byAdding: .day, value: 5, to: Date())
        return g
    }()
    return VStack(spacing: 20) {
        GoalView(goal: goal, isSelected: true)
        GoalView(goal: goal, compact: true)
    }
    .padding()
    .background(Color.blackBox)
}
