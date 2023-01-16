//
//  HomeTabViewController.swift
//  KreamWaffleApp
//
//  Created by 이선재 on 2022/12/24.
//

import UIKit
import RxSwift
import RxCocoa

class HomeTabViewController: UIViewController {
    private let viewModel: HomeViewModel
    private let disposeBag = DisposeBag()
    private var justDroppedCollectionViewVC: HomeTabShopCollectionViewVC
    private var stylePicksCollectionViewVC: HomeTabStyleCollectionViewVC
    private var brandsCollectionViewVC: HomeTabBrandsCollectionViewVC
    
    init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
        justDroppedCollectionViewVC = HomeTabShopCollectionViewVC()
        stylePicksCollectionViewVC = HomeTabStyleCollectionViewVC()
        brandsCollectionViewVC = HomeTabBrandsCollectionViewVC()
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigationBar()
        setUpButtons()
        setUpChildVC()
    }
    
    func setUpNavigationBar() {
        self.navigationItem.title = "투데이"
//        self.setUpBackButton()
    }
    
    func setUpButtons() {
        //configure search button
        let bellImage = UIImage(systemName: "bell")
        let tintedBellImage = bellImage?.withRenderingMode(.alwaysTemplate)
        let notificationButton = UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(notificationButtonTapped))
        notificationButton.image = tintedBellImage
        notificationButton.tintColor = .black
        navigationItem.rightBarButtonItem = notificationButton
        
    }
    
    func setUpChildVC() {
        // Just Dropped 발매 상품
        self.view.addSubview(justDroppedCollectionViewVC.view)
        self.addChild(justDroppedCollectionViewVC)
        justDroppedCollectionViewVC.didMove(toParent: self)
        
        justDroppedCollectionViewVC.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.justDroppedCollectionViewVC.view.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            self.justDroppedCollectionViewVC.view.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
            self.justDroppedCollectionViewVC.view.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            self.justDroppedCollectionViewVC.view.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 200),
        ])
        
        // Brands 브랜드
        self.view.addSubview(brandsCollectionViewVC.view)
        self.addChild(brandsCollectionViewVC)
        brandsCollectionViewVC.didMove(toParent: self)
        
        brandsCollectionViewVC.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.brandsCollectionViewVC.view.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            self.brandsCollectionViewVC.view.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
            self.brandsCollectionViewVC.view.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 200),
            self.brandsCollectionViewVC.view.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 200),
        ])
        
        // Style Picks
        self.view.addSubview(stylePicksCollectionViewVC.view)
        self.addChild(stylePicksCollectionViewVC)
        stylePicksCollectionViewVC.didMove(toParent: self)
        
        stylePicksCollectionViewVC.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.stylePicksCollectionViewVC.view.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            self.stylePicksCollectionViewVC.view.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
            self.stylePicksCollectionViewVC.view.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 90),
            self.stylePicksCollectionViewVC.view.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 150),
        ])
    }
    
    @objc func notificationButtonTapped() {
        print("notification button tapped")
    }

}
