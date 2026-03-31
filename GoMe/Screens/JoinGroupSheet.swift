import SwiftUI

struct JoinGroupSheet: View {

    let goal: Goal
    var onJoin: () -> Void

    @Environment(\.dismiss) private var dismiss

    private let fieldBackground = Color(white: 0.17)

    var body: some View {
        ZStack {
            Color.blackBox.ignoresSafeArea()

            VStack(spacing: 24) {
                Spacer()

                groupPhoto
                
                Text(goal.name)
                    .font(.system(size: 28, weight: .bold, design: .rounded))
                    .foregroundStyle(.white)

                if !goal.details.isEmpty {
                    Text(goal.details)
                        .font(.system(size: 16))
                        .foregroundStyle(.white.opacity(0.65))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 32)
                }

                HStack(spacing: 10) {
                    Image(systemName: goal.category.imageName)
                        .font(.system(size: 16, weight: .medium))
                    Text(goal.category.rawValue)
                        .font(.system(size: 16, weight: .medium))
                }
                .foregroundStyle(Color.primaryBlue)

                if goal.money > 0 {
                    Text(goal.money, format: .currency(code: "USD"))
                        .font(.system(size: 22, weight: .semibold))
                        .foregroundStyle(.white)
                }

                Spacer()

                Button {
                    onJoin()
                    dismiss()
                } label: {
                    HStack(spacing: 8) {
                        Image(systemName: "person.badge.plus")
                            .font(.system(size: 16, weight: .semibold))
                        Text("Join")
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
                .padding(.bottom, 40)
            }
        }
        .preferredColorScheme(.dark)
    }

    private var groupPhoto: some View {
        Group {
            if let data = goal.groupImageData,
               let uiImage = UIImage(data: data) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 100, height: 100)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color.white.opacity(0.15), lineWidth: 1))
            } else {
                Image(systemName: "person.2.fill")
                    .font(.system(size: 36))
                    .foregroundStyle(.white.opacity(0.5))
                    .frame(width: 100, height: 100)
                    .background(
                        Circle()
                            .fill(fieldBackground)
                            .overlay(Circle().stroke(Color.white.opacity(0.15), lineWidth: 1))
                    )
            }
        }
    }
}

#Preview {
    let goal = Goal(name: "TV 4K", details: "Let's save together for a new TV!", category: .eletronics)
    goal.money = 675
    goal.isGroup = true
    goal.groupCode = "ABC123"
    
    return JoinGroupSheet(goal: goal, onJoin: {})
}
