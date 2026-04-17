//
//  AddMembersSheet.swift
//  GoMe
//

import SwiftUI

struct AddMembersSheet: View {
    
    let friends: [Friend]
    @Binding var selectedMembers: [Friend]
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.blackBox.ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Selected members bubbles
                    if !selectedMembers.isEmpty {
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 12) {
                                ForEach(selectedMembers) { member in
                                    VStack(spacing: 4) {
                                        ZStack(alignment: .topTrailing) {
                                            Text(member.avatarEmoji)
                                                .font(.system(size: 30))
                                                .frame(width: 52, height: 52)
                                                .background(
                                                    Circle()
                                                        .fill(Color.primaryBlue.opacity(0.2))
                                                        .overlay(Circle().stroke(Color.primaryBlue.opacity(0.4), lineWidth: 1.5))
                                                )
                                            
                                            Button {
                                                withAnimation(.spring(response: 0.3)) {
                                                    selectedMembers.removeAll { $0.id == member.id }
                                                }
                                            } label: {
                                                Image(systemName: "xmark.circle.fill")
                                                    .font(.system(size: 18))
                                                    .foregroundStyle(.white, Color.red.opacity(0.8))
                                            }
                                            .offset(x: 4, y: -4)
                                        }
                                        
                                        Text(member.name)
                                            .font(.system(size: 11))
                                            .foregroundStyle(.white.opacity(0.7))
                                            .lineLimit(1)
                                    }
                                    .frame(width: 60)
                                }
                            }
                            .padding(.horizontal, 20)
                            .padding(.vertical, 16)
                        }
                        .background(Color.white.opacity(0.03))
                        
                        Divider().background(Color.white.opacity(0.08))
                    }
                    
                    // Friends list
                    if friends.isEmpty {
                        Spacer()
                        VStack(spacing: 12) {
                            Image(systemName: "person.2.slash")
                                .font(.system(size: 40))
                                .foregroundStyle(.white.opacity(0.25))
                            Text("No friends to add")
                                .font(.system(size: 16, weight: .medium))
                                .foregroundStyle(.white.opacity(0.5))
                            Text("Add friends in your profile first")
                                .font(.system(size: 14))
                                .foregroundStyle(.white.opacity(0.3))
                        }
                        Spacer()
                    } else {
                        List {
                            ForEach(friends) { friend in
                                let isSelected = selectedMembers.contains(where: { $0.id == friend.id })
                                
                                Button {
                                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                        if isSelected {
                                            selectedMembers.removeAll { $0.id == friend.id }
                                        } else {
                                            selectedMembers.append(friend)
                                        }
                                    }
                                } label: {
                                    HStack(spacing: 14) {
                                        Text(friend.avatarEmoji)
                                            .font(.system(size: 28))
                                            .frame(width: 44, height: 44)
                                            .background(
                                                Circle()
                                                    .fill(Color.white.opacity(0.06))
                                            )
                                        
                                        Text(friend.name)
                                            .font(.system(size: 16, weight: .medium))
                                            .foregroundStyle(.white)
                                        
                                        Spacer()
                                        
                                        Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                                            .font(.system(size: 24))
                                            .foregroundStyle(isSelected ? Color.primaryGreen : .white.opacity(0.3))
                                    }
                                    .contentShape(Rectangle())
                                }
                                .listRowBackground(Color.clear)
                                .listRowSeparatorTint(.white.opacity(0.06))
                            }
                        }
                        .listStyle(.plain)
                        .scrollContentBackground(.hidden)
                    }
                }
            }
            .navigationTitle("Add Members")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") { dismiss() }
                        .foregroundStyle(.white.opacity(0.7))
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") { dismiss() }
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundStyle(Color.primaryBlue)
                }
            }
            .preferredColorScheme(.dark)
        }
    }
}

#Preview {
    @Previewable @State var selected: [Friend] = []
    AddMembersSheet(friends: Friend.samples, selectedMembers: $selected)
}
