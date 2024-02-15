//
//  TransactionCategoryCell.swift
//  SprintForm
//
//  Created by Zsolt Magyi on 2024.02.15.
//

import UIKit

class TransactionCategoryCell: UICollectionViewCell, CellProtocol {
    static var cellID: String {
        return "categoryCellId"
    }
    
    static let kCellHeight: CGFloat = 55
    static let kCellHorizontalMargins: CGFloat = 69
    
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var spentOnCategoryLabel: UILabel!
    @IBOutlet weak var categoryImage: UIImageView!
    
    func setupTransactionCell(category: TransactionCategory, spentOnCategory: String? = nil, isSelected: Bool = false) {
        baseSetupUI()
        setupSpentOnCategory(spentOnCategory)
        setupAsSelected(isSelected)
        
        categoryImage.image = category.icon
        categoryImage.backgroundColor = category.backgroundColor
        categoryImage.tintColor = category.tintColor
        categoryLabel.text = category.localizedTitle
    }
}

//MARK: - TransactionCategoryCell
extension TransactionCategoryCell {
    private func baseSetupUI() {
        contentView.layer.cornerRadius = 20
        contentView.layer.masksToBounds = true
        
        categoryImage.layer.cornerRadius = 16
        categoryImage.layer.masksToBounds = true
    }
    
    private func setupSpentOnCategory(_ spentOnCategory: String?) {
        if let spending = spentOnCategory {
            spentOnCategoryLabel.text = spending
            spentOnCategoryLabel.isHidden = false
        } else {
            spentOnCategoryLabel.isHidden = true
        }
    }
    
    private func setupAsSelected(_ isSelected: Bool) {
        if isSelected {
            contentView.layer.borderWidth = 2
            contentView.layer.borderColor = Colorz.foodOrange.cgColor
        } else {
            contentView.layer.borderWidth = 0
            contentView.layer.borderColor = nil
        }
    }
}
