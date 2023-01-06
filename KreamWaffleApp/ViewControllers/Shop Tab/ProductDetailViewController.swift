//
//  ProductDetailViewController.swift
//  KreamWaffleApp
//
//  Created by 이선재 on 2022/12/26.
//
import UIKit

class ProductDetailViewController: UIViewController, UISheetPresentationControllerDelegate {
    private let productModel: Product
    
    let imageView = UIImageView() // change to collectionView layer
    let imagesCollectionView = UICollectionView(frame: .zero, collectionViewLayout: ProductDetailImagesCollectionViewFlowLayout())
    let brandLabel = UILabel()
    let productNameEngLabel = UILabel()
    let productNameKorLabel = UILabel()
    var sizeField : ShoeSizefield?
//    let sizeButton = UIButton()
    let priceLabel = UILabel()
    let priceSubLabel = UILabel()
    
    var bookmarkCount = Int()
    var purchasePrice = Int()
    var sellPrice = Int()
    
    let bookmarkButton = UIButton()
    let purchaseButton = UIButton()
    let sellButton = UIButton()
    
    let h1FontSize: CGFloat = 18 // brandLabel, priceLabel
    let h2FontSize: CGFloat = 16 // productNameEngLabel
    let h3FontSize: CGFloat = 14 // productNameKorLabel, priceSubLabel
    let h4FontSize: CGFloat = 13 // priceSubLabel
    let mainFontColor: UIColor = .black
    let subFontColor: UIColor = .darkGray
    let marginConstant: CGFloat = 15
    
    init(productModel: Product) {
        self.productModel = productModel
        super.init(nibName: nil, bundle: nil)
    }
    
    override func loadView() {
        self.view = UIView()
        configure()
        applyDesign()
        setupImageView()
        setupBrandLabel()
        setupProductNameEngLabel()
        setupProductNameKorLabel()
        
        setupShoeSizeField()
//        setupSizeButton()
        
        setupPriceLabel()
    }

    
    private func configure() {
        let imageUrl = URL(string: self.productModel.imageSource)
        self.imageView.kf.setImage(with: imageUrl)
        self.brandLabel.text = self.productModel.brand
        self.productNameEngLabel.text = self.productModel.productNameEng
        self.productNameKorLabel.text = self.productModel.productNameKor
        self.priceLabel.text = "\(self.productModel.price)원"
        self.bookmarkCount = self.productModel.bookmarkCount
        self.purchasePrice = self.productModel.price
    }
    
    private func applyDesign() {
        self.view.backgroundColor = .white
//        self.contentView.layer.cornerRadius = 20.0
//        self.contentView.isOpaque = true
    }
    
    private func setupImageView() {
        self.imageView.sizeToFit()
        self.imageView.contentMode = .scaleAspectFill
        self.imageView.backgroundColor = .lightGray
        
        self.view.addSubview(self.imageView)
        self.imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.imageView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            self.imageView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
            self.imageView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
//            self.imageView.bottomAnchor.constraint(equalTo: self.imageView.topAnchor, constant: 150)
        ])
    }
    
    private func setupBrandLabel() {
        self.brandLabel.font = UIFont.boldSystemFont(ofSize: self.h1FontSize)
        self.brandLabel.textColor = self.mainFontColor
        self.brandLabel.numberOfLines = 1
        self.brandLabel.lineBreakMode = .byTruncatingTail
//        self.brandLabel.textAlignment = .left
        self.brandLabel.adjustsFontSizeToFitWidth = false
        
        self.view.addSubview(self.brandLabel)
        brandLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            brandLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            brandLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: self.marginConstant),
            brandLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -self.marginConstant),
            brandLabel.topAnchor.constraint(equalTo: self.imageView.bottomAnchor, constant: 20),
//            brandLabel.bottomAnchor.constraint(equalTo: self.brandLabel.topAnchor, constant: 14)
        ])
    }
    
    private func setupProductNameEngLabel() {
        self.productNameEngLabel.font = UIFont.systemFont(ofSize: self.h2FontSize)
        self.productNameEngLabel.textColor = self.mainFontColor
        self.productNameEngLabel.numberOfLines = 0
        self.productNameEngLabel.lineBreakMode = .byWordWrapping
//        self.productNameEngLabel.textAlignment = .left
        self.productNameEngLabel.adjustsFontSizeToFitWidth = false
        
        
        self.view.addSubview(self.productNameEngLabel)
        productNameEngLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            productNameEngLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            productNameEngLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: self.marginConstant),
            productNameEngLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -self.marginConstant),
            productNameEngLabel.topAnchor.constraint(equalTo: self.brandLabel.bottomAnchor, constant: 5),
//            productNameEngLabel.bottomAnchor.constraint(equalTo: self.productNameEngLabel.topAnchor, constant: 30)
        ])
    }
    
    private func setupProductNameKorLabel() {
        self.productNameKorLabel.font = UIFont.systemFont(ofSize: self.h3FontSize)
        self.productNameKorLabel.textColor = self.subFontColor
        self.productNameKorLabel.numberOfLines = 0
        self.productNameKorLabel.lineBreakMode = .byWordWrapping
//        self.productNameKorLabel.textAlignment = .left
        self.productNameKorLabel.adjustsFontSizeToFitWidth = false
        
        
        self.view.addSubview(self.productNameKorLabel)
        productNameKorLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            productNameKorLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            productNameKorLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: self.marginConstant),
            productNameKorLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -self.marginConstant),
            productNameKorLabel.topAnchor.constraint(equalTo: self.productNameEngLabel.bottomAnchor, constant: 2),
//            productNameKorLabel.bottomAnchor.constraint(equalTo: self.productNameKorLabel.topAnchor, constant: 30)
        ])
    }
    
    private func setupShoeSizeField() {
        self.sizeField = ShoeSizefield(selectedSize: nil)
        self.view.addSubview(sizeField!)
        self.sizeField?.translatesAutoresizingMaskIntoConstraints = false
        self.sizeField?.topAnchor.constraint(equalTo: self.productNameKorLabel.bottomAnchor, constant: 30).isActive = true
        self.sizeField?.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20).isActive = true
        self.sizeField?.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20).isActive = true
        self.sizeField?.heightAnchor.constraint(greaterThanOrEqualToConstant: 50).isActive = true
        self.sizeField?.button.addTarget(self, action: #selector(didTapSelectShoeSize), for: .touchUpInside)
    }
    
//    private func setupSizeButton() {
//        // Setup button text
//        self.sizeButton.setTitle("모든 사이즈", for: .normal)
//        self.sizeButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: self.h2FontSize)
//        self.sizeButton.setTitleColor(self.mainFontColor, for: .normal)
//        self.sizeButton.contentHorizontalAlignment = .left
//
//        // Setup button image
//        self.sizeButton.setImage(UIImage(systemName: "arrowtriangle.down.circle"), for: .normal)
//        self.sizeButton.tintColor = self.mainFontColor
//        self.sizeButton.semanticContentAttribute = .forceRightToLeft // puts image right of text
//
//        // Setup button border
//        self.sizeButton.layer.borderColor = self.subFontColor.cgColor
//        self.sizeButton.layer.borderWidth = 1
//        self.sizeButton.layer.cornerRadius = 5
//
//        self.sizeButton.addTarget(self, action: #selector(tappedSizeButton), for: .touchUpInside)
//
//        self.view.addSubview(self.sizeButton)
//        self.sizeButton.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate([
//            sizeButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
//            sizeButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: self.marginConstant),
//            sizeButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -self.marginConstant),
//            sizeButton.topAnchor.constraint(equalTo: self.productNameKorLabel.bottomAnchor, constant: 20),
////            priceLabel.bottomAnchor.constraint(equalTo: self.priceLabel.topAnchor, constant: 30)
//        ])
//    }
    
    private func setupPriceLabel() {
        self.priceLabel.font = UIFont.boldSystemFont(ofSize: self.h1FontSize)
        self.priceLabel.textColor = self.mainFontColor
        self.priceLabel.lineBreakMode = .byWordWrapping
        self.priceLabel.numberOfLines = 1
        self.priceLabel.textAlignment = .right
        self.priceLabel.adjustsFontSizeToFitWidth = true
        
        self.view.addSubview(self.priceLabel)
        priceLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            priceLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            priceLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: self.marginConstant),
            priceLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -self.marginConstant),
            priceLabel.topAnchor.constraint(equalTo: self.sizeField!.bottomAnchor, constant: 20),
//            priceLabel.bottomAnchor.constraint(equalTo: self.priceLabel.topAnchor, constant: 30)
        ])
        
        self.priceSubLabel.text = "최근 거래가"
        self.priceSubLabel.font = UIFont.systemFont(ofSize: self.h4FontSize)
        self.priceSubLabel.textColor = self.subFontColor
        
        self.view.addSubview(self.priceSubLabel)
        self.priceSubLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.priceSubLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.priceSubLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: self.marginConstant),
            self.priceSubLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -self.marginConstant),
            self.priceSubLabel.topAnchor.constraint(equalTo: self.sizeField!.bottomAnchor, constant: 20),
//            priceSubLabel.bottomAnchor.constraint(equalTo: self.priceLabel.topAnchor, constant: 30)
        ])
    }
    
    @objc func didTapSelectShoeSize() {
        var productSizeList = [230, 235, 240]
        
        let productSizeSelectionVC = ShoeSizeSelectionViewController()
        productSizeSelectionVC.modalPresentationStyle = .pageSheet
        
        if let sheet = productSizeSelectionVC.sheetPresentationController {
            //지원할 크기 지정
            sheet.detents = [.medium()]
            //크기 변하는거 감지
            sheet.delegate = self
                   
            //시트 상단에 그래버 표시 (기본 값은 false)
            sheet.prefersGrabberVisible = true
                    
            //처음 크기 지정 (기본 값은 가장 작은 크기)
            //sheet.selectedDetentIdentifier = .large
                    
            //뒤 배경 흐리게 제거 (기본 값은 모든 크기에서 배경 흐리게 됨)
            //sheet.largestUndimmedDetentIdentifier = .medium
        }
        
        self.present(productSizeSelectionVC, animated: true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
