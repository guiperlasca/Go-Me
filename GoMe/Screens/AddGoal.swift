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
    @Environment(\.dismiss) private var dismiss

    @State private var name: String = ""
    @State private var description: String = ""
    @State private var category: Category?
    @State private var isSharedGoal = false
    @State private var endDate = Date()
    @State private var price: String = ""
    
    @State private var selectedPhotoItem: PhotosPickerItem? = nil
    @State private var selectedImage: Image? = nil
    @State private var selectedImageData: Data? = nil
    @State private var generatedGroupCode: String = UUID().uuidString.prefix(6).uppercased()

    private let accentTeal = Color(red: 0/255, green: 139/255, blue: 185/255)
    private let fieldBackground = Color(white: 0.17)

    private var shareURL: String {
        "Join my GoMe goal group! Open: gome://join?code=\(generatedGroupCode)"
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 12) {
                    
                    if isSharedGoal {
                        PhotosPicker(selection: $selectedPhotoItem, matching: .images) {
                            if let selectedImage {
                                selectedImage
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 72, height: 72)
                                    .clipShape(Circle())
                                    .overlay(Circle().stroke(Color.white.opacity(0.15), lineWidth: 1))
                            } else {
                                Image(systemName: "photo.badge.plus")
                                    .font(.system(size: 26))
                                    .foregroundStyle(.white)
                                    .frame(width: 72, height: 72)
                                    .background(
                                        Circle()
                                            .fill(fieldBackground)
                                            .overlay(Circle().stroke(Color.white.opacity(0.15), lineWidth: 1))
                                    )
                            }
                        }
                        .padding(.bottom, 8)
                        .onChange(of: selectedPhotoItem) { newItem in
                            Task {
                                if let data = try? await newItem?.loadTransferable(type: Data.self),
                                   let uiImage = UIImage(data: data) {
                                    selectedImageData = data
                                    selectedImage = Image(uiImage: uiImage)
                                }
                            }
                        }
                    }

                    HStack(spacing: 12) {
                        Image(systemName: category?.imageName ?? "list.bullet")
                            .foregroundStyle(.white)
                            .frame(width: 32, height: 32)
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .foregroundStyle(Color(red: 0/255, green: 139/255, blue: 185/255))
                            )

                        Text("Category")
                            .foregroundStyle(.primary)

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
                            .foregroundStyle(Color(red: 0/255, green: 139/255, blue: 185/255))
                        }
                    }
                    .padding(.horizontal, 14)
                    .padding(.vertical, 8)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .foregroundStyle(fieldBackground)
                    )

                    TextField("Goal name", text: $name)
                        .padding(.vertical, 14)
                        .padding(.horizontal, 8)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .foregroundStyle(fieldBackground)
                        )

                    VStack(alignment: .leading, spacing: 8) {
                        Text("Deadline")
                            .font(.system(.subheadline, weight: .bold))
                            .padding(.horizontal, 4)

                        HStack(spacing: 12) {
                            DatePicker(
                                "",
                                selection: $endDate,
                                displayedComponents: [.date]
                            )
                            .labelsHidden()
                            .padding(.vertical, 10)
                            .padding(.horizontal, 8)
                            .background(
                                RoundedRectangle(cornerRadius: 16)
                                    .foregroundStyle(fieldBackground)
                            )

                            HStack {
                                TextField("$ Set the price", text: $price)
                                    .keyboardType(.decimalPad)
                            }
                            .padding(.vertical, 14)
                            .padding(.horizontal, 8)
                            .background(
                                RoundedRectangle(cornerRadius: 16)
                                    .foregroundStyle(fieldBackground)
                            )
                        }
                    }

                    VStack(alignment: .leading, spacing: 8) {
                        Text("Description")
                            .font(.system(.subheadline, weight: .bold))
                            .padding(.horizontal, 4)

                        TextField("More details about the goal", text: $description, axis: .vertical)
                            .lineLimit(5...)
                            .padding(.vertical, 14)
                            .padding(.horizontal, 8)
                            .background(
                                RoundedRectangle(cornerRadius: 16)
                                    .foregroundStyle(fieldBackground)
                            )
                    }

                    Toggle(isOn: $isSharedGoal) {
                        Text("Shared goal")
                    }
                    .padding(.horizontal, 14)
                    .padding(.vertical, 8)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .foregroundStyle(fieldBackground)
                    )
                    
                    if isSharedGoal {
                        ShareLink(item: shareURL) {
                            HStack(spacing: 8) {
                                Image(systemName: "link")
                                    .font(.system(size: 16, weight: .semibold))
                                Text("Share")
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
                        .padding(.top, 16)
                    }
                }
                .padding()
                .animation(.easeInOut, value: isSharedGoal)
            }
            .navigationTitle("New Goal")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                            .foregroundStyle(.white)
                    }
                }

                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Add", systemImage: "checkmark") {
                        guard let cat = category, !name.isEmpty else { return }
                        var g = Goal(name: name, details: description, category: cat)
                        g.endDate = endDate
                        g.isGroup = isSharedGoal
                        g.money = Double(price) ?? 0
                        g.groupImageData = selectedImageData
                        if isSharedGoal {
                            g.groupCode = generatedGroupCode
                        }
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
        }
    }
}

#Preview {
    @Previewable @State var goals: [Goal] = []
    return AddGoal(goals: $goals)
}
