//
//  TransactionCell.swift
//  SprintForm
//
//  Created by Zsolt Magyi on 2024.02.15.
//

import UIKit

class TransactionCell: UITableViewCell, CellProtocol {
    static let kCellHeight: CGFloat = 85
    static var cellID: String {
        return "transactionCellId"
    }
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var categoryImage: UIImageView!
    @IBOutlet weak var transactionNameLabel: UILabel!
    @IBOutlet weak var transactionAmountLabel: UILabel!
    @IBOutlet weak var transactionDateLabel: UILabel!
    
    func setupTransactionCell(transaction: TransactionVM) {
        baseSetupUI()
        categoryImage.image = transaction.category?.icon
        categoryImage.backgroundColor = transaction.category?.backgroundColor
        categoryImage.tintColor = transaction.category?.tintColor
        
        transactionNameLabel.text = transaction.name
        transactionDateLabel.text = transaction.prettyDate
        transactionAmountLabel.text = transaction.amount
    }
}

//MARK: - Private helpers
extension TransactionCell {
    private func baseSetupUI() {
        containerView.layer.cornerRadius = 20
        containerView.layer.masksToBounds = true
        
        categoryImage.layer.cornerRadius = 16
        categoryImage.layer.masksToBounds = true
    }
}
