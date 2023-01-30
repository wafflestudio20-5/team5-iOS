//
//  FindPasswordViewController.swift
//  KreamWaffleApp
//
//  Created by grace kim  on 2023/01/01.
//

import UIKit

class FindPasswordViewController: UIViewController {
    
    //TODO: Error --> 일치하는 사용자 정보가 없을때는 "일치하는 사용자 정보가 없습니다" 알람이 뜨고 textfield 다시 respond.
    
    var titleLabel = UIView()
    var emailField : CustomTextfield!
    var descriptionField = UILabel()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.emailField = CustomTextfield(titleText: "이메일 주소", errorText: "올바른 이메일을 입력해주세요.", errorCondition: .email, placeholderText: "예) kream@kream.co.kr", defaultButtonImage: "xmark.circle.fill", pressedButtonImage: "xmark.circle.fill")
        addSubviews()
        configureTitle()
        configureBody()
    }
    
    func addSubviews(){
        self.view.addSubview(titleLabel)
        self.view.addSubview(descriptionField)
        self.view.addSubview(emailField)
    }
    
    func configureTitle(){
        self.titleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.titleLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        self.titleLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        self.titleLabel.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        self.titleLabel.heightAnchor.constraint(equalToConstant: self.view.frame.height/16).isActive = true
        self.titleLabel.backgroundColor = .white
        let titleString = UILabel()
        titleString.attributedText = NSAttributedString(string: "비밀번호 찾기", attributes: [NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17, weight: .bold)])
        self.titleLabel.addSubview(titleString)
        titleString.translatesAutoresizingMaskIntoConstraints = false
        titleString.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor).isActive = true
        titleString.centerXAnchor.constraint(equalTo: titleLabel.centerXAnchor).isActive = true
        
        let cancelButton = UIButton()
        let cancelText = NSAttributedString(string: "취소", attributes: [NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17, weight: .bold)])
        cancelButton.setAttributedTitle(cancelText, for: .normal)
        self.titleLabel.addSubview(cancelButton)
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        cancelButton.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: -20).isActive = true
        cancelButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor).isActive = true
        cancelButton.addTarget(self, action: #selector(TappedCancel), for: .touchUpInside)
    }
    
    @objc func TappedCancel(){
        self.dismiss(animated: true)
    }
    
    func configureBody(){
        self.descriptionField.attributedText = NSAttributedString(string: "가입 시 등록하신 이메일을 입력하시면, 휴대폰으로 임시 비밀번호를 전송해 드립니다.", attributes: [NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12, weight: .medium)])
        self.descriptionField.numberOfLines = 0
        //self.descriptionField.adjustsFontSizeToFitWidth = true
        //self.descriptionField.minimumScaleFactor = 0.8
        self.descriptionField.translatesAutoresizingMaskIntoConstraints = false
        self.descriptionField.topAnchor.constraint(equalTo: self.titleLabel.bottomAnchor, constant: self.view.frame.height/32).isActive = true
        self.descriptionField.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20).isActive = true
        self.descriptionField.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20).isActive = true
        
        self.emailField?.translatesAutoresizingMaskIntoConstraints = false
        self.emailField?.topAnchor.constraint(equalTo: self.descriptionField.bottomAnchor, constant: 20).isActive = true
        self.emailField?.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20).isActive = true
        self.emailField?.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20).isActive = true
        self.emailField?.heightAnchor.constraint(greaterThanOrEqualToConstant: 50).isActive = true
    }
}
