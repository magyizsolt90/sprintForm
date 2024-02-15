//
//  TransactionVM.swift
//  SprintForm
//
//  Created by Zsolt Magyi on 2024.02.15.
//

import Foundation

class TransactionVM {
    static var allTransactions: [TransactionVM] = []
    
    private let transaction: Transaction!
    private var dateformatter: ISO8601DateFormatter!
    
    init(with transaction: Transaction) {
        self.transaction = transaction
        self.dateformatter = setupFormatter()
    }
    
    //MARK: -  Public access props & funcs
    var category: TransactionCategory? {
        return TransactionCategory(rawValue: transaction.category)
    }

    var name: String {
        return transaction.summary
    }

    var amount: String {
        return "-" + transaction.sum.prettyNumber + transaction.currency.uppercased()
    }
    
    var sum: Int {
        return Int(transaction.sum.rounded())
    }
    
    var date: Date? {
        return convertServerDateFormatToDate(transaction.paid)
    }
    
    var prettyDate: String? {
        return convertServerDateFormatToPrettyDate(transaction.paid)
    }
}

//MARK: -  Date part helper 📅
extension TransactionVM {
    private var desiredFormat: String {
        return "MMM dd"
    }
    
    private func setupFormatter() -> ISO8601DateFormatter {
        let inputFormatter = ISO8601DateFormatter()
         inputFormatter.formatOptions = [.withFullDate, .withTime, .withTimeZone, .withDashSeparatorInDate, .withColonSeparatorInTime]
         return inputFormatter
    }
    
    private func convertServerDateFormatToPrettyDate(_ serverDateFormat: String) -> String? {
        if let date = dateformatter.date(from: serverDateFormat) {
            let outputFormatter = DateFormatter()
            outputFormatter.dateFormat = desiredFormat
            return outputFormatter.string(from: date)
        }
        return nil
    }
    
    private func convertServerDateFormatToDate(_ serverDateFormat: String) -> Date? {
        return dateformatter.date(from: serverDateFormat)
    }
}
