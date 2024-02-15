//
//  TransactionVC.swift
//  SprintForm
//
//  Created by Zsolt Magyi on 2024.02.15.
//

import UIKit

class TransactionsVC: UIViewController {
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var categoryCollection: UICollectionView!
    @IBOutlet weak var transactionTableView: UITableView!
    
    @IBOutlet weak var categoryHeightConst: NSLayoutConstraint!
    
    private var transactions = TransactionVM.allTransactions
    private var transactionFilterHandler = TransactionFilterHandler(originalTransactions: TransactionVM.allTransactions)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTransactionTable()
        setupCategoriesCollection()
    }
}

//MARK: - Search bar
extension TransactionsVC: UISearchBarDelegate {
    private func setupSearchbar() {
        searchBar.delegate = self
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchForText(searchBar.text)
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
        showCategories(true)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = nil
        searchBar.setShowsCancelButton(false, animated: true)
        searchBar.resignFirstResponder()
        searchForText(nil)
        showCategories(false)
    }
    
    private func searchForText(_ text: String?) {
        if let txt = text, !txt.isEmpty {
            transactionFilterHandler.applySearchTerm(term: txt)
            transactions = transactionFilterHandler.filteredList
        } else {
            transactionFilterHandler.removeSearchTerm()
            transactions = transactionFilterHandler.filteredList
        }
        reloadTable()
    }
}

//MARK: - Tableview: Transactions history
extension TransactionsVC: UITableViewDataSource, UITableViewDelegate {
    private func setupTransactionTable() {
        transactionTableView.dataSource = self
        transactionTableView.delegate = self
        transactionTableView.register(TransactionCell.nib, forCellReuseIdentifier: TransactionCell.cellID)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if transactions.count == 0 {
            tableView.setEmptyMessage(emptyMessage: "empty_transaction_list".localized)
        } else {
            tableView.removeEmptyMessage()
        }
        return transactions.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TransactionCell.cellID, for: indexPath) as! TransactionCell
        cell.setupTransactionCell(transaction: transactions[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return TransactionCell.kCellHeight
    }
    
    private func reloadTable() {
        transactionTableView.reloadData()
    }
}

//MARK: - Collection view: Transactions  category aggregated
extension TransactionsVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    private func setupCategoriesCollection() {
        categoryCollection.delegate = self
        categoryCollection.dataSource = self
        categoryCollection.register(TransactionCategoryCell.nib, forCellWithReuseIdentifier: TransactionCategoryCell.cellID)
    }
    
    private func showCategories(_ shouldShow: Bool) {
        if shouldShow {
            categoryHeightConst.constant = TransactionCategoryCell.kCellHeight
            UIView.animate(withDuration: 0.3) { [weak self] in
                self?.view.layoutIfNeeded()
                self?.categoryCollection.alpha = 1
            }
        } else {
            categoryHeightConst.constant = 0
            UIView.animate(withDuration: 0.3) { [weak self] in
                self?.view.layoutIfNeeded()
                self?.categoryCollection.alpha = 0
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return TransactionCategory.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TransactionCategoryCell.cellID, for: indexPath) as! TransactionCategoryCell
        let category = TransactionCategory.allCases[indexPath.row]
        let isSelected = transactionFilterHandler.selectedCategory == category
        cell.setupTransactionCell(category: category, isSelected: isSelected)
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let category = TransactionCategory.allCases[indexPath.row]
        return CGSize(width: TransactionCategoryCell.kCellHorizontalMargins + category.categoryCellContentWidth,
                      height: TransactionCategoryCell.kCellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedCategory = TransactionCategory.allCases[indexPath.row]
        
        if transactionFilterHandler.selectedCategory == selectedCategory {
            transactionFilterHandler.selectCategory(category: nil)
        } else {
            transactionFilterHandler.selectCategory(category: selectedCategory)
        }
        transactions = transactionFilterHandler.filteredList
        reloadCollection()
        reloadTable()
    }
    
    private func reloadCollection() {
        categoryCollection.reloadData()
    }
}
