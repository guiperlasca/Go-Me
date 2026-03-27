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
    
    var body: some View {
        VStack {
            HStack(spacing: 8) {
                Image(systemName: goal.category.imageName)
                    .foregroundStyle(.white)
                Text(goal.name)
                    .foregroundStyle(.white)
            }
            VStack(alignment: .leading, spacing: 4) {
                ProgressView(value: goal.progressValue)
                    .tint(.white)
                Text(goal.progressValue, format: .percent)
                    .foregroundStyle(.white)
            }
        }
        .frame(width: 111.28, height: 103)
        .padding()
        .glassEffect(in: .rect(cornerRadius: 16.0))
    }
}
#Preview {
    GoalView(goal: Goal(name: "Exemplo", details: "Minha meta", category: .food))
}
