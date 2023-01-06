//
//  TermsButton.swift
//  KreamWaffleApp
//
//  Created by grace kim  on 2023/01/02.
//

import Foundation
import UIKit

class TermsButton : UIView {
    var checkButton = UIButton()
    var titleLabel = UILabel()
    var  rightButton = UIButton()
    var checked = false
    
    let tinted_unchecked = UIImage(systemName: "checkmark.square")?.withRenderingMode(.alwaysTemplate)
    let tinted_checked = UIImage(systemName: "checkmark.square.fill")?.withRenderingMode(.alwaysTemplate)
    
    var titleString : String?
    
    init(title: String, rightButtonImage : String, pressedRightButtonImage : String){
        //조건까지 할거라면 text로 변환
        self.titleString = title
        let untinted = UIImage(systemName: rightButtonImage)
        let tinted = untinted?.withRenderingMode(.alwaysTemplate)
        self.rightButton.setImage(tinted, for: .normal)
        self.rightButton.tintColor = .black
        super.init(frame: .zero)
        self.backgroundColor = .clear
        self.addSubview(checkButton)
        self.addSubview(titleLabel)
        //self.addSubview(rightButton)
        configureDesigns()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureDesigns(){
        self.checkButton.setImage(tinted_unchecked, for: .normal)
        self.checkButton.addTarget(self, action: #selector(switcher), for: .touchUpInside)
        self.checkButton.tintColor = .black
        self.checkButton.translatesAutoresizingMaskIntoConstraints = false
        self.checkButton.widthAnchor.constraint(equalToConstant: 25).isActive = true
        self.checkButton.heightAnchor.constraint(equalToConstant: 25).isActive = true
        self.checkButton.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        self.checkButton.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        
        self.titleLabel.text = titleString
        self.titleLabel.textColor = .black
        self.titleLabel.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        self.titleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.titleLabel.leadingAnchor.constraint(equalTo: self.checkButton.trailingAnchor, constant: 10).isActive = true
        self.titleLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        
        /*
        self.rightButton.translatesAutoresizingMaskIntoConstraints = false
        self.rightButton.translatesAutoresizingMaskIntoConstraints = false
        self.rightButton.widthAnchor.constraint(equalToConstant: 20).isActive = true
        self.rightButton.heightAnchor.constraint(equalToConstant: 20).isActive = true
        self.rightButton.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        self.rightButton.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true*/
        
    }
    
    @objc func switcher(){
        self.checked = !self.checked
        if (self.checked){
            self.checkButton.setImage(tinted_checked, for: .normal)
        }else{
            self.checkButton.setImage(tinted_unchecked, for: .normal)
        }
    }
}
