//
//  SplashVC.swift
//  SprintForm
//
//  Created by Zsolt Magyi on 2024.02.15.
//

import UIKit

class SplashVC: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        initiateTransactionDownload()
    }
}

//MARK: - Private helpers
extension SplashVC {
    private func initiateTransactionDownload() {
        downloadTransactions { [weak self] hasError in
            if let error = hasError {
                self?.showPlainAlert(withMessage: error, andTitle: "Error", completion: { _ in
                    self?.initiateTransactionDownload()
                })
            } else {
                self?.presentMainScreen()
            }
        }
    }
    
    private func downloadTransactions(completion: @escaping (_ hasError: String?) -> Void) {
        Networking.shared.downloadTransactions(completion: { transactions, error in
            if let error = error {
                completion(error.localizedDescription)
            } else if let transactions = transactions {
                let sorted = transactions.sorted {
                    guard let d1 = $0.date, let d2 = $1.date else { return false }
                    return d1 > d2
                }
                TransactionVM.allTransactions = sorted
                completion(nil)
            } else {
                completion("No error and no transactions either")
            }
        })
    }
    
    private func presentMainScreen() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {  [weak self] in
            if let tabVC = self?.storyboard?.instantiateViewController(withIdentifier: MainTabVC.storyboardID) {
                tabVC.modalPresentationStyle = .custom
                tabVC.transitioningDelegate = self
                self?.present(tabVC, animated: true)
            }
        }
    }
}

//MARK: - Transition manager
extension SplashVC: UIViewControllerTransitioningDelegate, UIViewControllerAnimatedTransitioning {
    private var transitionDuration: Double {
        return 0.5
    }
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return nil
    }

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return transitionDuration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromVC = transitionContext.viewController(forKey: .from),
              let toVC = transitionContext.viewController(forKey: .to),
              let fromView = fromVC.view,
              let toView = toVC.view else { return}
            
        let containerView = transitionContext.containerView

        containerView.addSubview(toView)
        containerView.addSubview(fromView)
        
        let height = toView.frame.height
        toView.transform = CGAffineTransform(translationX: 0, y: height)
        
        UIView.animate(withDuration: transitionDuration) {
            toView.transform = .identity
            fromView.transform = CGAffineTransform(translationX: 0, y: -height)
        } completion: { _ in
            transitionContext.completeTransition(true) }
    }
}
