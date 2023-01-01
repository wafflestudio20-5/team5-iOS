//
//  LoginTextfield.swift
//  KreamWaffleApp
//
//  Created by grace kim  on 2022/12/30.
//

import Foundation
import UIKit

enum errorCondition{
    
    case password
    case email
    case phoneNumber
    
    public func isValidPassword(input: String)->Bool{
        let passwordRegex = "^(?=.*\\d)(?=.*[a-z])(?=.*[A-Z])[0-9a-zA-Z!@#$%^&*()\\-_=+{}|?>.<,:;~`’]{8,}$"
        let passwordPred = NSPredicate(format: "SELF MATCHES %@", passwordRegex)
        return passwordPred.evaluate(with: input)
    }
    
    public func isValidEmail(input: String) -> Bool{
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: input)
    }
    
    public func isValidPhoneNumber(inpput: String)->Bool{
        return true;
    }
}

class LoginTextfield : UIView {
    
    var titleText: String
    var errorText: String
    var errorCondition: errorCondition
    var placeholderText : String?
    var defaultButtonImage: String?
    var pressedButtonImage : String?
    
    var titleLabel = UILabel()
    var textfield = UITextField()
    var bottomLine = UILabel()
    var warningLine = UILabel()
    var button = UIButton()
    
    init(titleText: String, errorText: String, errorCondition: errorCondition, placeholderText: String?, defaultButtonImage: String?, pressedButtonImage: String?){
    
    self.titleText = titleText
    self.errorText = errorText
    self.errorCondition = errorCondition
    self.placeholderText = placeholderText
    self.defaultButtonImage = defaultButtonImage
    self.pressedButtonImage = pressedButtonImage
    super.init(frame: .zero)
    self.addSubviews(titleLabel, textfield, bottomLine, warningLine, button)
    setDesign()
    
    }
    

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setDesign(){
        configureTitle()
        configureTextfield()
        configureErrorMessage()
        configureButton()
    }
    
    func configureTitle(){
        self.titleLabel.text = titleText
        self.titleLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        self.titleLabel.textColor = .black
        self.titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        self.titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        self.titleLabel.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
    }
    
    func configureTextfield(){
        self.textfield.attributedPlaceholder = NSAttributedString(string: placeholderText ?? "", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15, weight: .regular)])
        self.textfield.backgroundColor = .clear
        self.textfield.translatesAutoresizingMaskIntoConstraints = false
        self.textfield.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        self.textfield.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        self.textfield.topAnchor.constraint(equalTo: self.titleLabel.bottomAnchor, constant: 5).isActive = true
        self.textfield.autocorrectionType = .no
        self.textfield.autocapitalizationType = .none
        self.textfield.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        self.textfield.addTarget(self, action: #selector(startEditTextfield(_:)), for: .editingChanged)
        self.textfield.addTarget(self, action: #selector(endEditTextfield(_:)), for: .editingDidEnd)
    }
    
    func configureErrorMessage(){
        self.bottomLine.backgroundColor = .lightGray
        self.bottomLine.translatesAutoresizingMaskIntoConstraints = false
        self.bottomLine.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        self.bottomLine.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        self.bottomLine.topAnchor.constraint(equalTo: self.textfield.bottomAnchor, constant: 10).isActive = true
        self.bottomLine.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        
        self.warningLine.text = self.errorText
        self.warningLine.textColor = .clear
        self.warningLine.translatesAutoresizingMaskIntoConstraints = false
        self.warningLine.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        self.warningLine.topAnchor.constraint(equalTo: self.bottomLine.bottomAnchor, constant: 4).isActive = true
        self.warningLine.font = UIFont.systemFont(ofSize: 12, weight: .light)
    }
    
    func configureButton(){
        let defaultImage = UIImage(systemName: self.defaultButtonImage ?? "")
        let pressedImage = UIImage(systemName: self.pressedButtonImage ?? "")
        let tinted_defaultImage = defaultImage?.withRenderingMode(.alwaysTemplate)
        let tinted_pressedImage = pressedImage?.withRenderingMode(.alwaysTemplate)
        self.button.setImage(tinted_defaultImage, for: .normal)
        self.button.setImage(tinted_pressedImage, for: .selected)
        self.button.tintColor = .darkGray
        self.button.translatesAutoresizingMaskIntoConstraints = false
        self.button.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        self.button.widthAnchor.constraint(equalToConstant: 16).isActive = true
        self.button.heightAnchor.constraint(equalToConstant: 16).isActive = true
        self.button.centerYAnchor.constraint(equalTo: self.textfield.centerYAnchor).isActive = true
        
        switch(self.errorCondition){
        case .password:
            self.button.addTarget(self, action: #selector(didTapHideTextfield), for: .touchUpInside)
        case .email:
            self.button.addTarget(self, action: #selector(didTapEmptyTextField), for: .touchUpInside)
        case .phoneNumber:
            self.button.addTarget(self, action: #selector(didTapEmptyTextField), for: .touchUpInside)
        }
    }
    
    @objc func didTapEmptyTextField(){
        self.textfield.text?.removeAll()
    }
    
    @objc func didTapHideTextfield(){
        if (self.textfield.isSecureTextEntry){
            let openeyeImage = UIImage(systemName: "eye")
            let tintedeyeImage = openeyeImage?.withRenderingMode(.alwaysTemplate)
            self.button.setImage(tintedeyeImage, for: .normal)
            self.button.tintColor = .darkGray
        }else{
            let eyeImage = UIImage(systemName: "eye.slash")
            let tintedImage = eyeImage?.withRenderingMode(.alwaysTemplate)
            self.button.setImage(tintedImage, for: .normal)
            self.button.tintColor = .darkGray
        }
        self.textfield.isSecureTextEntry = !self.textfield.isSecureTextEntry
    }
    
    @objc func startEditTextfield(_ sender: UITextField){
        
        switch(self.errorCondition){
        case .email:
            self.bottomLine.backgroundColor = .black
            if(!errorCondition.isValidEmail(input: self.textfield.text ?? "")){
                self.titleLabel.textColor = colors.errorRed
                self.warningLine.textColor = colors.errorRed
                self.titleLabel.font = UIFont.systemFont(ofSize: 15, weight: .medium)
            }else{
                self.titleLabel.textColor = .black
                self.warningLine.textColor = .clear
            }
            
        case .password:
            self.bottomLine.backgroundColor = .black
            if(!errorCondition.isValidPassword(input: self.textfield.text ?? "")){
                self.titleLabel.textColor = colors.errorRed
                self.warningLine.textColor = colors.errorRed
                self.titleLabel.font = UIFont.systemFont(ofSize: 15, weight: .medium)
            }else{
                self.titleLabel.textColor = .black
                self.warningLine.textColor = .clear
            }
            
        case .phoneNumber:
            //TODO
            self.bottomLine.backgroundColor = .black
            
        }
    }
    
    @objc func endEditTextfield(_ sender: UITextField){
        switch(self.errorCondition){
            
        case .password:
            if (errorCondition.isValidPassword(input: self.textfield.text ?? "")){
                self.bottomLine.backgroundColor = .lightGray
            }else{
                self.bottomLine.backgroundColor = colors.errorRed
            }
        case .email:
            if (errorCondition.isValidEmail(input: self.textfield.text ?? "")){
                self.bottomLine.backgroundColor = .lightGray
            }else{
                self.bottomLine.backgroundColor = colors.errorRed
            }
        case .phoneNumber:
            //TODO
            self.bottomLine.backgroundColor = .lightGray
        }
    }
}







