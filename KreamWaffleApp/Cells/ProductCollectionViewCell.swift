//
//  ProductCollectionViewCell.swift
//  KreamWaffleApp
//
//  Created by 이선재 on 2022/12/29.
//

import UIKit
import Kingfisher

class ProductCollectionViewCell: UICollectionViewCell {
    override var reuseIdentifier: String? {
        return "ProductCollectionViewCell"
    }
    
    let imageView = UIImageView()
    let brandLabel = UILabel()
    let productNameEngLabel = UILabel()
    let productNameKorLabel = UILabel()
    let priceLabel = UILabel()
    let priceSubLabel = UILabel()
    let transactionCountLabel = UILabel()
    var transactionCount = Int()
//    let bookmarkCountLabel = UILabel()
    var bookmarkCount = Int()
    let relatedStyleCountLabel = UILabel()
    var relatedStyleCount = Int()
    
    let bookmarkButton = UIButton()
    let relatedStyleButton = UIButton()
    
    let h1FontSize: CGFloat = 14 // priceLabel
    let h2FontSize: CGFloat = 13 // brandLabel, productNameEngLabel
    let h3FontSize: CGFloat = 11 // productNameKorLabel, priceSubLabel
    let mainFontColor: UIColor = .black
    let subFontColor: UIColor = .darkGray
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        applyDesign()
        setupImageView()
        setupBrandLabel()
        setupProductNameEngLabel()
        setupProductNameKorLabel()
        setupPriceLabel()
        setupBookmarkButton()
        setupRelatedStyleButton()
    }
    
    func configure(product: ProductData) {
        let imageUrl = URL(string: product.imageSource)
        self.imageView.kf.setImage(with: imageUrl)
        self.brandLabel.text = product.brand
        self.productNameEngLabel.text = product.productNameEng
        self.productNameKorLabel.text = product.productNameKor
        self.priceLabel.text = "\(product.price) 원"
        self.transactionCountLabel.text = "\(product.transactionCount)"
        self.transactionCount = product.transactionCount
//        self.bookmarkCountLabel.text = "\(product.bookmarkCount)"
        self.bookmarkCount = product.bookmarkCount
        print(self.bookmarkCount)
        self.relatedStyleCountLabel.text = "\(product.relatedStyleCount)"
        self.relatedStyleCount = product.relatedStyleCount
    }
    
    private func applyDesign() {
        self.contentView.backgroundColor = .white
        self.contentView.layer.cornerRadius = 20.0
        self.contentView.isOpaque = true
    }
    
    private func setupImageView() {
        self.imageView.sizeToFit()
        self.imageView.layer.cornerRadius = 5
        self.imageView.contentMode = .scaleAspectFill
//        self.imageView.backgroundColor = .lightGray
        
        self.contentView.addSubview(self.imageView)
        self.imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.imageView.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor),
            self.imageView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 50),
            self.imageView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -50),
            self.imageView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 5),
            self.imageView.bottomAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 150)
        ])
    }
    
    private func setupTransactionCountLabel() {
        self.transactionCountLabel.font = UIFont.boldSystemFont(ofSize: 15)
        self.transactionCountLabel.textColor = self.mainFontColor
        self.transactionCountLabel.lineBreakMode = .byWordWrapping
        self.transactionCountLabel.numberOfLines = 1
        self.transactionCountLabel.textAlignment = .left
        self.transactionCountLabel.adjustsFontSizeToFitWidth = true
        
        self.contentView.addSubview(self.transactionCountLabel)
        transactionCountLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            transactionCountLabel.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor),
            transactionCountLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 10),
            transactionCountLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -10),
            transactionCountLabel.topAnchor.constraint(equalTo: self.imageView.topAnchor, constant: 5),
            transactionCountLabel.bottomAnchor.constraint(equalTo: self.transactionCountLabel.topAnchor, constant: 30)
        ])
    }
    
    private func setupBrandLabel() {
        self.brandLabel.font = UIFont.boldSystemFont(ofSize: self.h2FontSize)
        self.brandLabel.textColor = self.mainFontColor
        self.brandLabel.numberOfLines = 1
        self.brandLabel.lineBreakMode = .byTruncatingTail
//        self.brandLabel.textAlignment = .left
        self.brandLabel.adjustsFontSizeToFitWidth = false
        
        
        self.contentView.addSubview(self.brandLabel)
        brandLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            brandLabel.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor),
            brandLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 10),
            brandLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -10),
            brandLabel.topAnchor.constraint(equalTo: self.imageView.bottomAnchor, constant: 5),
//            brandLabel.bottomAnchor.constraint(equalTo: self.brandLabel.topAnchor, constant: 14)
        ])
    }
    
    private func setupProductNameEngLabel() {
        self.productNameEngLabel.font = UIFont.systemFont(ofSize: self.h2FontSize)
        self.productNameEngLabel.textColor = self.mainFontColor
        self.productNameEngLabel.numberOfLines = 2
        self.productNameEngLabel.lineBreakMode = .byTruncatingTail
//        self.productNameEngLabel.textAlignment = .left
        self.productNameEngLabel.adjustsFontSizeToFitWidth = false
        
        
        self.contentView.addSubview(self.productNameEngLabel)
        productNameEngLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            productNameEngLabel.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor),
            productNameEngLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 10),
            productNameEngLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -10),
            productNameEngLabel.topAnchor.constraint(equalTo: self.brandLabel.bottomAnchor, constant: 0),
//            productNameEngLabel.bottomAnchor.constraint(equalTo: self.productNameEngLabel.topAnchor, constant: 30)
        ])
    }
    
    private func setupProductNameKorLabel() {
        self.productNameKorLabel.font = UIFont.systemFont(ofSize: self.h3FontSize)
        self.productNameKorLabel.textColor = self.subFontColor
        self.productNameKorLabel.numberOfLines = 1
        self.productNameKorLabel.lineBreakMode = .byTruncatingTail
//        self.productNameKorLabel.textAlignment = .left
        self.productNameKorLabel.adjustsFontSizeToFitWidth = false
        
        
        self.contentView.addSubview(self.productNameKorLabel)
        productNameKorLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            productNameKorLabel.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor),
            productNameKorLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 10),
            productNameKorLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -10),
            productNameKorLabel.topAnchor.constraint(equalTo: self.productNameEngLabel.bottomAnchor, constant: 2),
//            productNameKorLabel.bottomAnchor.constraint(equalTo: self.productNameKorLabel.topAnchor, constant: 30)
        ])
    }
    
    private func setupPriceLabel() {
        self.priceLabel.font = UIFont.boldSystemFont(ofSize: self.h1FontSize)
        self.priceLabel.textColor = self.mainFontColor
        self.priceLabel.lineBreakMode = .byWordWrapping
        self.priceLabel.numberOfLines = 1
//        self.priceLabel.textAlignment = .left
        self.priceLabel.adjustsFontSizeToFitWidth = true
        
        self.contentView.addSubview(self.priceLabel)
        priceLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            priceLabel.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor),
            priceLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 10),
            priceLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -10),
            priceLabel.topAnchor.constraint(equalTo: self.productNameKorLabel.bottomAnchor, constant: 10),
//            priceLabel.bottomAnchor.constraint(equalTo: self.priceLabel.topAnchor, constant: 30)
        ])
        
        self.priceSubLabel.text = "즉시 구매가"
        self.priceSubLabel.font = UIFont.systemFont(ofSize: self.h3FontSize)
        self.priceSubLabel.textColor = self.subFontColor
        
        self.contentView.addSubview(self.priceSubLabel)
        self.priceSubLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.priceSubLabel.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor),
            self.priceSubLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 10),
            self.priceSubLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -10),
            self.priceSubLabel.topAnchor.constraint(equalTo: self.priceLabel.bottomAnchor, constant: 0),
//            priceSubLabel.bottomAnchor.constraint(equalTo: self.priceLabel.topAnchor, constant: 30)
        ])
        
    }
    
    private func setupBookmarkButton() {
        self.bookmarkButton.setImage(UIImage(systemName: "bookmark"), for: .normal)
        self.bookmarkButton.setTitle("\(self.bookmarkCount)", for: .normal)
//        self.bookmarkButton.addTarget(self, action: #selector(tappedBookmarkButton), for: .touchUpInside)
        self.bookmarkButton.tintColor = self.subFontColor
        self.bookmarkButton.setTitleColor(self.subFontColor, for: .normal)
        self.bookmarkButton.titleLabel?.font = UIFont.systemFont(ofSize: self.h3FontSize)
        self.bookmarkButton.contentHorizontalAlignment = .left
        
        self.contentView.addSubview(self.bookmarkButton)
        self.bookmarkButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.bookmarkButton.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor),
            self.bookmarkButton.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 10),
            self.bookmarkButton.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -10),
            self.bookmarkButton.topAnchor.constraint(equalTo: self.priceSubLabel.bottomAnchor, constant: 10),
//            priceSubLabel.bottomAnchor.constraint(equalTo: self.priceLabel.topAnchor, constant: 30)
        ])
        
    }
    
    private func setupRelatedStyleButton() {
        self.relatedStyleButton.setImage(UIImage(systemName: "heart.text.square"), for: .normal)
        self.relatedStyleButton.setTitle("\(self.relatedStyleCount)", for: .normal)
//        self.bookmarkButton.addTarget(self, action: #selector(tappedBookmarkButton), for: .touchUpInside)
        self.relatedStyleButton.tintColor = self.subFontColor
        self.relatedStyleButton.setTitleColor(self.subFontColor, for: .normal)
        self.relatedStyleButton.titleLabel?.font = UIFont.systemFont(ofSize: self.h3FontSize)
        self.relatedStyleButton.contentHorizontalAlignment = .left
        
        self.contentView.addSubview(self.relatedStyleButton)
        self.relatedStyleButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.relatedStyleButton.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor),
            self.relatedStyleButton.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 50),
            self.relatedStyleButton.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -10),
            self.relatedStyleButton.topAnchor.constraint(equalTo: self.priceSubLabel.bottomAnchor, constant: 10),
//            priceSubLabel.bottomAnchor.constraint(equalTo: self.priceLabel.topAnchor, constant: 30)
        ])
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
