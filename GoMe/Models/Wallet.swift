//  Wallet.swift
//  GoMe
//
//  Created by Aluno-08 on 27/03/26.
//
//comentario
import Foundation
import SwiftData

@Model
class Wallet: Identifiable {
    var id = UUID()
    var name: String
    var money: Double = 0
    var category: Category
    var isExpense: Bool = true
    var date: Date = Date()
    
    init(name: String, money: Double, date: Date = Date(), isExpense: Bool = true, category: Category) {
        self.name = name
        self.money = money
        self.date = date
        self.isExpense = isExpense
        self.category = category
    }
}
