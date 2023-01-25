//
//  ShoeSizeSelectionCollectionViewCell.swift
//  KreamWaffleApp
//
//  Created by grace kim  on 2023/01/01.
//

import UIKit

//두번 쓰임 (개인 프로필 페이지 + 회원가입 페이지)

class ShoeSizeSelectionCollectionViewCell: UICollectionViewCell {
    
    var size : Int?
    var sizeLabel = UILabel()
    
    override init(frame: CGRect){
        super.init(frame: .zero)
    }
    
    func setInt(size: Int){
        self.size = size
        self.contentView.addSubview(sizeLabel)
        configureDesign()
    }
    
    override var reuseIdentifier: String {
        return "ShoeSizeSelectionCollectionViewCell"
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureDesign(){
        self.contentView.backgroundColor = .white
        self.sizeLabel.textAlignment = .center
        self.sizeLabel.attributedText = NSAttributedString(string: String(self.size ?? 0), attributes: [NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15, weight: .regular)])
        self.contentView.layer.borderWidth = 0.3
        self.contentView.layer.borderColor = UIColor.lightGray.cgColor
        self.sizeLabel.translatesAutoresizingMaskIntoConstraints = false
        self.sizeLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor).isActive = true
        self.sizeLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor).isActive = true
        self.sizeLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor).isActive = true
        self.sizeLabel.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor).isActive = true
        self.sizeLabel.clipsToBounds = true
        self.contentView.layer.cornerRadius = 7
    }
    
    //only used in myinfo page
    func setSelectedDesign(){
        
    }
}
