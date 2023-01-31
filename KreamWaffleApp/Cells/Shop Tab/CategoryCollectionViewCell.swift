//
//  CategoryCollectionViewCell.swift
//  KreamWaffleApp
//
//  Created by 이선재 on 2023/01/02.
//

import UIKit

class CategoryCollectionViewCell: UICollectionViewCell {
    override var reuseIdentifier: String? {
        return "CategoryCollectionViewCell"
    }
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
                self.contentView.backgroundColor = CategoryCollectionViewCell.selectedBgColor
                self.categoryLabel.textColor = CategoryCollectionViewCell.selectedTextColor
            } else {
                self.contentView.backgroundColor = CategoryCollectionViewCell.unselectedBgColor
                self.categoryLabel.textColor = CategoryCollectionViewCell.unselectedTextColor
            }
        }
    }
    static let categoryLabelText: [String: String] = ["shoes": "신발", "clothes": "의류", "fashion": "패션 잡화", "life": "라이프", "tech": "테크"]
    var categoryParameter = String()
    let categoryLabel = UILabel()
    let categoryFontSize: CGFloat = 13.5
    
    // colors
    static let unselectedTextColor = UIColor.black
    static let unselectedBgColor = UIColor(red: 0.9373, green: 0.9373, blue: 0.9373, alpha: 1.0)
    static let selectedTextColor = UIColor(red: 1, green: 0.098, blue: 0.098, alpha: 1.0)
    static let selectedBgColor = UIColor(red: 1, green: 0.949, blue: 0.949, alpha: 1.0)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        applyDesign()
        setupCategoryLabel()
    }
    
    func configure(categoryName: String) {
        self.categoryParameter = categoryName
        self.categoryLabel.text = CategoryCollectionViewCell.categoryLabelText[categoryName]
    }
    
    private func applyDesign() {
        self.contentView.backgroundColor = UIColor(red: 0.9373, green: 0.9373, blue: 0.9373, alpha: 1.0)
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
