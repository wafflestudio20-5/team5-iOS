//
//  LoginTextfield.swift
//  KreamWaffleApp
//
//  Created by grace kim  on 2022/12/30.
//

import Foundation
import UIKit

//TODO: [refactoring] rxswift 로 고치기 --> 이걸 어디서 해야하는걸까.
enum errorCondition{
    
    case password
    case email
    case phoneNumber
    case profileName
    case none
    
    public func isValidPassword(input: String)->Bool{
        let passwordRegex = "^(?=.*[a-z])(?=.*[$@$#!%*?&]).{8,}$"
        let passwordPred = NSPredicate(format: "SELF MATCHES %@", passwordRegex)
        return passwordPred.evaluate(with: input)
    }
    
    public func isValidEmail(input: String) -> Bool{
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: input)
    }
    
    public func isValidProfileName(input: String) -> Bool{
        let profileRegEx = "^(?=.*[a-z])(?=.*[_.]).{4,25}$"
        let profilePred = NSPredicate(format: "SELF MATCHES %@", profileRegEx)
        return profilePred.evaluate(with: input)
    }
    
    public func isValidPhoneNumber(inpput: String)->Bool{
        return true;
    }
}

class CustomTextfield : UIView {
    
    var titleText: String
    var errorText: String
    var errorCondition: errorCondition
    var placeholderText : String?
    var defaultButtonImage: String?
    var pressedButtonImage : String?
    var maxCount: Int?
    
    var titleLabel = UILabel()
    var textfield = UITextField() 
    var bottomLine = UILabel()
    var warningLine = UILabel()
    var countLabel = UILabel()
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
        self.textfield.textColor = .black
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
        self.textfield.addTarget(self, action: #selector(touchedTextfield(_:)), for: .editingDidBegin)
        if (self.errorCondition == .password){
            self.textfield.isSecureTextEntry =  true
        }
    }
    
    @objc func touchedTextfield(_ sender: UITextField){
        self.titleLabel.textColor = .black
        self.bottomLine.backgroundColor = .black
        self.warningLine.textColor = .clear
    }
    
    @objc func changedTextfield(){
        if (self.textfield.hasText){
            self.button.tintColor = .darkGray
        }else{
            self.button.tintColor = .clear
        }
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
        var buttonWidth = 0.0
        var buttonHeight = 0.0
        switch(self.errorCondition){
        case .password:
            buttonWidth = 25
            buttonHeight = 20
        case .email, .phoneNumber:
            self.textfield.addTarget(self, action: #selector(changedTextfield), for: .allEditingEvents)
            self.button.tintColor = .clear
            buttonWidth = 25
            buttonHeight = 25
        case .profileName:
            print("")
        case .none:
            print("")
        }
        self.button.widthAnchor.constraint(equalToConstant: buttonWidth).isActive = true
        self.button.heightAnchor.constraint(equalToConstant: buttonHeight).isActive = true
        self.button.centerYAnchor.constraint(equalTo: self.textfield.centerYAnchor).isActive = true
        
        switch(self.errorCondition){
        case .password:
            self.button.addTarget(self, action: #selector(didTapHideTextfield), for: .touchUpInside)
        case .email:
            self.button.addTarget(self, action: #selector(didTapEmptyTextField), for: .touchUpInside)
        case .phoneNumber:
            self.button.addTarget(self, action: #selector(didTapEmptyTextField), for: .touchUpInside)
        case .profileName:
            print("")
        case .none:
            print("")
        }
    }
    
    @objc func didTapEmptyTextField(){
        self.textfield.text?.removeAll()
        self.button.tintColor = .clear
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
        
        self.titleLabel.textColor = .black
        self.bottomLine.backgroundColor = .black
        
        switch(self.errorCondition){
        case .email:
            if (sender.hasText){
                self.button.tintColor = .darkGray
            }
            self.titleLabel.textColor = colors.errorRed
            if(!errorCondition.isValidEmail(input: self.textfield.text ?? "")){
                self.titleLabel.textColor = colors.errorRed
                self.warningLine.textColor = colors.errorRed
                self.titleLabel.font = UIFont.systemFont(ofSize: 15, weight: .medium)
            }else{
                self.titleLabel.textColor = .black
                self.warningLine.textColor = .clear
            }
            
        case .password:
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
            
        case .profileName:
            if(!errorCondition.isValidProfileName(input: self.textfield.text ?? "")){
                self.titleLabel.textColor = colors.errorRed
                self.warningLine.textColor = colors.errorRed
                self.titleLabel.font = UIFont.systemFont(ofSize: 15, weight: .medium)
            }else{
                self.titleLabel.textColor = .black
                self.warningLine.textColor = .clear
            }
        case .none:
            self.titleLabel.textColor = .black
            self.warningLine.textColor = .clear
        }
    }
    
    @objc func endEditTextfield(_ sender: UITextField){
        let valid = (self.isValid() && ((self.textfield.text) != nil))
        if (valid){
            self.bottomLine.backgroundColor = .lightGray
        }else{
            self.bottomLine.backgroundColor = colors.errorRed
            self.warningLine.textColor = colors.errorRed
            self.titleLabel.textColor = colors.errorRed
        }
    }
    
    //외부에서 접근 가능
    func isValid()->Bool{
        switch(self.errorCondition){
        case .email:
            return errorCondition.isValidEmail(input: self.textfield.text ?? "")
        case .password:
            return errorCondition.isValidPassword(input: self.textfield.text ?? "")
        case .phoneNumber:
            return errorCondition.isValidPhoneNumber(inpput: self.textfield.text ?? "")
        case .profileName:
            return errorCondition.isValidProfileName(input: self.textfield.text ?? "")
        case .none:
            return true
        }
    }
    
    func setupTextCounter(maxCount: Int){
        self.addSubview(self.countLabel)
        self.maxCount = maxCount
        let currentText = self.textfield.text
        self.countLabel.text = "\(currentText?.count ?? 0)/\(maxCount)"
        self.countLabel.textColor = .darkGray
        self.countLabel.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        self.countLabel.translatesAutoresizingMaskIntoConstraints = false
        self.countLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        self.countLabel.topAnchor.constraint(equalTo: self.bottomLine.bottomAnchor, constant: 4).isActive = true
    }
    
    func editTextCounter(text: String){
        let count = text.count
        self.countLabel.text = "\(count)/\(maxCount!)"
    }
}







