//
//  Goal.swift
//  GoMe
//
//  Created by Aluno-08 on 27/03/26.
//

import Foundation
import Observation

@Observable
class Goal: Identifiable {
    var id = UUID()
    var name: String
    var money = Double(0.00)
    var endDate: Date?
    var details: String
    var category: Category
    var isCompleted: Bool = false
    var isGroup: Bool = false
    var groupImageData: Data? = nil
    var groupCode: String? = nil
    var progressValue: Double = 0
    
    init(name: String, details: String, category: Category) {
        self.name = name
        self.details = details
        self.category = category
    }
}
