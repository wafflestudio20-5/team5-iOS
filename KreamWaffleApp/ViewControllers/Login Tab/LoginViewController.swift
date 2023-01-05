//
//  LoginViewController.swift
//  KreamWaffleApp
//
//  Created by grace kim  on 2022/12/28.
//
import UIKit
import Accelerate
import Alamofire
import NaverThirdPartyLogin
import Kingfisher

class LoginViewController: UIViewController {
    
    
    let NaverLoginInstance = NaverThirdPartyLoginConnection.getSharedInstance()
    
    private var exitButton = UIButton()
    private var logoImage = UIImageView()
    
    //email field
    private var emailfield : LoginTextfield? 
    private var emailValid = false
    
    //password field
    private var passwordfield: LoginTextfield?
    private var passwordValid = false
    
    //login field
    private var loginButton = UIButton()
    private var helpStack = UIStackView()
    
    //social login field
    private var naverLoginButton = UIButton()
    private var googleLoginButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        emailfield = LoginTextfield(titleText: "이메일 주소", errorText: "올바른 이메일을 입력해주세요.", errorCondition: .email, placeholderText: "예) kream@kream.co.kr", defaultButtonImage: "xmark.circle.fill", pressedButtonImage: "xmark.circle.fill")
        passwordfield = LoginTextfield(titleText: "비밀번호", errorText: "영문, 숫자, 특수문자를 조합해서 입력해주세요. (8-16자)", errorCondition: .password, placeholderText: "", defaultButtonImage: "eye.slash", pressedButtonImage: "eye")
        addSubviews()
        configureSubviews()
        self.hideKeyboardWhenTappedAround()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)
        self.navigationItem.hidesBackButton = true
    }
    
    private func addSubviews(){
        self.view.addSubview(exitButton)
        self.view.addSubview(logoImage)
        
        self.view.addSubview(emailfield!)
        self.view.addSubview(passwordfield!)
       
        self.view.addSubview(loginButton)
        self.view.addSubview(helpStack)
        
        self.view.addSubview(naverLoginButton)
        self.view.addSubview(googleLoginButton)
        
    }
    
    private func configureSubviews(){
        configureExitButton()
        configureLogoImage()
        configureEmailField()
        configurePasswordField()
        configureLoginButton()
        configureHelpStack()
        configureSocialLogin()
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
        self.exitButton.addTarget(self, action: #selector(popVC), for: .touchUpInside)
    }
    
    @objc func popVC(){
        //바로 홈화면으로 가네 --> set tab bar controller to index 0
        self.dismiss(animated: false)
    }
    
    private func configureLogoImage(){
        let unresizedLogo = UIImage(named: "loginLogo")
        let screenWidth = self.view.frame.width
        let resizedLogo = unresizedLogo?.resize(targetSize: CGSize(width: screenWidth/2, height: screenWidth/8))
        self.logoImage.image = resizedLogo
        self.logoImage.translatesAutoresizingMaskIntoConstraints = false
        self.logoImage.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        self.logoImage.topAnchor.constraint(equalTo: self.exitButton.bottomAnchor, constant: screenWidth/8).isActive = true
    }
    
    private func configureEmailField(){
        self.emailfield?.translatesAutoresizingMaskIntoConstraints = false
        self.emailfield?.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20).isActive = true
        self.emailfield?.topAnchor.constraint(equalTo: self.logoImage.bottomAnchor, constant: self.view.frame.width/8).isActive = true
        self.emailfield?.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20).isActive = true
        self.emailfield?.heightAnchor.constraint(greaterThanOrEqualToConstant: 50).isActive = true
    }
   
    private func configurePasswordField(){
        self.passwordfield?.translatesAutoresizingMaskIntoConstraints = false
        self.passwordfield?.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20).isActive = true
        self.passwordfield?.topAnchor.constraint(equalTo: self.emailfield!.bottomAnchor, constant: 30).isActive = true
        self.passwordfield?.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20).isActive = true
        self.passwordfield?.heightAnchor.constraint(greaterThanOrEqualToConstant: 50).isActive = true
    }
    

    private func configureLoginButton(){
        self.loginButton.translatesAutoresizingMaskIntoConstraints = false
        self.loginButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20).isActive = true
        self.loginButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20).isActive = true
        self.loginButton.topAnchor.constraint(equalTo: self.passwordfield!.bottomAnchor, constant: self.view.frame.height/32 + 10).isActive = true
        self.loginButton.heightAnchor.constraint(equalToConstant: self.view.frame.height/16).isActive = true
        self.loginButton.setTitle("로그인", for: .normal)
        self.loginButton.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .light)
        self.loginButton.backgroundColor = UIColor(red: 211/255.0, green: 211/255.0, blue: 211/255.0, alpha: 1.0)
        self.loginButton.titleLabel?.textColor = .white
        self.loginButton.layer.cornerRadius = 10
        self.loginButton.clipsToBounds = true
    }
    
    private func configureHelpStack(){
        self.helpStack.axis = .horizontal
        self.helpStack.distribution = .equalSpacing
        
        
        let signup = UIButton()
        signup.setTitle("이메일 가입", for: .normal)
        signup.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        signup.backgroundColor = .clear
        signup.translatesAutoresizingMaskIntoConstraints = false
        signup.setTitleColor(.black, for: .normal)
        signup.addTarget(self, action: #selector(didTapSignup), for: .touchUpInside)
        
        let divider_1 = UIButton()
        divider_1.backgroundColor = colors.lessLightGray
        divider_1.translatesAutoresizingMaskIntoConstraints = false
        divider_1.widthAnchor.constraint(equalToConstant: 1).isActive = true
        divider_1.heightAnchor.constraint(equalToConstant: self.view.frame.height/150).isActive = true
        
        /*
        let findEmail = UIButton()
        findEmail.setTitle("이메일 찾기", for: .normal)
        findEmail.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        findEmail.backgroundColor = .clear
        findEmail.translatesAutoresizingMaskIntoConstraints = false
        findEmail.setTitleColor(.black, for: .normal)
        
        let divider_2 = UILabel()
        divider_2.backgroundColor = colors.lessLightGray
        divider_2.translatesAutoresizingMaskIntoConstraints = false
        divider_2.widthAnchor.constraint(equalToConstant: 1).isActive = true
        divider_2.heightAnchor.constraint(equalToConstant: self.view.frame.height/150).isActive = true*/
        
        let findPassword = UIButton()
        findPassword.setTitle("비밀번호 찾기", for: .normal)
        findPassword.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        findPassword.backgroundColor = .clear
        findPassword.translatesAutoresizingMaskIntoConstraints = false
        findPassword.setTitleColor(.black, for: .normal)
        findPassword.addTarget(self, action: #selector(didTapFindPassword), for: .touchUpInside)
        
        self.helpStack.addArrangedSubviews([signup, divider_1, findPassword])
        self.helpStack.backgroundColor = .clear
        self.helpStack.translatesAutoresizingMaskIntoConstraints = false
        self.helpStack.widthAnchor.constraint(equalToConstant: self.view.frame.width).isActive = true
        self.helpStack.heightAnchor.constraint(equalToConstant: self.view.frame.height/32).isActive = true
        self.helpStack.topAnchor.constraint(equalTo: self.loginButton.bottomAnchor, constant: self.view.frame.height/40).isActive = true
        self.helpStack.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 80).isActive = true
        self.helpStack.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -80).isActive = true
    }
    
    
    @objc func didTapSignup(){
        let signupVC = SignUpViewController()
        signupVC.modalPresentationStyle = .fullScreen
        self.present(signupVC, animated: true)
        //self.present(signupVC, animated: true)
    }
    
    @objc func didTapFindPassword(){
        let findpasswordVC = FindPasswordViewController()
        findpasswordVC.modalPresentationStyle = .fullScreen
        self.present(findpasswordVC, animated: true)
    }
    
    func configureSocialLogin(){
        let Naver_logo = UIImage(named: "Naver_logo")
        let resized_Naver_logo = Naver_logo?.resize(targetSize: CGSize(width: self.view.frame.height/30, height: self.view.frame.height/30))
        //resizeImage(image: Naver_logo!, targetSize: CGSize(width: self.view.frame.height/30, height: self.view.frame.height/30))
        self.naverLoginButton.setImage(resized_Naver_logo, for: .normal)
        self.naverLoginButton.translatesAutoresizingMaskIntoConstraints = false
        self.naverLoginButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20).isActive = true
        self.naverLoginButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20).isActive = true
        self.naverLoginButton.topAnchor.constraint(equalTo: self.helpStack.bottomAnchor, constant: self.view.frame.height/32).isActive = true
        self.naverLoginButton.heightAnchor.constraint(equalToConstant: self.view.frame.height/16).isActive = true
        self.naverLoginButton.setTitle("네이버로 로그인", for: .normal)
        self.naverLoginButton.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        self.naverLoginButton.backgroundColor = .clear
        self.naverLoginButton.layer.borderWidth = 0.5
        self.naverLoginButton.layer.borderColor = UIColor.lightGray.cgColor
        self.naverLoginButton.setTitleColor(.black, for: .normal)
        self.naverLoginButton.layer.cornerRadius = 10
        self.naverLoginButton.clipsToBounds = true
        self.naverLoginButton.addTarget(self, action: #selector(loginWithNaver), for: .touchUpInside)
        
        
        let google_logo = UIImage(named: "Google_logo")
        let resized_Apple_logo = google_logo?.resize(targetSize: CGSize(width: self.view.frame.height/30, height: self.view.frame.height/30))
        self.googleLoginButton.setImage(resized_Apple_logo, for: .normal)
        self.googleLoginButton.translatesAutoresizingMaskIntoConstraints = false
        self.googleLoginButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20).isActive = true
        self.googleLoginButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20).isActive = true
        self.googleLoginButton.topAnchor.constraint(equalTo: self.naverLoginButton.bottomAnchor, constant: self.view.frame.height/64).isActive = true
        self.googleLoginButton.heightAnchor.constraint(equalToConstant: self.view.frame.height/16).isActive = true
        self.googleLoginButton.setTitle("Google로 로그인", for: .normal)
        self.googleLoginButton.configuration?.imagePlacement = .leading
        self.googleLoginButton.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        self.googleLoginButton.backgroundColor = .clear
        self.googleLoginButton.layer.borderWidth = 0.5
        self.googleLoginButton.layer.borderColor = UIColor.lightGray.cgColor
        self.googleLoginButton.setTitleColor(.black, for: .normal)
        self.googleLoginButton.layer.cornerRadius = 10
        self.googleLoginButton.clipsToBounds = true
        
    }
    
    @objc func loginWithNaver(){
        NaverLoginInstance?.delegate = self
        NaverLoginInstance?.requestThirdPartyLogin()
    }
    
    private func getNaverInfo() {
        guard let isValidAccessToken = NaverLoginInstance?.isValidAccessTokenExpireTimeNow() else { return }
        
        if !isValidAccessToken {
          return
        }
        
        guard let tokenType = NaverLoginInstance?.tokenType else { return }
        guard let accessToken = NaverLoginInstance?.accessToken else { return }
        let urlStr = "https://openapi.naver.com/v1/nid/me"
        let url = URL(string: urlStr)!
        //MARK: - 여기서 부턱 다시 Alamofire에 문제가 있는듯하다.
        let authorization = "\(tokenType) \(accessToken)"
        
        //let req = Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: ["Authorization": authorization])
        //let req = Alamofire.URLRequest(url: url, method: .get, headers: ["Authorization": authorization])
        
        /*
        req.responseJSON { response in
          guard let result = response.result.value as? [String: Any] else { return }
          guard let object = result["response"] as? [String: Any] else { return }
          guard let name = object["name"] as? String else { return }
          guard let email = object["email"] as? String else { return }
          guard let nickname = object["nickname"] as? String else { return }
          
          self.nameLabel.text = "\(name)"
          self.emailLabel.text = "\(email)"
          self.nicknameLabel.text = "\(nickname)"
        }*/
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

extension LoginViewController: NaverThirdPartyLoginConnectionDelegate {
  // 로그인 버튼을 눌렀을 경우 열게 될 브라우저
  func oauth20ConnectionDidOpenInAppBrowser(forOAuth request: URLRequest!) {
//     let naverSignInVC = NLoginThirdPartyOAuth20InAppBrowserViewController(request: request)!
//     naverSignInVC.parentOrientation = UIInterfaceOrientation(rawValue: UIDevice.current.orientation.rawValue)!
//     present(naverSignInVC, animated: false, completion: nil)
  }
  
  // 로그인에 성공했을 경우 호출
  func oauth20ConnectionDidFinishRequestACTokenWithAuthCode() {
    print("[Success] : Success Naver Login")
    getNaverInfo()
  }
  
  // 접근 토큰 갱신
  func oauth20ConnectionDidFinishRequestACTokenWithRefreshToken() {
    
  }
  
  // 로그아웃 할 경우 호출(토큰 삭제)
  func oauth20ConnectionDidFinishDeleteToken() {
    NaverLoginInstance?.requestDeleteToken()
  }
  
  // 모든 Error
  func oauth20Connection(_ oauthConnection: NaverThirdPartyLoginConnection!, didFailWithError error: Error!) {
    print("[Error] :", error.localizedDescription)
  }
}
