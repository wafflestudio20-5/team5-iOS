//
//  ShopFilterDetailViewController.swift
//  KreamWaffleApp
//
//  Created by 이선재 on 2023/01/30.
//

import UIKit
import RxSwift
import RxCocoa

class ShopFilterDetailViewController: UIViewController, UIScrollViewDelegate {
    private let viewModel: ShopViewModel
    private let index: Int
    private let disposeBag = DisposeBag()
    
    private var deleteAllButton = UIBarButtonItem()
    private let tableView = UITableView()
    
    // variables
    private var numberOfResults: Int = 0
    
    init(viewModel: ShopViewModel, index: Int) {
        self.viewModel = viewModel
        self.index = index
        super.init(nibName: nil, bundle: nil)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        setUpNavigationBar()
        setUpNavigationBarButtons()
        bindTableView()
        setUpTableView()
    }
    
    private func setUpNavigationBar() {
        self.navigationController?.navigationBar.tintColor = .black
        if index == 0 {
            self.navigationItem.title = "카테고리"
            self.viewModel.setSelectedCategory(category: nil)
        } else if index == 1 {
            self.navigationItem.title = "브랜드"
            self.viewModel.setSelectedBrands(brands: nil)
        } else if index == 2 {
            self.navigationItem.title = "가격"
            self.viewModel.setSelectedPrices(prices: nil)
        }
    }
    
    private func setUpNavigationBarButtons() {
        //configure delete all button
        deleteAllButton = UIBarButtonItem(title: "삭제", style: .plain, target: self, action: #selector(deleteAllButtonTapped))
        deleteAllButton.isEnabled = false
        deleteAllButton.tintColor = .black
        navigationItem.rightBarButtonItem = deleteAllButton
    }
    
    private func bindTableView() {
        self.tableView.register(ShopFilterDetailTableViewCell.self, forCellReuseIdentifier: "ShopFilterDetailTableViewCell")
        
        self.tableView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        
        if index == 0 { // category filter
            let filterItemListDataSource = self.viewModel.categoryFilterItemListDataSource
            filterItemListDataSource
                .bind(to: self.tableView.rx.items(cellIdentifier: "ShopFilterDetailTableViewCell", cellType: ShopFilterDetailTableViewCell.self)) { index, category, cell in
                    cell.configure(header: category)
                }.disposed(by: self.disposeBag)
        } else if index == 1 { // brand filter
            let filterItemListDataSource = self.viewModel.brandFilterItemListDataSource
            filterItemListDataSource
                .bind(to: self.tableView.rx.items(cellIdentifier: "ShopFilterDetailTableViewCell", cellType: ShopFilterDetailTableViewCell.self)) { index, brand, cell in
                    cell.configure(header: brand.name)
                }.disposed(by: self.disposeBag)
        } else if index == 2 { // price filter
            let filterItemListDataSource = self.viewModel.priceFilterItemListDataSource
            filterItemListDataSource
                .bind(to: self.tableView.rx.items(cellIdentifier: "ShopFilterDetailTableViewCell", cellType: ShopFilterDetailTableViewCell.self)) { index, price, cell in
                    cell.configure(header: price)
                }.disposed(by: self.disposeBag)
            
        }
    }
    
    private func setUpTableView() {
        if index == 0 {
            self.tableView.allowsMultipleSelection = false
        } else {
            self.tableView.allowsMultipleSelection = true
        }
        
        self.tableView.backgroundColor = .white
        self.tableView.showsVerticalScrollIndicator = false
        
        self.view.addSubview(tableView)
        self.tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.tableView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 10),
            self.tableView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
            self.tableView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            self.tableView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -10)
        ])
    }
    
    private func validateDeleteButton() {
        if tableView.indexPathsForSelectedRows == nil {
            self.deleteAllButton.isEnabled = false
        } else {
            self.deleteAllButton.isEnabled = true
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if self.isMovingFromParent {
           
            
            let indexPathsForSelectedRows = tableView.indexPathsForSelectedRows
            if indexPathsForSelectedRows != nil {
                if (index == 0 || index == 2) {
                    var filterSelectionList: [String] = []
                    for idPath in tableView.indexPathsForSelectedRows! {
                        let selectedFilterItemAtRow = self.viewModel.getFilterItemRowAtIndex(filterItemIndex: index, rowIndex: idPath.row)
                        filterSelectionList.append(selectedFilterItemAtRow)
                    }
                    
                    // NotificationCenter (send selected fields)
                    NotificationCenter.default.post(name: NSNotification.Name("filterSelections"),
                                                    object: [
                                                        "index": index,
                                                        "filterSelections": filterSelectionList,
                                                    ],
                                                    userInfo: nil)
                } else if index == 1 {
                    var filterSelectionList: [Brand] = []
                    for idPath in tableView.indexPathsForSelectedRows! {
                        let selectedFilterItemAtRow = self.viewModel.getBrandFilterItemRowAtIndex(filterItemIndex: index, rowIndex: idPath.row)
                        filterSelectionList.append(selectedFilterItemAtRow)
                    }
                    
                    // NotificationCenter (send selected fields)
                    NotificationCenter.default.post(name: NSNotification.Name("brandFilterSelections"),
                                                    object: [
                                                        "index": index,
                                                        "filterSelections": filterSelectionList,
                                                    ],
                                                    userInfo: nil)
                }
            } else {
                // no fields were selected
                switch index {
                case 0:
                    self.viewModel.setSelectedCategory(category: nil)
                case 1:
                    self.viewModel.setSelectedBrands(brands: nil)
                case 2:
                    self.viewModel.setSelectedPrices(prices: nil)
                default:
                    return
                }
                
                NotificationCenter.default.post(name: NSNotification.Name("filterSelectionsNil"),
                                                object: [
                                                    "index": index
                                                ],
                                                userInfo: nil)
                
            
            }
            
            
        }
    }
}

extension ShopFilterDetailViewController {
    @objc func deleteAllButtonTapped() {
        guard let selectedRows = tableView.indexPathsForSelectedRows else { return }
        for indexPath in selectedRows { tableView.deselectRow(at: indexPath, animated: true) }
        deleteAllButton.isEnabled = false
    }
    
}

extension ShopFilterDetailViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        validateDeleteButton()

    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        

    }
}

extension ShopFilterDetailViewController {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let position = scrollView.contentOffset.y
        if (position > (self.tableView.contentSize.height - 5 - scrollView.frame.size.height)) {
            self.viewModel.requestBrandData(resetPage: false)
        }
    }
}
