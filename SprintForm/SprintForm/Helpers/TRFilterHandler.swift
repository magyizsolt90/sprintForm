//
//  TRFilterHandler.swift
//  SprintForm
//
//  Created by Zsolt Magyi on 2024.02.15.
//

import Foundation

class TransactionFilterHandler {
    private var originalTransactions: [TransactionVM]!
    private var filteredTransactions: [TransactionVM]!
    private(set) var selectedCategory: TransactionCategory?
    private var searchTerm: String?
    
    var filteredList: [TransactionVM] {
        if originalTransactions == nil || originalTransactions.isEmpty {
            return []
        } else {
            return filteredTransactions
        }
    }
    
    init(originalTransactions: [TransactionVM]) {
        self.originalTransactions = originalTransactions
        self.selectedCategory = nil
        self.searchTerm = nil
    }
    
    func applySearchTerm(term: String) {
        self.searchTerm = term
        filteredTransactions = filterList()
    }
    
    func removeSearchTerm() {
        self.searchTerm = nil
        filteredTransactions = filterList()
    }
    
    func selectCategory(category: TransactionCategory?) {
        self.selectedCategory = category
        filteredTransactions = filterList()
    }
}

extension TransactionFilterHandler {
    private func filterList() -> [TransactionVM] {
        var filteredTransactions = originalTransactions
        
        //SEARCH TERM
        if let searchTerm = self.searchTerm?.lowercased().textWithoutMarks() {
            filteredTransactions = originalTransactions.filter({
                return $0.name.lowercased().textWithoutMarks().contains(searchTerm)
            })
        }
        
        //FILTER
        if let selectedCategory = self.selectedCategory {
            filteredTransactions = filteredTransactions?.filter {
                return $0.category?.rawValue == selectedCategory.rawValue
            }
        }
            
        return filteredTransactions ?? []
    }
}
