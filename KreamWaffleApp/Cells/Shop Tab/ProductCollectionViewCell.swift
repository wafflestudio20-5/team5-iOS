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
    let eng_nameLabel = UILabel()
    let kor_nameLabel = UILabel()
    let deliveryTagLabel = UILabel()
    let priceLabel = UILabel()
    let priceSubLabel = UILabel()
    
    let wishesImg = UIImageView()
    let wishesLabel = UILabel()
    let sharesImg = UIImageView()
    let sharesLabel = UILabel()
    
    // font sizes
    let h1FontSize: CGFloat = 14 // priceLabel
    let h2FontSize: CGFloat = 13 // brandLabel, eng_nameLabel
    let h3FontSize: CGFloat = 11 // kor_nameLabel, priceSubLabel
    
    // colors
    static let mainFontColor: UIColor = .black
    static let subFontColor: UIColor = .darkGray
    static let immediateDeliveryFontColor: UIColor = UIColor(red: 0.051, green: 0.6588, blue: 0.3843, alpha: 1.0)
    static let brandDeliveryFontColor: UIColor = UIColor(red: 0.3412, green: 0.2235, blue: 0.8078, alpha: 1.0)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        applyDesign()
        setupImageView()
        setupBrandLabel()
        setupeng_nameLabel()
        setupkor_nameLabel()
        setupDeliveryTagLabel()
        setupPriceLabel()
        setupWishesLabel()
        setupSharesLabel()
    }
    
    func configure(product: ProductData) {
        let imageUrlString = product.productimage_urls[0]
        let imageUrl = URL(string: imageUrlString)
        self.imageView.kf.setImage(with: imageUrl)
        self.brandLabel.text = product.brand_name
        self.eng_nameLabel.text = product.eng_name
        self.kor_nameLabel.text = product.kor_name
        
        let attributedDeliveryString1: NSMutableAttributedString
        switch product.delivery_tag {
            case "immediate":
                attributedDeliveryString1 = NSMutableAttributedString(string: "빠른배송")
                let deliveryTagImageAttachment = NSTextAttachment()
                deliveryTagImageAttachment.image = UIImage(systemName: "bolt.fill")?.withTintColor(ProductCollectionViewCell.immediateDeliveryFontColor)
                deliveryTagImageAttachment.bounds = CGRect(x: 0, y: 0, width: 10, height: 10)
                let attributedDeliveryString2 = NSMutableAttributedString(attachment: deliveryTagImageAttachment)
                attributedDeliveryString2.append(attributedDeliveryString1)
                self.deliveryTagLabel.attributedText = attributedDeliveryString2
                self.deliveryTagLabel.textColor = ProductCollectionViewCell.immediateDeliveryFontColor
                self.deliveryTagLabel.backgroundColor = UIColor(red: 0.898, green: 0.9882, blue: 0.9216, alpha: 1.0)
            case "brand":
    //            attributedDeliveryString1 = NSMutableAttributedString(string: "브랜드배송")
                self.deliveryTagLabel.text = "브랜드배송"
                self.deliveryTagLabel.textColor = ProductCollectionViewCell.brandDeliveryFontColor
                self.deliveryTagLabel.backgroundColor = UIColor(red: 0.8902, green: 0.898, blue: 0.949, alpha: 1.0)
    //            self.deliveryTagLabel.sizeToFit()
            default:
                self.deliveryTagLabel.text = ""
        }
        
        // price
        let formattedPrice = PriceFormatter.formatNumberToCurrency(intToFormat: product.price)
        self.priceLabel.text = "\(formattedPrice) 원"
        
        // wishes
        let bookmarkString1 = NSMutableAttributedString(string: "\(product.total_wishes)")
        let bookmarkImageAttachment = NSTextAttachment()
        bookmarkImageAttachment.image = UIImage(systemName: "bookmark")?.withTintColor(ProductCollectionViewCell.subFontColor)
        bookmarkImageAttachment.bounds = CGRect(x: 0, y: 0, width: 15, height: 15)
        let bookmarkString2 = NSMutableAttributedString(attachment: bookmarkImageAttachment)
        bookmarkString2.append(bookmarkString1)
        self.wishesLabel.attributedText = bookmarkString2
        self.wishesLabel.textColor = ProductCollectionViewCell.subFontColor
//        self.deliveryTagLabel.backgroundColor = UIColor(red: 0.898, green: 0.9882, blue: 0.9216, alpha: 1.0)
        
        // shares
        let sharesString1 = NSMutableAttributedString(string: "\(product.total_shares)")
        let sharesImageAttachment = NSTextAttachment()
        sharesImageAttachment.image = UIImage(systemName: "heart.text.square")?.withTintColor(ProductCollectionViewCell.subFontColor)
        sharesImageAttachment.bounds = CGRect(x: 0, y: 0, width: 15, height: 15)
        let sharesString2 = NSMutableAttributedString(attachment: sharesImageAttachment)
        sharesString2.append(sharesString1)
        self.sharesLabel.attributedText = sharesString2
        self.sharesLabel.textColor = ProductCollectionViewCell.subFontColor

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
            self.imageView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 10),
            self.imageView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -10),
            self.imageView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 5),
            self.imageView.bottomAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 150)
        ])
    }
    
    
    private func setupBrandLabel() {
        self.brandLabel.font = UIFont.boldSystemFont(ofSize: self.h2FontSize)
        self.brandLabel.textColor = ProductCollectionViewCell.mainFontColor
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
            brandLabel.topAnchor.constraint(equalTo: self.imageView.bottomAnchor, constant: 7),
//            brandLabel.bottomAnchor.constraint(equalTo: self.brandLabel.topAnchor, constant: 14)
        ])
    }
    
    private func setupeng_nameLabel() {
        self.eng_nameLabel.font = UIFont.systemFont(ofSize: self.h2FontSize)
        self.eng_nameLabel.textColor = ProductCollectionViewCell.mainFontColor
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
    
    private func setupkor_nameLabel() {
        self.kor_nameLabel.font = UIFont.systemFont(ofSize: self.h3FontSize)
        self.kor_nameLabel.textColor = ProductCollectionViewCell.subFontColor
        self.kor_nameLabel.numberOfLines = 1
        self.kor_nameLabel.lineBreakMode = .byTruncatingTail
//        self.kor_nameLabel.textAlignment = .left
        self.kor_nameLabel.adjustsFontSizeToFitWidth = false
        
        self.contentView.addSubview(self.kor_nameLabel)
        kor_nameLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            kor_nameLabel.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor),
            kor_nameLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 10),
            kor_nameLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -10),
            kor_nameLabel.topAnchor.constraint(equalTo: self.eng_nameLabel.bottomAnchor, constant: 2),
//            kor_nameLabel.bottomAnchor.constraint(equalTo: self.kor_nameLabel.topAnchor, constant: 30)
        ])
    }
    
    private func setupDeliveryTagLabel() {
        self.deliveryTagLabel.font = UIFont.systemFont(ofSize: self.h3FontSize)
        
        self.deliveryTagLabel.numberOfLines = 1
        self.deliveryTagLabel.textAlignment = .center
        
        self.contentView.addSubview(self.deliveryTagLabel)
        deliveryTagLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            deliveryTagLabel.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor),
//            deliveryTagLabel.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor),
            deliveryTagLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 10),
            deliveryTagLabel.trailingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 75),
//            deliveryTagLabel.widthAnchor.constraint(equalToConstant: 15),
            deliveryTagLabel.topAnchor.constraint(equalTo: self.kor_nameLabel.bottomAnchor, constant: 5),
            deliveryTagLabel.bottomAnchor.constraint(equalTo: self.deliveryTagLabel.topAnchor, constant: 19)
        ])
    }
    
    private func setupPriceLabel() {
        self.priceLabel.font = UIFont.boldSystemFont(ofSize: self.h1FontSize)
        self.priceLabel.textColor = ProductCollectionViewCell.mainFontColor
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
            priceLabel.topAnchor.constraint(equalTo: self.deliveryTagLabel.bottomAnchor, constant: 10),
//            priceLabel.bottomAnchor.constraint(equalTo: self.priceLabel.topAnchor, constant: 30)
        ])
        
        self.priceSubLabel.text = "즉시 구매가"
        self.priceSubLabel.font = UIFont.systemFont(ofSize: self.h3FontSize)
        self.priceSubLabel.textColor = ProductCollectionViewCell.subFontColor
        
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
    
    private func setupWishesLabel() {
        self.wishesLabel.font = UIFont.systemFont(ofSize: self.h3FontSize)
        self.wishesLabel.numberOfLines = 1
        self.wishesLabel.textAlignment = .left
        
        self.contentView.addSubview(self.wishesLabel)
        self.wishesLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
//            self.wishesLabel.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor),
            self.wishesLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 10),
            self.wishesLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -10),
            self.wishesLabel.topAnchor.constraint(equalTo: self.priceSubLabel.bottomAnchor, constant: 10),
//            priceSubLabel.bottomAnchor.constraint(equalTo: self.priceLabel.topAnchor, constant: 30)
        ])
        
    }
    
    private func setupSharesLabel() {
        self.sharesLabel.font = UIFont.systemFont(ofSize: self.h3FontSize)
        self.sharesLabel.numberOfLines = 1
        self.sharesLabel.textAlignment = .left
        
        self.contentView.addSubview(self.sharesLabel)
        self.sharesLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
//            self.sharesLabel.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor),
            self.sharesLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 40),
            self.sharesLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -10),
            self.sharesLabel.topAnchor.constraint(equalTo: self.priceSubLabel.bottomAnchor, constant: 10),
//            priceSubLabel.bottomAnchor.constraint(equalTo: self.priceLabel.topAnchor, constant: 30)
        ])

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

