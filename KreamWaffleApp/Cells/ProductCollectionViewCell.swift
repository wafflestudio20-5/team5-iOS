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
    let transactionCountLabel = UILabel()
    let bookmarkCountLabel = UILabel()
    let relatedStyleCountLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    func configure(product: ProductData) {
        let imageUrl = URL(string: "https://example.com/image.png")
        self.imageView.kf.setImage(with: imageUrl)
        self.brandLabel.text = product.brand
        self.productNameEngLabel.text = product.productNameEng
        self.productNameKorLabel.text = product.productNameKor
        self.priceLabel.text = "(product.price)"
        self.transactionCountLabel.text = "(product.transactionCount)"
        self.bookmarkCountLabel.text = "(product.bookmarkCount)"
        self.relatedStyleCountLabel.text = "(product.relatedStyleCount)"
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
