//
//  ShoeSizeSelectionCollectionViewCell.swift
//  KreamWaffleApp
//
//  Created by 이선재 on 2023/01/01.
//

import UIKit

class ProductSizeSelectionCollectionViewCell: UICollectionViewCell {
    var sizeLabel = UILabel()
    var priceLabel = UILabel()
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
                self.contentView.layer.borderWidth = 0.5
                self.contentView.layer.borderColor = UIColor.black.cgColor
                
                self.sizeLabel.font = UIFont.systemFont(ofSize: 14, weight: .bold)
                self.priceLabel.font = UIFont.systemFont(ofSize: 13, weight: .bold)
            } else {
                self.contentView.layer.borderWidth = 0.3
                self.contentView.layer.borderColor = UIColor.lightGray.cgColor
                
                self.sizeLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
                self.priceLabel.font = UIFont.systemFont(ofSize: 13, weight: .regular)
            }
        }
    }
    
    override init(frame: CGRect){
        super.init(frame: .zero)
        configureDesign()
    }
    
    func configure(productSizeInfo: ProductSize){
        self.sizeLabel.text = productSizeInfo.size
        self.priceLabel.text = PriceFormatter.formatNumberToCurrency(intToFormat: productSizeInfo.sales_price)
    }
    
    override var reuseIdentifier: String {
        return "ProductSizeSelectionCollectionViewCell"
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureDesign(){
        // contentView cell design
        self.contentView.backgroundColor = .white
        self.contentView.layer.borderWidth = 0.3
        self.contentView.layer.borderColor = UIColor.lightGray.cgColor
        self.contentView.layer.cornerRadius = 7
        
        // size label
        self.sizeLabel.textAlignment = .center
        self.sizeLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        self.sizeLabel.textColor = .black
        self.sizeLabel.clipsToBounds = true
        
        self.contentView.addSubview(sizeLabel)
        self.sizeLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.sizeLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            self.sizeLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
            self.sizeLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 7),
            self.sizeLabel.bottomAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 20),
        ])
          
        // price label
        self.priceLabel.textAlignment = .center
        self.priceLabel.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        self.priceLabel.textColor = .red
        self.priceLabel.clipsToBounds = true
                                
        self.contentView.addSubview(priceLabel)
        self.priceLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.priceLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            self.priceLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
            self.priceLabel.topAnchor.constraint(equalTo: self.sizeLabel.bottomAnchor, constant: 3),
//            self.priceLabel.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -7),
        ])
            
        
    }

}
