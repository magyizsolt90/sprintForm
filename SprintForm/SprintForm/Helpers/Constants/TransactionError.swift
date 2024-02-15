//
//  TransactionError.swift
//  SprintForm
//
//  Created by Zsolt Magyi on 2024.02.15.
//

import Foundation

enum TransactionError: Error {
    case requestError
    case noResponseError
    case invalidSessionError
    case invalidJsonFomatError
}
