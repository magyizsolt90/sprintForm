//
//  Transaction.swift
//  SprintForm
//
//  Created by Zsolt Magyi on 2024.02.15.
//

import Foundation

struct Transaction: Codable {
    let id: String
    let summary: String
    let category: String
    let sum: Double
    let currency: String
    let paid: String
}
