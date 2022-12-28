//
//  LoginViewController.swift
//  KreamWaffleApp
//
//  Created by grace kim  on 2022/12/28.
//

import UIKit

class LoginViewController: UIViewController {
    
    private var exitButton = UIButton()
    private var logoImage = UIImageView()
    
    //email field
    private var emailLabel = UILabel()
    private var emailTextfield = UITextField()
    private var emailLine = UILabel()
    private var emailWarningLine = UILabel()
    private var deleteButton = UIButton()
    
    //password field
    private var passwordLabel = UILabel()
    private var passwordTextfield = UITextField()
    private var passwordLine = UILabel()
    private var passwordWarningLine = UILabel()
    private var eyeButton = UIButton()
    
    //login field
    private var loginButton = UIButton()
    private var helpStack = UIStackView()
    private var signupButton = UIButton()
    private var findEmailButton = UIButton()
    private var findPasswordButton = UIButton()
    
    private var naverLoginButton = UIButton()
    private var appleLoginButton = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        addSubviews()
        configureSubviews()
    }
    
    private func addSubviews(){
        self.view.addSubview(exitButton)
        self.view.addSubview(logoImage)
        self.view.addSubview(emailLabel)
        self.view.addSubview(emailTextfield)
        self.view.addSubview(emailLine)
        self.view.addSubview(emailWarningLine)
        self.view.addSubview(deleteButton)
        self.view.addSubview(passwordLabel)
        self.view.addSubview(passwordTextfield)
        self.view.addSubview(passwordLine)
        self.view.addSubview(passwordWarningLine)
        self.view.addSubview(eyeButton)
        self.view.addSubview(loginButton)
        self.view.addSubview(helpStack)
    }
    
    private func configureSubviews(){
        configureExitButton()
        configureLogoImage()
        configureEmailField()
        configurePasswordField()
        configureLoginButton()
        configureHelpStack()
    }
    
    private func configureExitButton(){
        let xImage = UIImage(systemName: "xmark")
        let tintedImage = xImage?.withRenderingMode(.alwaysTemplate)
        self.exitButton.setImage(tintedImage, for: .normal)
        self.exitButton.tintColor = .black
        self.exitButton.translatesAutoresizingMaskIntoConstraints = false
        self.exitButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
        self.exitButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        self.exitButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -10).isActive = true
        self.exitButton.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 50).isActive = true
    }
    
    private func configureLogoImage(){
        let unresizedLogo = UIImage(named: "loginLogo")
        let screenWidth = self.view.frame.width
        let resizedLogo = resizeImage(image: unresizedLogo!, targetSize: CGSize(width: screenWidth/2, height: screenWidth/8))
        self.logoImage.image = resizedLogo
        self.logoImage.translatesAutoresizingMaskIntoConstraints = false
        self.logoImage.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        self.logoImage.topAnchor.constraint(equalTo: self.exitButton.bottomAnchor, constant: screenWidth/8).isActive = true
    }
    
    private func configureEmailField(){
        self.emailLabel.text = "이메일 주소"
        self.emailLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        self.emailLabel.textColor = .black
        self.emailLabel.translatesAutoresizingMaskIntoConstraints = false
        self.emailLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20).isActive = true
        self.emailLabel.topAnchor.constraint(equalTo: self.logoImage.bottomAnchor, constant: self.view.frame.width/8).isActive = true
        
        self.emailTextfield.attributedPlaceholder = NSAttributedString(string: "예) kream@kream.co.kr", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15, weight: .regular)])
        self.emailTextfield.backgroundColor = .clear
        self.emailTextfield.translatesAutoresizingMaskIntoConstraints = false
        self.emailTextfield.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20).isActive = true
        self.emailTextfield.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20).isActive = true
        self.emailTextfield.topAnchor.constraint(equalTo: self.emailLabel.bottomAnchor, constant: 5).isActive = true
        self.emailTextfield.autocorrectionType = .no
        self.emailTextfield.autocapitalizationType = .none
        self.emailTextfield.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        self.emailTextfield.addTarget(self, action: #selector(startEditTextfield(_:)), for: .editingChanged)
        self.emailTextfield.addTarget(self, action: #selector(endEditTextfield(_:)), for: .editingDidEnd)
        
        self.emailLine.backgroundColor = .lightGray
        self.emailLine.translatesAutoresizingMaskIntoConstraints = false
        self.emailLine.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20).isActive = true
        self.emailLine.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20).isActive = true
        self.emailLine.topAnchor.constraint(equalTo: self.emailTextfield.bottomAnchor, constant: 10).isActive = true
        self.emailLine.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        
        self.emailWarningLine.text = "올바른 이메일을 입력해주세요."
        self.emailWarningLine.textColor = .clear
        self.emailWarningLine.translatesAutoresizingMaskIntoConstraints = false
        self.emailWarningLine.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20).isActive = true
        self.emailWarningLine.topAnchor.constraint(equalTo: self.emailLine.bottomAnchor, constant: 4).isActive = true
        self.emailWarningLine.font = UIFont.systemFont(ofSize: 12, weight: .light)
        
        let deleteImage = UIImage(systemName: "xmark.circle.fill")
        let tintedImage = deleteImage?.withRenderingMode(.alwaysTemplate)
        self.deleteButton.setImage(tintedImage, for: .normal)
        self.deleteButton.tintColor = .clear
        self.deleteButton.translatesAutoresizingMaskIntoConstraints = false
        self.deleteButton.trailingAnchor.constraint(equalTo: self.emailLine.trailingAnchor).isActive = true
        self.deleteButton.widthAnchor.constraint(equalToConstant: 14).isActive = true
        self.deleteButton.heightAnchor.constraint(equalToConstant: 14).isActive = true
        self.deleteButton.centerYAnchor.constraint(equalTo: self.emailTextfield.centerYAnchor).isActive = true
        self.deleteButton.addTarget(self, action: #selector(didTapEmptyTextField), for: .touchUpInside)
    }
    
    @objc func didTapEmptyTextField(){
        self.emailTextfield.text?.removeAll()
    }
    
    private func configurePasswordField(){
        self.passwordLabel.text = "비밀번호"
        self.passwordLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        self.passwordLabel.textColor = .black
        self.passwordLabel.translatesAutoresizingMaskIntoConstraints = false
        self.passwordLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20).isActive = true
        self.passwordLabel.topAnchor.constraint(equalTo: self.emailLine.bottomAnchor, constant: 30).isActive = true
        
        self.passwordTextfield.backgroundColor = .clear
        self.passwordTextfield.translatesAutoresizingMaskIntoConstraints = false
        self.passwordTextfield.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20).isActive = true
        self.passwordTextfield.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20).isActive = true
        self.passwordTextfield.topAnchor.constraint(equalTo: self.passwordLabel.bottomAnchor, constant: 5).isActive = true
        self.passwordTextfield.autocorrectionType = .no
        self.passwordTextfield.autocapitalizationType = .none
        self.passwordTextfield.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        self.passwordTextfield.addTarget(self, action: #selector(startEditTextfield(_:)), for: .editingChanged)
        self.passwordTextfield.addTarget(self, action: #selector(endEditTextfield(_:)), for: .editingDidEnd)
        self.passwordTextfield.isSecureTextEntry = true
        
        self.passwordLine.backgroundColor = .lightGray
        self.passwordLine.translatesAutoresizingMaskIntoConstraints = false
        self.passwordLine.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20).isActive = true
        self.passwordLine.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20).isActive = true
        self.passwordLine.topAnchor.constraint(equalTo: self.passwordTextfield.bottomAnchor, constant: 10).isActive = true
        self.passwordLine.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        
        self.passwordWarningLine.text = "영문, 숫자, 특수문자를 조합해서 입력해주세요. (8-16자)"
        self.passwordWarningLine.textColor = .clear
        self.passwordWarningLine.translatesAutoresizingMaskIntoConstraints = false
        self.passwordWarningLine.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20).isActive = true
        self.passwordWarningLine.topAnchor.constraint(equalTo: self.passwordLine.bottomAnchor, constant: 4).isActive = true
        self.passwordWarningLine.font = UIFont.systemFont(ofSize: 12, weight: .light)
        
        let eyeImage = UIImage(systemName: "eye.slash")
        let tintedImage = eyeImage?.withRenderingMode(.alwaysTemplate)
        self.eyeButton.setImage(tintedImage, for: .normal)
        self.eyeButton.tintColor = .darkGray
        self.eyeButton.translatesAutoresizingMaskIntoConstraints = false
        self.eyeButton.trailingAnchor.constraint(equalTo: self.passwordLine.trailingAnchor).isActive = true
        self.eyeButton.widthAnchor.constraint(equalToConstant: 21).isActive = true
        self.eyeButton.heightAnchor.constraint(equalToConstant: 14).isActive = true
        self.eyeButton.centerYAnchor.constraint(equalTo: self.passwordTextfield.centerYAnchor).isActive = true
        self.eyeButton.addTarget(self, action: #selector(didTapSeePassword), for: .touchUpInside)
    }
    
    @objc func didTapSeePassword(){
        if (self.passwordTextfield.isSecureTextEntry){
            let openeyeImage = UIImage(systemName: "eye")
            let tintedeyeImage = openeyeImage?.withRenderingMode(.alwaysTemplate)
            self.eyeButton.setImage(tintedeyeImage, for: .normal)
            self.eyeButton.tintColor = .darkGray
        }else{
            let eyeImage = UIImage(systemName: "eye.slash")
            let tintedImage = eyeImage?.withRenderingMode(.alwaysTemplate)
            self.eyeButton.setImage(tintedImage, for: .normal)
            self.eyeButton.tintColor = .darkGray
        }
        self.passwordTextfield.isSecureTextEntry = !self.passwordTextfield.isSecureTextEntry
    }

    private func configureLoginButton(){
        self.loginButton.translatesAutoresizingMaskIntoConstraints = false
        self.loginButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20).isActive = true
        self.loginButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20).isActive = true
        self.loginButton.topAnchor.constraint(equalTo: self.passwordLine.bottomAnchor, constant: self.view.frame.height/16).isActive = true
        self.loginButton.heightAnchor.constraint(equalToConstant: self.view.frame.height/16).isActive = true
        self.loginButton.setTitle("로그인", for: .normal)
        self.loginButton.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .light)
        self.loginButton.backgroundColor = .lightGray
        self.loginButton.titleLabel?.textColor = .white
        self.loginButton.layer.cornerRadius = 10
        self.loginButton.clipsToBounds = true
    }
    
    private func configureHelpStack(){
        self.helpStack.axis = .horizontal
        self.helpStack.distribution = .equalSpacing
        self.helpStack.addArrangedSubviews([signupButton, findEmailButton, findPasswordButton])
        self.helpStack.translatesAutoresizingMaskIntoConstraints = false
        self.helpStack.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20).isActive = true
        self.helpStack.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20).isActive = true
        self.helpStack.topAnchor.constraint(equalTo: self.loginButton.bottomAnchor, constant: 20).isActive = true
        self.signupButton.setTitle("이메일 가입", for: .normal)
        self.signupButton.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .light)
        self.signupButton.titleLabel?.textColor = .black
        self.findEmailButton.setTitle("이메일 찾기", for: .normal)
        self.findEmailButton.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .light)
        self.findEmailButton.titleLabel?.textColor = .black
        self.findPasswordButton.setTitle("비밀번호 찾기", for: .normal)
        self.findPasswordButton.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .light)
        self.findPasswordButton.titleLabel?.textColor = .black
    }
    
    @objc func startEditTextfield(_ sender: UITextField){
        if (sender.isEqual(self.emailTextfield)){
        self.emailLine.backgroundColor = .black
            self.deleteButton.tintColor = .darkGray
        if(!isValidEmail(email: sender.text!)){
            self.emailLabel.textColor = colors.errorRed
            self.emailWarningLine.textColor = colors.errorRed
            self.emailLabel.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        }else{
            self.emailLabel.textColor = .black
            self.emailWarningLine.textColor = .clear
        }
        }else{
            //password field sending
            self.passwordLine.backgroundColor = .black
            if (!isValidPassword(password: sender.text!)){
                self.passwordLabel.textColor = colors.errorRed
                self.passwordWarningLine.textColor = colors.errorRed
                self.passwordLabel.font = UIFont.systemFont(ofSize: 15, weight: .medium)
            }else{
                self.passwordLabel.textColor = .black
                self.passwordWarningLine.textColor = .clear
            }
        }
    }
    
    @objc func endEditTextfield(_ sender: UITextField){
        if (sender.isEqual(self.passwordTextfield)){
            if (isValidPassword(password: sender.text!)){
                self.passwordLine.backgroundColor = .lightGray
            }else{
                self.passwordLine.backgroundColor = colors.errorRed
            }
            
        }else if (sender.isEqual(self.emailTextfield)){
            if (isValidEmail(email: sender.text!)){
                self.emailLine.backgroundColor = .lightGray
            }else{
                self.emailLine.backgroundColor = colors.errorRed
            }
        }
    }
    
   

    

    

}

extension LoginViewController {
    func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size
        
        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height
        
        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
        }
        
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    
    public func isValidEmail(email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    public func isValidPassword(password: String) -> Bool {
        let passwordRegex = "^(?=.*\\d)(?=.*[a-z])(?=.*[A-Z])[0-9a-zA-Z!@#$%^&*()\\-_=+{}|?>.<,:;~`’]{8,}$"
        let passwordPred = NSPredicate(format: "SELF MATCHES %@", passwordRegex)
        return passwordPred.evaluate(with: password)
    }
}
