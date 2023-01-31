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
    
    private let tableView = UITableView()
    private let showResultsButton = UIButton()
    
    // variables
    private var numberOfResults: Int = 0
    
    init(viewModel: ShopViewModel, index: Int) {
        self.viewModel = viewModel
        self.index = index
//        self.shopFilterItem = viewModel.getFilterItemAtIndex(index: index)
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
        setUpShowResultsButton()
    }
    
    private func setUpNavigationBar() {
        self.navigationController?.navigationBar.tintColor = .black
        if index == 0 {
            self.navigationItem.title = "브랜드"
        } else if index == 1 {
            self.navigationItem.title = "가격"
        }
        
    }
    
    private func setUpNavigationBarButtons() {
        //configure delete all button
        let deleteAllButton = UIBarButtonItem(title: "삭제", style: .plain, target: self, action: #selector(deleteAllButtonTapped))
        deleteAllButton.tintColor = .lightGray
        navigationItem.rightBarButtonItem = deleteAllButton
    }
    
    private func bindTableView() {
        self.tableView.register(ShopFilterDetailTableViewCell.self, forCellReuseIdentifier: "ShopFilterDetailTableViewCell")
        
        self.tableView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        
        if index == 0 { // brand filter
            let filterItemListDataSource = self.viewModel.brandFilterItemListDataSource
            filterItemListDataSource
                .bind(to: self.tableView.rx.items(cellIdentifier: "ShopFilterDetailTableViewCell", cellType: ShopFilterDetailTableViewCell.self)) { index, brand, cell in
                    cell.configure(header: brand.name)
                }.disposed(by: self.disposeBag)
        } else if index == 1 { // price filter
            let filterItemListDataSource = self.viewModel.priceFilterItemListDataSource
            filterItemListDataSource
                .bind(to: self.tableView.rx.items(cellIdentifier: "ShopFilterDetailTableViewCell", cellType: ShopFilterDetailTableViewCell.self)) { index, price, cell in
                    cell.configure(header: price)
                }.disposed(by: self.disposeBag)
        }
        

    }
    
    private func setUpTableView() {
        self.tableView.backgroundColor = .white
        self.tableView.allowsMultipleSelection = true
        
        self.view.addSubview(tableView)
        self.tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.tableView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 10),
            self.tableView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
            self.tableView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            self.tableView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -10)
        ])
    }
    
    private func setUpShowResultsButton() {
        self.view.addSubview(showResultsButton)
        showResultsButton.setTitle("결과 보기", for: .normal)
        showResultsButton.addTarget(self, action: #selector(showResultsButtonTapped), for: .touchUpInside)
        showResultsButton.contentHorizontalAlignment = .center
        showResultsButton.tintColor = .white
        showResultsButton.backgroundColor = .black
        showResultsButton.layer.borderWidth = 1
        showResultsButton.layer.cornerRadius = 9.5
        
        showResultsButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            showResultsButton.heightAnchor.constraint(equalToConstant: 50),
//            self.categoryFilterButton.widthAnchor.constraint(equalToConstant: 45),
            showResultsButton.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -60),
            showResultsButton.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
            showResultsButton.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            showResultsButton.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -10)
        ])
    }

}

extension ShopFilterDetailViewController {
    @objc func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func deleteAllButtonTapped() {
        print("delete all button tapped")
    }
    
    @objc func showResultsButtonTapped() {
        self.dismiss(animated: true)
    }
    
    func updateNumberOfResults() {
        for idPath in tableView.indexPathsForSelectedRows! {
//            let selectedFilterItem = self.viewModel.getFilterItemAtIndex(index: <#T##Int#>)
            print(idPath.row)
        }
        
    }
    
}

extension ShopFilterDetailViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedBrandId = indexPath.row + 1
        self.viewModel.requestBrandShopPostsData(selectedBrand: selectedBrandId)
//        updateNumberOfResults()
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
//        updateNumberOfResults()
    }
}
