//
//  ViewController.swift
//  SprintForm
//
//  Created by Zsolt Magyi on 2024.02.15.
//

import UIKit

class DashboardVC: UIViewController {
    @IBOutlet weak var transactionsTableView: UITableView!
    @IBOutlet weak var categoriesCollection: UICollectionView!
    @IBOutlet weak var monthPanelView: UIView!
    @IBOutlet weak var monthlyCostLabel: UILabel!
    @IBOutlet weak var mostSpentPanelView: UIView!
    
    @IBOutlet weak var scrollHeightConst: NSLayoutConstraint!
    @IBOutlet weak var transactionTableHeightCons: NSLayoutConstraint!
    
    private var transactions: [TransactionVM] = []
    private var aggregatedCategories: [String: Int] = [:]
    private var aggregatedSortedKeys: [String] = []
    private var kNumberOfTransactions = 5
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        getTransactions()
        setupTransactionTable()
        calculateAllCostPerMonth()
        
        calculateCategoryCostsPerMonth()
        setupCategoriesCollection()
    }

    @IBAction func showAllTransactions(_ sender: Any) {
        navigateToTransactions()
    }
}

//MARK: - Private helpers
extension DashboardVC {
    private func setupLayout() {
        setupScroller()
        setupSummaryViews()
        
        func setupSummaryViews() {
            monthPanelView.layer.cornerRadius = 20
            monthPanelView.layer.masksToBounds = true
            mostSpentPanelView.layer.cornerRadius = 20
            mostSpentPanelView.layer.masksToBounds = true
        }
        
        func setupScroller() {
            let height = transactionsTableView.frame.origin.y + CGFloat(kNumberOfTransactions) * TransactionCell.kCellHeight + 50
            scrollHeightConst.constant = height
            view.layoutIfNeeded()
        }
    }

    private func getTransactions() {
        transactions = TransactionVM.allTransactions
        //TODO: UNCOMMENT ME
//        self.transactions = TransactionVM.allTransactions.sorted(by: {
//            guard let d1 = $0.date, let d2 = $1.date else { return false }
//            return d1 > d2
//        })
    }
    
    private func calculateCategoryCostsPerMonth() {
        transactions.forEach {
            if let category = $0.category?.rawValue {
                if let existingCategory = aggregatedCategories[category] {
                    aggregatedCategories[category] = existingCategory + $0.sum
                } else {
                    aggregatedCategories[category] = $0.sum
                }
            }
        }
        
        aggregatedSortedKeys = aggregatedCategories.keys.sorted { key1, key2 in
               return aggregatedCategories[key1]! > aggregatedCategories[key2]!
           }
    }
    
    private func setupTransactionTable() {
        setupTable()
        setupHeight()
        
        func setupTable() {
            transactionsTableView.dataSource = self
            transactionsTableView.delegate = self
            transactionsTableView.register(TransactionCell.nib, forCellReuseIdentifier: TransactionCell.cellID)
            transactionsTableView.reloadData()
        }
        
        func setupHeight() {
            transactionTableHeightCons.constant = TransactionCell.kCellHeight * CGFloat(kNumberOfTransactions)
            view.layoutIfNeeded()
        }
    }
    
    private func calculateAllCostPerMonth() {
        let total = transactions.map({ Double($0.sum) }).reduce(0, { $0 + $1 })
        monthlyCostLabel.text = total.prettyNumber + "HUF"
    }
    
    private func setupCategoriesCollection() {
        categoriesCollection.delegate = self
        categoriesCollection.dataSource = self
        categoriesCollection.register(TransactionCategoryCell.nib, forCellWithReuseIdentifier: TransactionCategoryCell.cellID)
        categoriesCollection.reloadData()
    }
    
    private func navigateToTransactions() {
        if let mainTab = tabBarController as? MainTabVC {
            mainTab.selectTransactions()
        }
    }
}

//MARK: - Tableview: Transactions history
extension DashboardVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return kNumberOfTransactions
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TransactionCell.cellID, for: indexPath) as! TransactionCell
        cell.setupTransactionCell(transaction: transactions[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return TransactionCell.kCellHeight
    }
}

//MARK: - Collection view: Transactions  category aggregated
extension DashboardVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return aggregatedCategories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TransactionCategoryCell.cellID, for: indexPath) as! TransactionCategoryCell
        let sortedCategoryKey = aggregatedSortedKeys[indexPath.row]
        if let category = TransactionCategory(rawValue: sortedCategoryKey) {
            var spent = aggregatedCategories[category.rawValue] ?? 0
            var spentOnCategory = Double(spent).prettyNumber + "HUF"
            if spent == 0 {
                spentOnCategory = "0HUF"
            }
            cell.setupTransactionCell(category: category, spentOnCategory: spentOnCategory)
        }
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let sortedCategoryKey = aggregatedSortedKeys[indexPath.row]
        if let category = TransactionCategory(rawValue: sortedCategoryKey) {
            return CGSize(width: TransactionCategoryCell.kCellHorizontalMargins + category.categoryCellContentWidth,
                          height: TransactionCategoryCell.kCellHeight)
        }
        
        return CGSize(width: 100, height: TransactionCategoryCell.kCellHeight)
    }
}
