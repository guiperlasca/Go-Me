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
    var groupImage: UIImage? = nil

    private var daysLeft: Int {
        guard let end = goal.endDate else { return 999 }
        return max(Calendar.current.dateComponents([.day], from: Date(), to: end).day ?? 0, 0)
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

    private var compactCard: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 6) {
                Image(systemName: goal.category.imageName)
                    .font(.system(size: 16))
                    .foregroundStyle(.white)
                Text(goal.name)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(.white)
                    .lineLimit(1)
            }

            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 3)
                        .fill(Color.white.opacity(0.15))
                        .frame(height: 3)
                    RoundedRectangle(cornerRadius: 3)
                        .fill(progressColor)
                        .frame(width: geo.size.width * CGFloat(goal.progressValue), height: 3)
                }
            }
            .frame(height: 3)

            Text(goal.money, format: .currency(code: "BRL").precision(.fractionLength(0)))
                .font(.system(size: 13, weight: .semibold))
                .foregroundStyle(.white.opacity(0.85))
        }
        .padding(12)
        .frame(width: 110, height: 80)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white.opacity(0.07))
        )
    }

    private var fullCard: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(spacing: 8) {
                Image(systemName: goal.category.imageName)
                    .font(.system(size: 20))
                    .foregroundStyle(.white)
                Text(goal.name)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(.white)
                    .lineLimit(1)
            }

            Spacer()

            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 3)
                        .fill(Color.white.opacity(0.15))
                        .frame(height: 4)
                    RoundedRectangle(cornerRadius: 3)
                        .fill(progressColor)
                        .frame(width: geo.size.width * CGFloat(goal.progressValue), height: 4)
                }
            }
            .frame(height: 4)

            HStack(spacing: 0) {
                if goal.isCompleted {
                    Text("Completed")
                        .foregroundStyle(Color.primaryGreen)
                        .font(.system(size: 12))
                } else {
                    Text("\(daysLeft) days left")
                        .foregroundStyle(daysLeft <= 7 ? .red : Color.white.opacity(0.55))
                        .font(.system(size: 12))
                }
                Spacer()
                Text(goal.progressValue, format: .percent.precision(.fractionLength(0)))
                    .foregroundStyle(.white)
                    .font(.system(size: 12, weight: .semibold))
            }
        }
        .padding(16)
        .frame(height: 118)
        .background(
            RoundedRectangle(cornerRadius: 18)
                .fill(Color.white.opacity(0.07))
                .overlay(
                    RoundedRectangle(cornerRadius: 18)
                        .stroke(isSelected ? Color.primaryBlue : Color.clear, lineWidth: 2)
                )
        )
        .overlay(alignment: .topTrailing) {
            if let groupImage {
                Image(uiImage: groupImage)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 28, height: 28)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color.white.opacity(0.2), lineWidth: 1))
                    .padding(8)
            }
        }
    }
}

#Preview {
    @Previewable @State var goal: Goal = {
        var g = Goal(name: "TV", details: "", category: .eletronics)
        g.progressValue = 0.70
        g.money = 675
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
