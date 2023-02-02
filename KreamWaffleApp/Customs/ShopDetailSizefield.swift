//
//  ShopDetailSizeField.swift
//  KreamWaffleApp
//
//  Created by 이선재 on 2023/02/01.
//

import Foundation
import UIKit

class ShopDetailSizefield : UIView {
    
    var selectedSize : Int?
    
    var textfield = PaddingLabel(withInsets: 10, 10, 10, 10)
    var button = UIButton()
    
    init(selectedSize: Int?){
        self.selectedSize = selectedSize
        super.init(frame: .zero)
        self.addSubviews(textfield, button)
        setDesign()
    }
    

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setDesign(){
        configureTextfield()
        configureButton()
    }

    
    func configureTextfield(){
       self.textfield.attributedText = NSAttributedString(string: String(selectedSize ?? 0), attributes: [NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15, weight: .regular)])
        
        if (self.selectedSize == nil){
            self.textfield.text = "모든 사이즈"
        }
        
        self.textfield.translatesAutoresizingMaskIntoConstraints = false
        self.textfield.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        self.textfield.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        self.textfield.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        
        self.textfield.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        
        self.textfield.layer.borderColor = UIColor.lightGray.cgColor
        self.textfield.layer.borderWidth = 0.5
        self.textfield.layer.cornerRadius = 10
        
    }

    
    func configureButton(){
        let defaultImage = UIImage(systemName: "arrowtriangle.down.circle")
        let tinted_defaultImage = defaultImage?.withRenderingMode(.alwaysTemplate)
        self.button.setImage(tinted_defaultImage, for: .normal)
        self.button.tintColor = .black
        
        self.button.translatesAutoresizingMaskIntoConstraints = false
        self.button.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10).isActive = true
        self.button.widthAnchor.constraint(equalToConstant: 25).isActive = true
        self.button.heightAnchor.constraint(equalToConstant: 25).isActive = true
        self.button.centerYAnchor.constraint(equalTo: self.textfield.centerYAnchor).isActive = true
    }
    
    
    //외부에서 접근가능함.
    func setTextfield(SelectedSize: Int){
        self.selectedSize = SelectedSize
//        self.textfield.text = "\(self.selectedSize)"
        self.textfield.attributedText = NSAttributedString(string: String(self.selectedSize ?? 0), attributes: [NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16, weight: .bold)])
    }
}
