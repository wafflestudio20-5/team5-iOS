//
//  FilterCollectionViewCell.swift
//  KreamWaffleApp
//
//  Created by 이선재 on 2023/01/02.
//

import UIKit

class FilterCollectionViewCell: UICollectionViewCell {
    override var reuseIdentifier: String? {
        return "FilterCollectionViewCell"
    }
    
    let categoryLabel = UILabel()
    let categoryFontSize: CGFloat = 14
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        applyDesign()
        setupCategoryLabel()
    }
    
    func configure(categoryName: String) {
        self.categoryLabel.text = categoryName
//        setupCategoryLabel()
    }
    
    private func applyDesign() {
//        self.contentView.backgroundColor = colors.darkGray
        self.contentView.backgroundColor = UIColor.lightGray
        self.contentView.layer.cornerRadius = 10.0
        self.contentView.isOpaque = true
    }
    
    private func setupCategoryLabel() {
        self.categoryLabel.font = UIFont.boldSystemFont(ofSize: self.categoryFontSize)
        self.categoryLabel.textColor = .black
        self.categoryLabel.numberOfLines = 1
//        self.categoryLabel.lineBreakMode = .byTruncatingTail
        self.categoryLabel.textAlignment = .center
        self.categoryLabel.adjustsFontSizeToFitWidth = false
        
        self.contentView.addSubview(self.categoryLabel)
        categoryLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            categoryLabel.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor),
            categoryLabel.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor),
            categoryLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 5),
            categoryLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -10),
//            categoryLabel.topAnchor.constraint(equalTo: self.imageView.bottomAnchor, constant: 5),
//            brandLabel.bottomAnchor.constraint(equalTo: self.brandLabel.topAnchor, constant: 14)
        ])
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
