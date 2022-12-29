//
//  StyleTabViewController.swift
//  KreamWaffleApp
//
//  Created by 이선재 on 2022/12/24.
//

import UIKit
import RxSwift
import RxCocoa

class StyleTabViewController: UIViewController {
    
    private var header = UIView()
    private var codeSegmented = CustomSegmentedControl(buttonTitle: ["최신"])
    private var searchButton = UIButton()
    private var cameraButton = UIButton()
    
    private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: ShopCollectionViewFlowLayout())
    
    private let viewModel: ShopViewModel
    private let disposeBag = DisposeBag()
    
    init(viewModel: ShopViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.navigationItem.titleView = self.header
        addSubviews()
        configureHeader()
        setupCollectionView()
        bindCollectionView()
    }
    
    func addSubviews(){
        view.addSubview(header)
        header.addSubview(codeSegmented)
        header.addSubview(searchButton)
        header.addSubview(cameraButton)
    }
    
    func configureHeader(){
        configureSegmentedControl()
        
        //configure search button
        let searchImage = UIImage(systemName: "magnifyingglass")
        let tintedSearchImage = searchImage?.withRenderingMode(.alwaysTemplate)
        self.searchButton.setImage(tintedSearchImage, for: .normal)
        self.searchButton.tintColor = .black
        self.searchButton.translatesAutoresizingMaskIntoConstraints = false
        self.searchButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 10).isActive = true
        self.searchButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        self.searchButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        self.searchButton.centerYAnchor.constraint(equalTo: self.header.centerYAnchor).isActive = true
        
        //configure camera button
        let cameraImage = UIImage(systemName: "camera.circle.fill")
        let tintedcameraImage = cameraImage?.withRenderingMode(.alwaysTemplate)
        self.cameraButton.setImage(tintedcameraImage, for: .normal)
        self.cameraButton.tintColor = .lightGray
        self.cameraButton.translatesAutoresizingMaskIntoConstraints = false
        self.cameraButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -10).isActive = true
        self.cameraButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        self.cameraButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        self.cameraButton.centerYAnchor.constraint(equalTo: self.header.centerYAnchor).isActive = true
    }
    
    
    func configureSegmentedControl(){
        self.header.backgroundColor = .white
        self.header.translatesAutoresizingMaskIntoConstraints = false
        self.header.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        self.header.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 50).isActive = true
        self.header.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        self.header.heightAnchor.constraint(equalToConstant: 40).isActive = true
                                    
        self.codeSegmented.backgroundColor = .white
        self.codeSegmented.translatesAutoresizingMaskIntoConstraints = false
        self.codeSegmented.centerXAnchor.constraint(equalTo: self.header.centerXAnchor).isActive = true
        self.codeSegmented.centerYAnchor.constraint(equalTo: self.header.centerYAnchor).isActive = true
        self.codeSegmented.widthAnchor.constraint(equalToConstant: 50).isActive = true
        self.codeSegmented.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
    }
    
    private func setupCollectionView() {
        self.view.addSubview(collectionView)
        self.collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.collectionView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            self.collectionView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -150),
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
   
}

extension StyleTabViewController: UICollectionViewDelegate{
    
}
