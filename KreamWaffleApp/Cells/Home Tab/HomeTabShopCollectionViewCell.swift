//
//  HomeTabShopCollectionViewCell.swift
//  KreamWaffleApp
//
//  Created by 이선재 on 2023/01/16.
//

import UIKit

class HomeTabShopCollectionViewCell: UICollectionViewCell {
    override var reuseIdentifier: String? {
        return "HomeTabShopCollectionViewCell"
    }
    
    let imageView = UIImageView()
    let brandLabel = UILabel()
    let eng_nameLabel = UILabel()
    let priceLabel = UILabel()
    let priceSubLabel = UILabel()

    let bookmarkButton = UIButton()
    
    let h1FontSize: CGFloat = 14 // priceLabel
    let h2FontSize: CGFloat = 13 // brandLabel, eng_nameLabel
    let h3FontSize: CGFloat = 11 // priceSubLabel
    let mainFontColor: UIColor = .black
    let subFontColor: UIColor = .darkGray
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        applyDesign()
        setupImageView()
        setupBrandLabel()
        setupeng_nameLabel()
        setupPriceLabel()
    }
    
    func configure(product: Product) {
//        let imageUrl = URL(string: product.imageSource)
        let imageUrl = URL(string: "https://kream-waffle-api-bucket.s3.amazonaws.com/media/shop/2023/01/15/02034569f88043718b62a3d7b667926d_ProductImage_object_None.png?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=AKIAT3ANORTZU4HTFQSI%2F20230117%2Fap-northeast-2%2Fs3%2Faws4_request&X-Amz-Date=20230117T083705Z&X-Amz-Expires=3600&X-Amz-SignedHeaders=host&X-Amz-Signature=8d7a7aea975f5a57b5dfa78979d220dd1627bc2a8a73f8f3910763ac735f7f1d")
        self.imageView.kf.setImage(with: imageUrl)
        self.brandLabel.text = "\(product.brand)"
        self.eng_nameLabel.text = product.eng_name
        self.priceLabel.text = "\(product.price)원"
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
    
    private func setupBrandLabel() {
        self.brandLabel.font = UIFont.boldSystemFont(ofSize: self.h2FontSize)
        self.brandLabel.textColor = self.mainFontColor
        self.brandLabel.numberOfLines = 1
        self.brandLabel.lineBreakMode = .byTruncatingTail
        self.brandLabel.textAlignment = .left
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
    
    private func setupeng_nameLabel() {
        self.eng_nameLabel.font = UIFont.systemFont(ofSize: self.h2FontSize)
        self.eng_nameLabel.textColor = self.mainFontColor
        self.eng_nameLabel.numberOfLines = 2
        self.eng_nameLabel.lineBreakMode = .byTruncatingTail
//        self.eng_nameLabel.textAlignment = .left
        self.eng_nameLabel.adjustsFontSizeToFitWidth = false
        
        
        self.contentView.addSubview(self.eng_nameLabel)
        eng_nameLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            eng_nameLabel.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor),
            eng_nameLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 10),
            eng_nameLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -10),
            eng_nameLabel.topAnchor.constraint(equalTo: self.brandLabel.bottomAnchor, constant: 0),
//            eng_nameLabel.bottomAnchor.constraint(equalTo: self.eng_nameLabel.topAnchor, constant: 30)
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
            priceLabel.topAnchor.constraint(equalTo: self.eng_nameLabel.bottomAnchor, constant: 10),
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
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
