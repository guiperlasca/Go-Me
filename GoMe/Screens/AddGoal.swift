//
//  AddGoal.swift
//  GoMe
//
//  Created by Aluno-08 on 27/03/26.
//

import Foundation
import SwiftUI
import PhotosUI

struct AddGoal: View {
    
    @Binding var goals: [Goal]
    var friends: [Friend]
    @Environment(\.dismiss) private var dismiss
    
    @State private var name: String = ""
    @State private var description: String = ""
    @State private var category: Category?
    @State private var isSharedGoal = false
    @State private var endDate = Date()
    @State private var moneyAmount: Double = 0
    
    @State private var selectedPhotoItem: PhotosPickerItem? = nil
    @State private var selectedImage: Image? = nil
    @State private var selectedImageData: Data? = nil
    @State private var selectedMembers: [Friend] = []
    @State private var showMembersSheet = false

    private let fieldBackground = Color(white: 0.17)

    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 14) {
                    
                    // MARK: - Group Photo
                    if isSharedGoal {
                        PhotosPicker(selection: $selectedPhotoItem, matching: .images) {
                            if let selectedImage {
                                selectedImage
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 80, height: 80)
                                    .clipShape(Circle())
                                    .overlay(Circle().stroke(Color.white.opacity(0.15), lineWidth: 1.5))
                            } else {
                                Image(systemName: "photo.badge.plus")
                                    .font(.system(size: 26))
                                    .foregroundStyle(.white.opacity(0.6))
                                    .frame(width: 80, height: 80)
                                    .background(
                                        Circle()
                                            .fill(fieldBackground)
                                            .overlay(Circle().stroke(Color.white.opacity(0.12), lineWidth: 1))
                                    )
                            }
                        }
                        .padding(.bottom, 4)
                        .onChange(of: selectedPhotoItem) { _, newItem in
                            Task {
                                if let data = try? await newItem?.loadTransferable(type: Data.self),
                                   let uiImage = UIImage(data: data) {
                                    selectedImageData = data
                                    selectedImage = Image(uiImage: uiImage)
                                }
                            }
                        }
                        .transition(.opacity.combined(with: .scale(scale: 0.9)))
                    }

                    // MARK: - Category
                    HStack(spacing: 12) {
                        Image(systemName: category?.imageName ?? "list.bullet")
                            .foregroundStyle(.white)
                            .frame(width: 32, height: 32)
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(Color.primaryBlue)
                            )
                        Text("Category")
                            .foregroundStyle(.white)
                        Spacer()
                        Menu {
                            ForEach(Category.allCases) { cat in
                                Button(cat.rawValue, systemImage: cat.imageName) {
                                    self.category = cat
                                }
                            }
                        } label: {
                            HStack(spacing: 4) {
                                Text(category?.rawValue ?? "Select")
                                Image(systemName: "chevron.up.chevron.down")
                            }
                            .foregroundStyle(Color.primaryBlue)
                        }
                    }
                    .padding(.horizontal, 14)
                    .padding(.vertical, 10)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(fieldBackground)
                    )
                    
                    // MARK: - Name
                    TextField("Goal name", text: $name)
                        .font(.system(size: 17))
                        .foregroundStyle(.white)
                        .padding(.vertical, 14)
                        .padding(.horizontal, 14)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(fieldBackground)
                        )
                    
                    // MARK: - Deadline & Amount
                    HStack(spacing: 12) {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Deadline")
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundStyle(.white.opacity(0.7))
                            
                            DatePicker("", selection: $endDate, displayedComponents: [.date])
                                .labelsHidden()
                                .colorScheme(.dark)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 10)
                                .background(
                                    RoundedRectangle(cornerRadius: 14)
                                        .fill(fieldBackground)
                                )
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Target")
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundStyle(.white.opacity(0.7))
                            
                            TextField("$0.00", value: $moneyAmount, format: .currency(code: "USD"))
                                .keyboardType(.decimalPad)
                                .font(.system(size: 17, weight: .semibold))
                                .foregroundStyle(.white)
                                .multilineTextAlignment(.center)
                                .padding(.vertical, 14)
                                .padding(.horizontal, 12)
                                .background(
                                    RoundedRectangle(cornerRadius: 14)
                                        .fill(fieldBackground)
                                )
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    
                    // MARK: - Description
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Description")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundStyle(.white.opacity(0.7))
                        
                        TextField("More details about the goal", text: $description, axis: .vertical)
                            .lineLimit(3...)
                            .font(.system(size: 16))
                            .foregroundStyle(.white)
                            .padding(.vertical, 12)
                            .padding(.horizontal, 14)
                            .background(
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(fieldBackground)
                            )
                    }
                    
                    // MARK: - Shared Toggle
                    Toggle(isOn: $isSharedGoal.animation(.spring(response: 0.3))) {
                        HStack(spacing: 10) {
                            Image(systemName: "person.2.fill")
                                .foregroundStyle(Color.primaryBlue)
                            Text("Shared goal")
                                .foregroundStyle(.white)
                        }
                    }
                    .tint(Color.primaryGreen)
                    .padding(.horizontal, 14)
                    .padding(.vertical, 10)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(fieldBackground)
                    )
                    
                    // MARK: - Members
                    if isSharedGoal {
                        VStack(alignment: .leading, spacing: 10) {
                            HStack {
                                Text("Members")
                                    .font(.system(size: 15, weight: .semibold))
                                    .foregroundStyle(.white)
                                Spacer()
                                Button {
                                    showMembersSheet = true
                                } label: {
                                    HStack(spacing: 4) {
                                        Image(systemName: "person.badge.plus")
                                            .font(.system(size: 14, weight: .semibold))
                                        Text("Add")
                                            .font(.system(size: 14, weight: .semibold))
                                    }
                                    .foregroundStyle(Color.primaryBlue)
                                }
                            }
                            
                            if selectedMembers.isEmpty {
                                Text("Tap Add to invite friends")
                                    .font(.system(size: 13))
                                    .foregroundStyle(.white.opacity(0.35))
                            } else {
                                ScrollView(.horizontal, showsIndicators: false) {
                                    HStack(spacing: 10) {
                                        ForEach(selectedMembers) { member in
                                            VStack(spacing: 4) {
                                                Text(member.avatarEmoji)
                                                    .font(.system(size: 24))
                                                    .frame(width: 40, height: 40)
                                                    .background(
                                                        Circle()
                                                            .fill(Color.primaryBlue.opacity(0.15))
                                                    )
                                                Text(member.name)
                                                    .font(.system(size: 10))
                                                    .foregroundStyle(.white.opacity(0.6))
                                                    .lineLimit(1)
                                            }
                                            .frame(width: 50)
                                        }
                                    }
                                }
                            }
                        }
                        .padding(14)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(fieldBackground)
                        )
                        .transition(.opacity.combined(with: .move(edge: .top)))
                    }
                }
                .padding(20)
            }
            .navigationTitle("New Goal")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button { dismiss() } label: {
                        Image(systemName: "xmark")
                            .foregroundStyle(.white.opacity(0.7))
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Add", systemImage: "checkmark") {
                        guard let cat = category, !name.isEmpty else { return }
                        let g = Goal(name: name, details: description, category: cat)
                        g.endDate = endDate
                        g.isGroup = isSharedGoal
                        g.money = moneyAmount
                        g.groupImageData = selectedImageData
                        g.members = selectedMembers
                        goals.append(g)
                        dismiss()
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(
                        LinearGradient(
                            colors: [.primaryBlue, .primaryGreen],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                }
            }
            .background(Color("DarkBackground").ignoresSafeArea())
            .preferredColorScheme(.dark)
            .sheet(isPresented: $showMembersSheet) {
                AddMembersSheet(friends: friends, selectedMembers: $selectedMembers)
                    .presentationDragIndicator(.visible)
            }
        }
    }
}

#Preview {
    @Previewable @State var goals: [Goal] = []
    return AddGoal(goals: $goals, friends: Friend.samples)
}
