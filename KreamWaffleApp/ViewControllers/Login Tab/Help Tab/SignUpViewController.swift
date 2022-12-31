//
//  SignUpViewController.swift
//  KreamWaffleApp
//
//  Created by grace kim  on 2023/01/01.
//

import UIKit

class SignUpViewController: UIViewController {

    var backButton = UIButton()
    var titleLabel = UILabel()
    var emailField : LoginTextfield?
    var passwordField : LoginTextfield?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.emailField = LoginTextfield(titleText: "이메일 주소 *", errorText: "올바른 이메일을 입력해주세요.", errorCondition: .email, placeholderText: nil, defaultButtonImage: "xmark.circle.fill", pressedButtonImage: "xmark.circle.fill")
        self.passwordField = LoginTextfield(titleText: "비밀번호 *", errorText: "영문, 숫자, 특수문자를 조합해서 입력해주세요. (8-16자)", errorCondition: .password, placeholderText: nil, defaultButtonImage: "eye.slash", pressedButtonImage: "eye")
    
        
        addSubviews()
        configureSubviews()
    }
    
    func addSubviews(){
        self.view.addSubview(backButton)
        self.view.addSubview(titleLabel)
        self.view.addSubview(emailField!)
        self.view.addSubview(passwordField!)
    }
    
    func configureSubviews(){
        configureBackandTitle()
        configureTextfields()
    }
    
    func configureBackandTitle(){
        let backImage = UIImage(systemName: "arrow.backward")
        let tinted_backImage = backImage?.withRenderingMode(.alwaysTemplate)
        self.backButton.setImage(tinted_backImage, for: .normal)
        self.backButton.tintColor = .black
        self.backButton.addTarget(self, action: #selector(popVC), for: .touchUpInside)
        self.backButton.translatesAutoresizingMaskIntoConstraints = false
        self.backButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20).isActive = true
        self.backButton.heightAnchor.constraint(equalToConstant: self.view.frame.height/32).isActive = true
        self.backButton.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
        self.backButton.widthAnchor.constraint(equalToConstant: 20).isActive = true
        
        self.titleLabel.text = "회원가입"
        self.titleLabel.attributedText = NSAttributedString(string: "회원가입", attributes: [NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 30, weight: .bold)])
        self.titleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.titleLabel.topAnchor.constraint(equalTo: self.backButton.bottomAnchor, constant: 10).isActive = true
        self.titleLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20).isActive = true
    }
    
    @objc func popVC(){
        self.dismiss(animated: false)
    }
    
    func configureTextfields(){
        self.emailField?.translatesAutoresizingMaskIntoConstraints = false
        self.emailField?.topAnchor.constraint(equalTo: self.titleLabel.bottomAnchor, constant: 20).isActive = true
        self.emailField?.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20).isActive = true
        self.emailField?.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20).isActive = true
        self.emailField?.heightAnchor.constraint(greaterThanOrEqualToConstant: 50).isActive = true
        
        self.passwordField?.translatesAutoresizingMaskIntoConstraints = false
        self.passwordField?.topAnchor.constraint(equalTo: self.emailField!.bottomAnchor, constant: 30).isActive = true
        self.passwordField?.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20).isActive = true
        self.passwordField?.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20).isActive = true
        self.passwordField?.heightAnchor.constraint(greaterThanOrEqualToConstant: 50).isActive = true
        
        
    }

}
