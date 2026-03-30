//
//  AddGoal.swift
//  GoMe
//
//  Created by Aluno-08 on 27/03/26.
//

import Foundation
import SwiftUI

struct AddGoal: View {
    
    @State private var name: String = ""
    @State private var description: String = ""
    @State private var category: Category?
    @State private var isSharedGoal = false
    @State private var endDate = Date()
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Goal")
                            .font(.system(.subheadline, weight: .semibold))
                            .padding(.horizontal)
                        
                        TextField("Insert the Goal title here", text: $name)
                            .padding(.vertical, 12)
                            .padding(.horizontal)
                            .background(
                                RoundedRectangle(cornerRadius: 26)
                                    .foregroundStyle(.blackBox)
                            )
                    }
                    
                    HStack(spacing: 12) {
                        Image(systemName: "list.bullet")
                            .foregroundStyle(.white)
                            .frame(width: 30, height: 30)
                            .background(
                                RoundedRectangle(cornerRadius: 7)
                                    .foregroundStyle(.white)
                            )
                        Text("Category")
                            .padding(.vertical, 11)
                        
                        Spacer()
                        
                        Menu {
                            ForEach(Category.allCases) { cat in
                                Button(cat.rawValue, systemImage: cat.imageName) {
                                    self.category = cat
                                }
                            }
                        } label: {
                            HStack {
                                Text(category?.rawValue ?? "Select")
                                Image(systemName: "chevron.up.chevron.down")
                            }
                        }
                    }
                    .padding(.horizontal)
                    .background(
                        RoundedRectangle(cornerRadius: 26)
                            .foregroundStyle(.blackBox)
                    )
                    
                    HStack {
                        Text("End Date")
                        Spacer()
                        DatePicker("End Date", selection: $endDate, displayedComponents: [.date])
                            .labelsHidden()
                    }
                    .padding(.horizontal)
                    .background(
                        RoundedRectangle(cornerRadius: 26)
                            .foregroundStyle(.blackBox)
                    )
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Description")
                            .font(.system(.subheadline, weight: .semibold))
                            .padding(.horizontal)
                        
                        TextField("More details about the goal", text: $description, axis: .vertical)
                                                   .lineLimit(5...)
                                                   .padding(.vertical, 12)
                                                   .padding(.horizontal)
                                                   .background(
                                                       RoundedRectangle(cornerRadius: 26)
                                                           .foregroundStyle(.blackBox)
                                                   )
                                           }
                                           
                                           Toggle(isOn: $isSharedGoal) {
                                               Text("Shared Goal")
                                           }
                                           .padding(.horizontal)
                                       }
                                       .padding()
                                   }
                                   .navigationTitle("New Goal")
                               }
                           }
                       }

                       #Preview {
                           AddGoal()
                       }
