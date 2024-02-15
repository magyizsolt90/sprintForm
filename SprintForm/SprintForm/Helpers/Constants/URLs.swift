//
//  URLs.swift
//  SprintForm
//
//  Created by Zsolt Magyi on 2024.02.15.
//

import Foundation

struct URLs {
    static let baseURL = "https://development.sprintform.com"
    
    static var getTransactions: String {
        return baseURL + "/transactions.json"
    }
}
