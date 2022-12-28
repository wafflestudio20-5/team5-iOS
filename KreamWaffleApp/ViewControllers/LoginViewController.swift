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
    
    private var emailLabel = UILabel()
    private var emailTextfield = UITextField()
    private var emailLine = UILabel()
    private var emailWarningLine = UILabel()
    private var passwordLabel = UILabel()
    private var passwordTextfield = UITextField()
    private var passwordLine = UILabel()
    private var passwordWarningLine = UILabel()
    private var eyeButton = UIButton()
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
        self.view.addSubview(passwordLabel)
        self.view.addSubview(passwordTextfield)
        self.view.addSubview(passwordLine)
        self.view.addSubview(passwordWarningLine)
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
        //self.emailTextfield.addTarget(self, action: #selector(startEditTextfield), for: .allEditingEvents)
        //self.emailTextfield.addTarget(self, action: #selector(endEditTextfield), for: .editingDidEnd)
        self.emailLine.backgroundColor = .lightGray
        self.emailLine.translatesAutoresizingMaskIntoConstraints = false
        self.emailLine.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20).isActive = true
        self.emailLine.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20).isActive = true
        self.emailLine.topAnchor.constraint(equalTo: self.emailTextfield.bottomAnchor, constant: 10).isActive = true
        self.emailLine.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        self.emailWarningLine.text = "올바른 이메일을 입력해주세요."
        self.emailWarningLine.textColor = .clear
        self.emailWarningLine.translatesAutoresizingMaskIntoConstraints = false
        self.emailWarningLine.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20).isActive = true
        self.emailWarningLine.topAnchor.constraint(equalTo: self.emailLine.bottomAnchor, constant: 2).isActive = true
        self.emailWarningLine.font = UIFont.systemFont(ofSize: 10, weight: .light)
    }
    
    private func configurePasswordField(){
        self.passwordLabel.text = "비밀번호"
        self.passwordLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        self.passwordLabel.textColor = .black
        self.passwordLabel.translatesAutoresizingMaskIntoConstraints = false
        self.passwordLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20).isActive = true
        self.passwordLabel.topAnchor.constraint(equalTo: self.emailLine.bottomAnchor, constant: 20).isActive = true
        
        self.passwordTextfield.backgroundColor = .clear
        self.passwordTextfield.translatesAutoresizingMaskIntoConstraints = false
        self.passwordTextfield.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20).isActive = true
        self.passwordTextfield.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20).isActive = true
        self.passwordTextfield.topAnchor.constraint(equalTo: self.passwordLabel.bottomAnchor, constant: 5).isActive = true
        self.passwordTextfield.autocorrectionType = .no
        self.passwordTextfield.autocapitalizationType = .none
        self.passwordTextfield.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        //self.passwordTextfield.addTarget(self, action: #selector(startEditTextfield), for: .editingDidBegin)
        //self.passwordTextfield.addTarget(self, action: #selector(endEditTextfield), for: .editingDidEnd)
        
        self.passwordLine.backgroundColor = .lightGray
        self.passwordLine.translatesAutoresizingMaskIntoConstraints = false
        self.passwordLine.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20).isActive = true
        self.passwordLine.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20).isActive = true
        self.passwordLine.topAnchor.constraint(equalTo: self.passwordTextfield.bottomAnchor, constant: 10).isActive = true
        self.passwordLine.heightAnchor.constraint(equalToConstant: 1).isActive = true
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
    
    @objc func startEditTextfield(sender: UITextField){
        if (sender.isEqual(self.emailTextfield)){
            self.passwordLine.backgroundColor = .black
            while(!isValidEmail(passwordTextfield.text ?? "")){
                self.emailLabel.textColor = .red
                self.emailWarningLine.backgroundColor = .red
            }
                self.emailLabel.textColor = .black
                self.emailWarningLine.backgroundColor = .clear
        }else if (sender.isEqual(self.passwordTextfield)){
            
        }
    }
    
    @objc func endEditTextfield(sender: UITextField){
        if (sender.isEqual(self.passwordTextfield)){
            
            
        }else if (sender.isEqual(self.emailTextfield)){
            
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
    
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
}
