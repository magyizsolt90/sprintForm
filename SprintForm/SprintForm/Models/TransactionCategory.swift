//
//  TransationCategory.swift
//  SprintForm
//
//  Created by Zsolt Magyi on 2024.02.15.
//

import UIKit

enum TransactionCategory: String, CaseIterable {
    case housing
    case travel
    case food
    case clothing
    case utilities
    case insurance
    case healthcare
    case financial
    case lifestyle
    case entertainment
    case miscellaneous
}


extension TransactionCategory {
    var localizedTitle: String {
        return ("transaction_categery_" + self.rawValue).localized
    }
    
    var backgroundColor: UIColor {
        return tintColor.withAlphaComponent(0.3)
    }
    
    var tintColor: UIColor {
        switch self {
        case .housing:
            return Colorz.housingKoral
        case .travel:
            return Colorz.travelGreen
        case .food:
            return Colorz.foodOrange
        case .clothing:
            return Colorz.clothingMagenta
        case .utilities:
            return Colorz.utilityGray
        case .insurance:
            return Colorz.insuranceGreen
        case .healthcare:
            return Colorz.healthRed
        case .financial:
            return Colorz.financialBlue
        case .lifestyle:
            return Colorz.lifestyleYellow
        case .entertainment:
            return Colorz.entertainmentPink
        case .miscellaneous:
            return Colorz.miscBrown
        }
    }
    
    var icon: UIImage {
        switch self {
        case .housing:
            return Images.house
        case .travel:
            return Images.travel
        case .food:
            return Images.food
        case .clothing:
            return Images.dress
        case .utilities:
            return Images.utility
        case .insurance:
            return Images.insurance
        case .healthcare:
            return Images.healthcare
        case .financial:
            return Images.financial
        case .lifestyle:
            return Images.lifestyle
        case .entertainment:
            return Images.entertainment
        case .miscellaneous:
            return Images.miscellaneous
        }
    }
}

extension TransactionCategory {
    var categoryCellContentWidth: CGFloat {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .regular)
        label.text = self.localizedTitle
        label.sizeToFit()
        return label.frame.width
    }
}
