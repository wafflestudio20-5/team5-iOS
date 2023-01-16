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
    
    // main views
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    // sub collection views
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
        setUpScrollView()
        setUpNavigationBar()
        setUpButtons()
        setUpChildVC()
    }
    
    func setUpNavigationBar() {
        self.navigationItem.title = "투데이"
//        self.setUpBackButton()
    }
    
    func setUpScrollView() {
        view.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
        
        scrollView.addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            contentView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            contentView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor, constant: -100)
        ])
        
        contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true

        let contentViewHeight = contentView.heightAnchor.constraint(greaterThanOrEqualTo: view.heightAnchor)
        contentViewHeight.priority = .defaultLow
        contentViewHeight.isActive = true
        scrollView.showsVerticalScrollIndicator = false
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
        self.contentView.addSubview(justDroppedCollectionViewVC.view)
//        content.addChild(justDroppedCollectionViewVC)
//        justDroppedCollectionViewVC.didMove(toParent: self)
        
        justDroppedCollectionViewVC.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.justDroppedCollectionViewVC.view.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            self.justDroppedCollectionViewVC.view.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
            self.justDroppedCollectionViewVC.view.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            self.justDroppedCollectionViewVC.view.bottomAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 300),
        ])
        
        // Brands 브랜드
        self.contentView.addSubview(brandsCollectionViewVC.view)
//        self.addChild(brandsCollectionViewVC)
//        brandsCollectionViewVC.didMove(toParent: self)
        
        brandsCollectionViewVC.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.brandsCollectionViewVC.view.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            self.brandsCollectionViewVC.view.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
            self.brandsCollectionViewVC.view.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 300),
            self.brandsCollectionViewVC.view.bottomAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 600),
        ])
        
        // Style Picks
        self.contentView.addSubview(stylePicksCollectionViewVC.view)
//        self.addChild(stylePicksCollectionViewVC)
//        stylePicksCollectionViewVC.didMove(toParent: self)
        
        stylePicksCollectionViewVC.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.stylePicksCollectionViewVC.view.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            self.stylePicksCollectionViewVC.view.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
            self.stylePicksCollectionViewVC.view.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 600),
            self.stylePicksCollectionViewVC.view.bottomAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 900),
        ])
    }
    
    @objc func notificationButtonTapped() {
        print("notification button tapped")
    }

}
