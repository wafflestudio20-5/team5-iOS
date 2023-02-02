//
//  ShopTabViewController.swift
//  KreamWaffleApp
//
//  Created by 이선재 on 2022/12/24.
//
import UIKit
import RxSwift
import RxCocoa

class ShopTabViewController: UIViewController, UIScrollViewDelegate {
    //서치하지 않을때 서치할때 아래 view controller 를 갈아끼우기
    
    private var searchVC : SearchViewController
    private var shopVC : ShopMainViewController
    
    var header = UIView()
    var searchBar = UISearchBar()
    
    // category filtering
    private let categoryFilterButton = UIButton()
    private let categoryCollectionView = UICollectionView(frame: .zero, collectionViewLayout: ShopCategoryCollectionViewFlowLayout())

    
    // delivery tag filter buttons
    private let immediateDeliveryButton = UIButton()
    private let brandDeliveryButton = UIButton()
    
    // collection views
    private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: ShopCollectionViewFlowLayout())
    
    private let viewModel: ShopViewModel
    private let disposeBag = DisposeBag()
    
    // colors
    static let deliveryButtonBorderColor: UIColor = UIColor(red: 0.8863, green: 0.8863, blue: 0.8863, alpha: 1.0)
    static let brandDeliveryButtonSelectedColor: UIColor = ProductCollectionViewCell.brandDeliveryFontColor
    
    // delivery buttons variable
    
    
    init(viewModel: ShopViewModel) {
        self.searchVC = SearchViewController()
        self.shopVC = ShopMainViewController()
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
  

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        addSubviews()
        configureSubviews()
        configureCategoryFilterButton()
        configureCategoryCollectionView()
        
        configureDeliveryFilterButtons()
        bindCategoryCollectionView()
        setupCollectionView()
        bindCollectionView()
    }
    
    func addSubviews(){
        self.view.addSubview(searchBar)
        self.view.addSubview(collectionView)
    }
    
    func configureSubviews(){
        configureSearchBar()
        configureChildVC()
    }
    
    func configureChildVC(){
        self.add(searchVC)
        self.searchVC.view.frame = CGRect(x: 0, y: self.searchBar.frame.maxY, width: self.view.frame.width, height: self.view.frame.height)
        self.add(shopVC)
        self.shopVC.view.frame = CGRect(x: 0, y: self.searchBar.frame.maxY, width: self.view.frame.width, height: self.view.frame.height)
        searchVC.view.isHidden = true
    }
    
    private func configureSearchBar(){
        self.searchBar.frame = CGRect(x: 0, y: 0, width: view.frame.width - 80, height: 0)
        self.searchBar.searchTextField.addTarget(self, action: #selector(didTapSearchBar), for: .editingDidBegin)
        
        self.navigationItem.titleView = self.searchBar
        self.navigationItem.titleView?.backgroundColor = .white
        let emptyImage = UIImage()
        self.searchBar.setImage(emptyImage, for: .search, state: .normal)
        self.searchBar.searchTextField.attributedPlaceholder = NSAttributedString(string: "브랜드명, 모델명, 모델번호 등", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14, weight: .light)])
        self.searchBar.searchTextField.textColor = .black
        self.searchBar.layer.borderColor = UIColor.clear.cgColor
        self.searchBar.searchTextField.font = UIFont.systemFont(ofSize: 14, weight: .medium)
    }
    
    private func configureCategoryFilterButton() {
        self.categoryFilterButton.setImage(UIImage(systemName: "slider.horizontal.3"), for: .normal)
        self.categoryFilterButton.addTarget(self, action: #selector(tappedCategoryFilterButton), for: .touchUpInside)
        self.categoryFilterButton.contentHorizontalAlignment = .center
        self.categoryFilterButton.tintColor = CategoryCollectionViewCell.unselectedTextColor
        self.categoryFilterButton.backgroundColor = CategoryCollectionViewCell.unselectedBgColor
        self.categoryFilterButton.layer.borderColor = CategoryCollectionViewCell.unselectedBgColor.cgColor
        self.categoryFilterButton.layer.borderWidth = 1
        self.categoryFilterButton.layer.cornerRadius = 9.5
        
        self.view.addSubview(self.categoryFilterButton)
        self.categoryFilterButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.categoryFilterButton.heightAnchor.constraint(equalToConstant: 35),
            self.categoryFilterButton.widthAnchor.constraint(equalToConstant: 45),
            self.categoryFilterButton.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            self.categoryFilterButton.bottomAnchor.constraint(equalTo: self.categoryFilterButton.topAnchor, constant: 50),
            self.categoryFilterButton.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 15),
//            self.categoryFilterButton.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 55)
        ])
    }
    
    private func configureCategoryCollectionView() {
        self.categoryCollectionView.showsHorizontalScrollIndicator = false
        self.categoryCollectionView.backgroundColor = .white
        
        self.view.addSubview(self.categoryCollectionView)
        self.categoryCollectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.categoryCollectionView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            self.categoryCollectionView.bottomAnchor.constraint(equalTo: self.categoryFilterButton.bottomAnchor),
            self.categoryCollectionView.leadingAnchor.constraint(equalTo: self.categoryFilterButton.trailingAnchor, constant: 10),
            self.categoryCollectionView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -15)
        ])
    }
    
    private func configureDeliveryFilterButtons() {
        // immediate delivery button
        let attributedDeliveryString1 = NSMutableAttributedString(string: "빠른배송", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 13.0)])
        let deliveryTagImageAttachment = NSTextAttachment()
        deliveryTagImageAttachment.image = UIImage(systemName: "bolt.fill")?.withTintColor(ProductCollectionViewCell.immediateDeliveryFontColor)
        deliveryTagImageAttachment.bounds = CGRect(x: 0, y: 0, width: 13, height: 13)
        let attributedDeliveryString2 = NSMutableAttributedString(attachment: deliveryTagImageAttachment)
        attributedDeliveryString2.append(attributedDeliveryString1)
        self.immediateDeliveryButton.setAttributedTitle(attributedDeliveryString2, for: .normal)

        self.immediateDeliveryButton.addTarget(self, action: #selector(tappedImmediateDeliveryButton), for: .touchUpInside)
        self.immediateDeliveryButton.setTitleColor(.black, for: .normal)
        self.immediateDeliveryButton.contentHorizontalAlignment = .center
        self.immediateDeliveryButton.contentVerticalAlignment = .center
        self.immediateDeliveryButton.layer.borderColor = ShopTabViewController.deliveryButtonBorderColor.cgColor
        self.immediateDeliveryButton.layer.borderWidth = 1
        self.immediateDeliveryButton.layer.cornerRadius = 13.5
        
        self.view.addSubview(self.immediateDeliveryButton)
        self.immediateDeliveryButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.immediateDeliveryButton.heightAnchor.constraint(equalToConstant: 25),
            self.immediateDeliveryButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.immediateDeliveryButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 15),
            self.immediateDeliveryButton.trailingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 90),
            self.immediateDeliveryButton.topAnchor.constraint(equalTo: self.categoryCollectionView.bottomAnchor, constant: 7),
        ])
        
        // brand delivery button
        self.brandDeliveryButton.setTitle("브랜드배송", for: .normal)
        self.brandDeliveryButton.addTarget(self, action: #selector(tappedBrandDeliveryButton), for: .touchUpInside)
        self.brandDeliveryButton.setTitleColor(.black, for: .normal)
        self.brandDeliveryButton.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        self.brandDeliveryButton.contentHorizontalAlignment = .center
        self.brandDeliveryButton.layer.borderColor = ShopTabViewController.deliveryButtonBorderColor.cgColor
        self.brandDeliveryButton.layer.borderWidth = 1
        self.brandDeliveryButton.layer.cornerRadius = 13.5
        
        self.view.addSubview(self.brandDeliveryButton)
        self.brandDeliveryButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.brandDeliveryButton.heightAnchor.constraint(equalToConstant: 25),
            self.brandDeliveryButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.brandDeliveryButton.leadingAnchor.constraint(equalTo: self.immediateDeliveryButton.trailingAnchor, constant: 5),
            self.brandDeliveryButton.trailingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 170),
            self.brandDeliveryButton.topAnchor.constraint(equalTo: self.immediateDeliveryButton.topAnchor),
        ])
        
        // configure colors based on selection
//        self.immediateDeliveryButton.isSelected = true
        updateDeliveryButtonConfiguration()
    }
    
    private func updateDeliveryButtonConfiguration() {
        if self.immediateDeliveryButton.isSelected == true {
            self.immediateDeliveryButton.backgroundColor = UIColor(red: 0.898, green: 0.9882, blue: 0.9216, alpha: 1.0)
            self.immediateDeliveryButton.setTitleColor(ProductCollectionViewCell.immediateDeliveryFontColor, for: .selected)
            self.immediateDeliveryButton.layer.borderColor = UIColor.white.cgColor
            
            self.brandDeliveryButton.backgroundColor = .white
            self.brandDeliveryButton.setTitleColor(.black, for: .normal)
            self.brandDeliveryButton.layer.borderColor = ShopTabViewController.deliveryButtonBorderColor.cgColor
        } else if self.brandDeliveryButton.isSelected == true {
            self.immediateDeliveryButton.backgroundColor = .white
            self.immediateDeliveryButton.setTitleColor(.black, for: .normal)
            self.immediateDeliveryButton.layer.borderColor = ShopTabViewController.deliveryButtonBorderColor.cgColor
            
            self.brandDeliveryButton.backgroundColor = ProductCollectionViewCell.brandDeliveryFontColor
            self.brandDeliveryButton.setTitleColor(.white, for: .normal)
            self.brandDeliveryButton.layer.borderColor = UIColor.white.cgColor
        } else {
            self.immediateDeliveryButton.backgroundColor = .white
            self.immediateDeliveryButton.setTitleColor(.black, for: .normal)
            self.immediateDeliveryButton.layer.borderColor = ShopTabViewController.deliveryButtonBorderColor.cgColor
            
            self.brandDeliveryButton.backgroundColor = .white
            self.brandDeliveryButton.setTitleColor(.black, for: .normal)
            self.brandDeliveryButton.layer.borderColor = ShopTabViewController.deliveryButtonBorderColor.cgColor
        }
    }
    
    private func bindCategoryCollectionView() {
        self.categoryCollectionView.register(CategoryCollectionViewCell.self, forCellWithReuseIdentifier: "CategoryCollectionViewCell")
        
        self.categoryCollectionView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        
        self.viewModel.filterDataSource
            .bind(to: self.categoryCollectionView.rx.items(cellIdentifier: "CategoryCollectionViewCell", cellType: CategoryCollectionViewCell.self)) { index, categoryName, cell in
                cell.configure(categoryName: categoryName)
            }.disposed(by: self.disposeBag)
    }
    
    private func setupCollectionView() {
        self.view.addSubview(collectionView)
        self.collectionView.backgroundColor = .white
        self.collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.collectionView.topAnchor.constraint(equalTo: self.immediateDeliveryButton.bottomAnchor, constant: 7),
            self.collectionView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
            self.collectionView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            self.collectionView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }
    
    private func bindCollectionView() {
        self.collectionView.register(ProductCollectionViewCell.self, forCellWithReuseIdentifier: "ProductCollectionViewCell")
        
        self.collectionView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        
        self.viewModel.shopDataSource
            .bind(to: self.collectionView.rx.items(cellIdentifier: "ProductCollectionViewCell", cellType: ProductCollectionViewCell.self)) { index, productData, cell in
                cell.configure(product: productData)
            }.disposed(by: self.disposeBag)
    }
    
    @objc func didTapSearchBar(){
        let cancelButton = UIBarButtonItem(title: "취소", style: .plain, target: self, action: #selector(didTapCancelSearchBar))
        cancelButton.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15, weight: .medium)], for: .normal)
        self.navigationItem.rightBarButtonItem = cancelButton
        self.searchVC.view.isHidden = false
        self.shopVC.view.isHidden = true
        returnViewToInitialFrame()
    }
    
    @objc func didTapCancelSearchBar(){
        self.navigationItem.rightBarButtonItem = nil
        self.searchBar.endEditing(true)
        returnViewToInitialFrame()
        self.searchVC.view.isHidden = true
        self.shopVC.view.isHidden = false
    }
    
    func returnViewToInitialFrame(){
        var initialViewRect : CGRect
        if (self.searchBar.searchTextField.isEditing){
            initialViewRect = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 0)
        }else{
            initialViewRect = CGRect(x: 0, y: 0, width: view.frame.width-50, height: 0)
        }
        
        if (!initialViewRect.equalTo(self.searchBar.frame))
        {
            UIView.animate(withDuration: 0.3, animations: {
                self.searchBar.frame = initialViewRect
            })
        }
    }
   
}


extension ShopTabViewController {
    // category filter button
    @objc func tappedCategoryFilterButton() {
//        print("tapped category filter button")
//        let shopFilterViewController = ShopFilterViewController()
        let shopFilterViewController = UINavigationController(rootViewController: ShopFilterViewController(viewModel: self.viewModel))
        self.present(shopFilterViewController, animated: true)
    }
    
    // delivery buttons
    @objc func tappedImmediateDeliveryButton() {
        self.immediateDeliveryButton.isSelected = true
        self.brandDeliveryButton.isSelected = false
        updateDeliveryButtonConfiguration()
        self.viewModel.requestImmediateDeliveryData()
    }
    
    @objc func tappedBrandDeliveryButton() {
        self.immediateDeliveryButton.isSelected = false
        self.brandDeliveryButton.isSelected = true
        updateDeliveryButtonConfiguration()
        self.viewModel.requestBrandDeliveryData()
    }
}

extension ShopTabViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == self.collectionView {
            var selectedProduct = self.viewModel.getProductAtIndex(index: indexPath.row)
            let shopPostDetailViewModel = ShopTabDetailViewModel(shopPost: selectedProduct)
            let productDetailVC = ProductDetailViewController(viewModel: shopPostDetailViewModel)
            navigationController?.pushViewController(productDetailVC, animated: true)
        } else if collectionView == self.categoryCollectionView {
//            var selectedCategory = self.viewModel.getCategoryAtIndex(index: indexPath.row)
            
            var selectedCategoryCell = collectionView.cellForItem(at: indexPath) as! CategoryCollectionViewCell
            selectedCategoryCell.isSelected = !selectedCategoryCell.isSelected
//            print(selectedCategoryCell.categoryLabel.text!)
            self.viewModel.requestCategoryData(selectedCategory: selectedCategoryCell.categoryParameter)
//            selectedCategoryCell.isSelected = true
        }
        
    }
}

extension ShopTabViewController {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let position = scrollView.contentOffset.y
        if (position > self.collectionView.contentSize.height-scrollView.frame.size.height) {
            self.viewModel.requestMoreData()
        }
    }
}
