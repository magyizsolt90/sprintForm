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
        //TODO: REMOVE MOCK
        let t1 = Transaction(id: "2324", summary: "this is a test", category: "food", sum: 350, currency: "huf", paid: "2022-04-20T01:16:00Z")
        let t2 = Transaction(id: "2573", summary: "Lakber", category: "housing", sum: 180000, currency: "huf", paid: "2022-04-21T11:48:00Z")
        let t3 = Transaction(id: "30it0", summary: "BKV berlet", category: "travel", sum: 9990, currency: "huf", paid: "2022-03-01T10:13:00Z")
        let t4 = Transaction(id: "ko43t", summary: "H&M", category: "lifestyle", sum: 14990, currency: "huf", paid: "2022-04-11T11:17:00Z")
        let t5 = Transaction(id: "sokt4", summary: "McDonald's", category: "food", sum: 2950, currency: "huf", paid: "2022-04-19T03:11:00Z")
        let t6 = Transaction(id: "sg4s34", summary: "Electricity bill", category: "utilities", sum: 4760, currency: "huf", paid: "2022-04-02T20:06:00Z")
        let t7 = Transaction(id: "sg43g", summary: "Part mix", category: "entertainment", sum: 2394, currency: "huf", paid: "2022-04-01T20:06:00Z")
        let t8 = Transaction(id: "set3r", summary: "Random", category: "miscellaneous", sum: 1234, currency: "huf", paid: "2022-04-22T20:06:00Z")
        
        let trs = [t1, t2, t3, t4, t5, t6, t7, t8].map({ TransactionVM(with: $0) })
        let sorted = trs.sorted {
            guard let d1 = $0.date, let d2 = $1.date else { return false }
            return d1 > d2
        }
        TransactionVM.allTransactions = sorted
        presentMainScreen()
        
        //TODO: UNCOMMENT
//        downloadTransactions { [weak self] hasError in
//            if let error = hasError {
//                self?.showPlainAlert(withMessage: error, andTitle: "Error", completion: { _ in
//                    self?.initiateTransactionDownload()
//                })
//            } else {
//                self?.presentMainScreen()
//            }
//        }
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
