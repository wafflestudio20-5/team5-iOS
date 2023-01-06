//
//  ShoeSizefield.swift
//  KreamWaffleApp
//
//  Created by grace kim  on 2023/01/01.
//

import Foundation

import Foundation
import UIKit

class ShoeSizefield : UIView {
    
    var selectedSize : Int?
    
    var titleLabel = UILabel()
    var textfield = UILabel()
    var bottomLine = UILabel()
    var button = UIButton()
    
    init(selectedSize: Int?){
    self.selectedSize = selectedSize
    super.init(frame: .zero)
    self.addSubviews(titleLabel, textfield, bottomLine,button)
    setDesign()
    }
    

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setDesign(){
        configureTitle()
        configureTextfield()
        configureLine()
        configureButton()
    }
    
    func configureTitle(){
        self.titleLabel.text = "신발 사이즈"
        self.titleLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        self.titleLabel.textColor = .black
        self.titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        self.titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        self.titleLabel.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
    }
    
    func configureTextfield(){
       self.textfield.attributedText = NSAttributedString(string: String(selectedSize ?? 0), attributes: [NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15, weight: .regular)])
        
        if (self.selectedSize == nil){
            self.textfield.text = "선택하세요"
            self.textfield.textColor = .systemGray
        }
        
        self.textfield.backgroundColor = .clear
        self.textfield.translatesAutoresizingMaskIntoConstraints = false
        self.textfield.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        self.textfield.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        self.textfield.topAnchor.constraint(equalTo: self.titleLabel.bottomAnchor, constant: 5).isActive = true
        self.textfield.font = UIFont.systemFont(ofSize: 15, weight: .regular)
    }
    
    func configureLine(){
        self.bottomLine.backgroundColor = .lightGray
        self.bottomLine.translatesAutoresizingMaskIntoConstraints = false
        self.bottomLine.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        self.bottomLine.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        self.bottomLine.topAnchor.constraint(equalTo: self.textfield.bottomAnchor, constant: 10).isActive = true
        self.bottomLine.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
    }
    
    func configureButton(){
        let defaultImage = UIImage(systemName: "arrowtriangle.down.circle")
        let tinted_defaultImage = defaultImage?.withRenderingMode(.alwaysTemplate)
        self.button.setImage(tinted_defaultImage, for: .normal)
        self.button.tintColor = .lightGray
        self.button.translatesAutoresizingMaskIntoConstraints = false
        self.button.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        self.button.widthAnchor.constraint(equalToConstant: 25).isActive = true
        self.button.heightAnchor.constraint(equalToConstant: 25).isActive = true
        self.button.centerYAnchor.constraint(equalTo: self.textfield.centerYAnchor).isActive = true
    }
    
    
    //외부에서 접근가능함.
    func setTextfield(SelectedSize: Int){
        self.selectedSize = SelectedSize
        self.textfield.attributedText = NSAttributedString(string: String(SelectedSize), attributes: [NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15, weight: .regular)])
    }
}
