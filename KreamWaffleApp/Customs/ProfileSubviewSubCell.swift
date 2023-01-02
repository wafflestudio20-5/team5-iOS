//
//  ProfileSubviewSubCell.swift
//  KreamWaffleApp
//
//  Created by grace kim  on 2023/01/02.
//
import Foundation
import UIKit

class ProfileSubviewSubCell : UIView {
    
    var mySet : titleNumberSet?
    var titleLabel = UILabel()
    var numberLabel = UILabel()
    
    init(mySet : titleNumberSet){
        self.mySet = mySet
        super.init(frame: .zero)
        self.backgroundColor = .clear
        self.addSubviews(titleLabel, numberLabel)
        configureDesign()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureDesign(){
        self.titleLabel.text = mySet?.title
        let numberString = String(mySet?.number ?? 0)
        self.numberLabel.text = numberString
        
        self.titleLabel.textColor = .black
        self.titleLabel.font = UIFont.systemFont(ofSize: 14, weight: .light)
        self.titleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.titleLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        self.titleLabel.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        
        self.numberLabel.textColor = .green
        self.numberLabel.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        self.numberLabel.translatesAutoresizingMaskIntoConstraints = false
        self.numberLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        self.numberLabel.topAnchor.constraint(equalTo: self.titleLabel.bottomAnchor, constant: 5).isActive = true
    }
    
    //외부에서 접근 가능함
    public func setNumberColor(changeColor: UIColor){
        self.numberLabel.textColor = changeColor
    }
    
    
}
