//
//  ProductSizeSelectionViewController.swift
//  KreamWaffleApp
//
//  Created by 이선재 on 2023/01/01.
//

import UIKit
import RxSwift
import RxCocoa


//for the half screen modal view
class ProductSizeSelectionViewController: UIViewController, UIScrollViewDelegate, UICollectionViewDelegateFlowLayout {
    private let disposeBag = DisposeBag()
    let viewModel: ShopTabDetailViewModel
    
    var sizeCollectionView: UICollectionView!
    private var layout = UICollectionViewFlowLayout()
    private var backButton = UIButton()
    private var titleLabel = UILabel()
    
    let sizes: [String] = ["ALL"]
    
    init(viewModel: ShopTabDetailViewModel){
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(red: 250/255.0, green: 250/255.0, blue: 250/255.0, alpha: 1.0)
        bind()
        self.view.addSubview(titleLabel)
        self.view.addSubview(backButton)
        self.view.addSubview(sizeCollectionView)
        configureCollectionView()
    }
    
    
    private func bind(){
        self.sizeCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        self.sizeCollectionView.register(ProductSizeSelectionCollectionViewCell.self, forCellWithReuseIdentifier: "ProductSizeSelectionCollectionViewCell")
        
        self.sizeCollectionView.rx.setDelegate(self)
            .disposed(by: disposeBag)

        self.viewModel.productSizeInfoDataSource
            .bind(to: sizeCollectionView.rx.items(cellIdentifier: "ProductSizeSelectionCollectionViewCell", cellType: ProductSizeSelectionCollectionViewCell.self)) { index, productSizeInfo, cell in
                cell.configure(productSizeInfo: productSizeInfo)
            }.disposed(by: disposeBag)
    }
    
    private func configureCollectionView(){
        titleLabel.text = "사이즈"
        titleLabel.backgroundColor = .white
        titleLabel.textColor = .black
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        self.titleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.titleLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        self.titleLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        self.titleLabel.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        self.titleLabel.heightAnchor.constraint(equalToConstant: self.view.frame.height/16).isActive = true
        
        let blue_x = UIImage(systemName: "xmark")
        let tinted_x = blue_x?.withRenderingMode(.alwaysTemplate)
        self.backButton.setImage(tinted_x, for: .normal)
        self.backButton.tintColor = .black
        
        self.titleLabel.addSubview(backButton)
        backButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -10).isActive = true
        backButton.centerYAnchor.constraint(equalTo: self.titleLabel.centerYAnchor).isActive = true
        backButton.heightAnchor.constraint(equalToConstant: self.view.frame.height/20).isActive = true
        backButton.widthAnchor.constraint(equalToConstant: self.view.frame.height/20).isActive = true
        backButton.addTarget(self, action: #selector(exitVC), for: .touchUpInside)
    
        layout.scrollDirection = .vertical
        self.sizeCollectionView.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
        self.sizeCollectionView.showsVerticalScrollIndicator = false
        self.sizeCollectionView.backgroundColor = .clear
        self.sizeCollectionView.translatesAutoresizingMaskIntoConstraints = false
        self.sizeCollectionView.topAnchor.constraint(equalTo: self.titleLabel.bottomAnchor).isActive = true
        self.sizeCollectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20).isActive = true
        self.sizeCollectionView.heightAnchor.constraint(greaterThanOrEqualToConstant: self.view.frame.height / 2).isActive = true
        self.sizeCollectionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20).isActive = true
    }

    @objc func exitVC(){
//        self.dismiss(animated: true, )
        self.dismiss(animated: true)
        
    }
}

extension ProductSizeSelectionViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        var selectedCell = sizeCollectionView.cellForItem(at: indexPath) as! ProductSizeSelectionCollectionViewCell
        selectedCell.isSelected = true
        exitVC()
    }
}

extension ProductSizeSelectionViewController {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            let width = collectionView.bounds.width
            let cellWidth = (width - 20) / 2
        return CGSize(width: cellWidth, height: cellWidth / 3.8)
        }
}
