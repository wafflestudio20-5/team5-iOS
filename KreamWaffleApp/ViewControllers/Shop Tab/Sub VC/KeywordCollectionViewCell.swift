//
//  KeywordCollectionViewCell.swift
//  KreamWaffleApp
//
//  Created by grace kim  on 2022/12/28.
//

import UIKit

enum KeywordType {
    case recent, recommend
}

class KeywordCollectionViewCell: UICollectionViewCell {
    var type : KeywordType
    var label = UILabel()
    var keywordText : String
    var deleteButton = UIButton()
    
    override var reuseIdentifier: String {
        return "KeywordCollectionViewCell"
    }
    
    init(frame: CGRect, keyword: String, type: KeywordType){
        self.type = type
        self.keywordText = keyword
        super.init(frame: .zero)
        self.contentView.addSubview(label)
        configureDesign()
    }
    
    func configureDesign(){
        self.label.translatesAutoresizingMaskIntoConstraints = false
        self.label.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor).isActive = true
        self.label.topAnchor.constraint(equalTo: self.contentView.topAnchor).isActive = true
        self.label.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor).isActive = true
        self.label.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor).isActive = true
        
        self.label.text = self.keywordText
        self.label.textColor = .black
        self.label.font = UIFont.systemFont(ofSize: 12, weight: .light)
        let xImage = UIImage(systemName: "xmark")
        let tintedImage = xImage?.withRenderingMode(.alwaysTemplate)
        self.deleteButton.setImage(tintedImage, for: .normal)
        self.deleteButton.tintColor = .lightGray
        self.label.layer.borderColor = UIColor.lightGray.cgColor
        self.label.layer.borderWidth = 1.0
        self.contentView.layer.cornerRadius = 5
        
        switch (self.type) {
        case .recent:
            label.backgroundColor = .white
            self.label.addSubview(deleteButton)
            self.deleteButton.translatesAutoresizingMaskIntoConstraints = false
            self.deleteButton.trailingAnchor.constraint(equalTo: self.label.trailingAnchor, constant: -3).isActive = true
            self.deleteButton.centerYAnchor.constraint(equalTo: self.label.centerYAnchor).isActive = true
        
        case .recommend:
            label.backgroundColor = UIColor.gray
        }
        
        self.label.clipsToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
