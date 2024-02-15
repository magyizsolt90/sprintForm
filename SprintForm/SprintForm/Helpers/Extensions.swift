//
//  Extensions.swift
//  SprintForm
//
//  Created by Zsolt Magyi on 2024.02.15.
//

import UIKit

extension UIStoryboard {
    static func main() -> UIStoryboard {
        return UIStoryboard(name: "Main", bundle: nil)
    }
}

extension UIView {
    static var nib: UINib {
        let className = String(describing: self)
        return UINib(nibName: className, bundle: nil)
    }
}

extension String {
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }
}

extension UIViewController {
    func showPlainAlert(withMessage message: String, andTitle title: String, completion: ((UIAlertAction) -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: completion)
        alert.addAction(okAction)
        DispatchQueue.main.async { [weak self] in
            if let nav = self?.navigationController {
                nav.present(alert, animated: true, completion: nil)
            } else {
                self?.present(alert, animated: true, completion: nil)
            }
        }
    }
}

extension Double {
    var prettyNumber: String {
        let formatter = NumberFormatter()
        formatter.decimalSeparator = ","
        formatter.maximumFractionDigits = 0
        formatter.currencyDecimalSeparator = ","
        formatter.numberStyle = .decimal
        let formatted = formatter.string(from: NSNumber(floatLiteral: self)) ?? "\(self.rounded())"
        return formatted
    }
}

extension String {
    func textWithoutMarks() -> String {
        return folding(options: .diacriticInsensitive, locale: nil)
    }
}

extension UITableView {
    func setEmptyMessage(emptyMessage: String) {
        let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
        messageLabel.text = emptyMessage
        messageLabel.textColor = .black
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        messageLabel.font = .systemFont(ofSize: 18, weight: .medium)
        messageLabel.sizeToFit()
        backgroundView = messageLabel
    }
    
    func removeEmptyMessage() {
        backgroundView = nil
    }
}
