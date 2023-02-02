//
//  ShopFilterViewController.swift
//  KreamWaffleApp
//
//  Created by 이선재 on 2023/01/28.
//

import UIKit
import RxSwift
import RxCocoa

class ShopFilterViewController: UIViewController, UIScrollViewDelegate {
    private let viewModel: ShopViewModel
    private let disposeBag = DisposeBag()
    
    private let tableView = UITableView()
    private let showResultsButton = UIButton()
    
    var selectedBrand = ""
    var selectedPrice = ""
    
    init(viewModel: ShopViewModel) {
        self.viewModel = viewModel
        self.viewModel.requestBrandData()
        super.init(nibName: nil, bundle: nil)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        setUpNavigationBar()
        setUpNavigationBarButtons()
        bindTableView()
        setUpTableView()
        setUpShowResultsButton()
        
        // add observer for selectedBrand and selectedPrice

    }
    
    private func setUpNavigationBar() {
        self.navigationItem.title = "필터"
        self.navigationItem.titleView?.tintColor = .black
        self.navigationController?.navigationBar.backgroundColor = .white
        self.navigationController?.navigationBar.scrollEdgeAppearance?.backgroundColor = .white
//        self.navigationItem.titleView?.backgroundColor = .white
//        self.navigationItem.backBarButtonItem = UIBarButtonItem(image: UIImage(named: "arrow.backward"), style: .plain, target: self, action: nil)
        self.setUpBackButton()
    }
    
    private func setUpNavigationBarButtons() {
        //configure cancel button
        let cancelButton = UIBarButtonItem(title: "취소", style: .plain, target: self, action: #selector(cancelButtonTapped))
        cancelButton.tintColor = .black
        navigationItem.leftBarButtonItem = cancelButton
        
        //configure delete all button
        let deleteAllButton = UIBarButtonItem(title: "모두 삭제", style: .plain, target: self, action: #selector(deleteAllButtonTapped))
        deleteAllButton.tintColor = .lightGray
        navigationItem.rightBarButtonItem = deleteAllButton
    }
    
    private func bindTableView() {
        self.tableView.register(ShopFilterTableViewCell.self, forCellReuseIdentifier: "ShopFilterTableViewCell")
        
        self.tableView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        
        self.viewModel.filterItemDataSource
            .bind(to: self.tableView.rx.items(cellIdentifier: "ShopFilterTableViewCell", cellType: ShopFilterTableViewCell.self)) { index, shopFilterItem, cell in
                cell.configure(cellModel: shopFilterItem)
            }.disposed(by: self.disposeBag)
    }
    
    private func setUpTableView() {
        self.tableView.backgroundColor = .white
        
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
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension ShopFilterViewController {
    @objc func cancelButtonTapped() {
        self.dismiss(animated: true)
    }
    
    @objc func deleteAllButtonTapped() {
        print("delete all button tapped")
    }
    
    @objc func showResultsButtonTapped() {
        print("결과 보기 tapped")
    }
}

extension ShopFilterViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var selectedFilterItem = self.viewModel.getFilterItemAtIndex(index: indexPath.row)
        
        let shopFilterDetailVC = ShopFilterDetailViewController(viewModel: viewModel, index: indexPath.row)
        navigationController?.pushViewController(shopFilterDetailVC, animated: true)
    }
}
