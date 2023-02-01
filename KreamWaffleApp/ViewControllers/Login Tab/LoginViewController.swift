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
import GoogleSignIn
import RxSwift
import RxRelay

class LoginViewController: UIViewController {
    
    var viewModel : LoginViewModel
    var loginState = false
    let bag = DisposeBag()
    
    let NaverLoginInstance = NaverThirdPartyLoginConnection.getSharedInstance()
    
    private var exitButton = UIButton()
    private var logoImage = UIImageView()
    
    //email field
    private var emailfield : CustomTextfield?
    private var emailValid = false
    
    //password field
    private var passwordfield: CustomTextfield?
    private var passwordValid = false
    
    //login field
    private var loginButton = UIButton()
    private var helpStack = UIStackView()
    
    //social login field
    private var naverLoginButton = UIButton()
    private var googleLoginButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.NaverLoginInstance!.delegate = self
        
        self.viewModel.loginState.asObservable().subscribe { status in
            self.loginState = status.element!
            print("[Log] Login VC: The login state is", status.element)
            if (status.element! == true){
                (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeToTabVC()
            }
        }.disposed(by: bag)
        
        //for google login
        GIDSignIn.sharedInstance()?.presentingViewController = self // 로그인화면 불러오기
        //GIDSignIn.sharedInstance()?.restorePreviousSignIn() // 자동로그인
        GIDSignIn.sharedInstance()?.delegate = self
        
        self.view.backgroundColor = .white
        emailfield = CustomTextfield(titleText: "이메일 주소", errorText: "올바른 이메일을 입력해주세요.", errorCondition: .email, placeholderText: "예) kream@kream.co.kr", defaultButtonImage: "xmark.circle.fill", pressedButtonImage: "xmark.circle.fill")
        passwordfield = CustomTextfield(titleText: "비밀번호", errorText: "영문, 숫자, 특수문자를 조합해서 입력해주세요. (8-16자)", errorCondition: .password, placeholderText: "", defaultButtonImage: "eye.slash", pressedButtonImage: "eye")
        
        addSubviews()
        configureSubviews()
        bindLoginButton()
        self.hideKeyboardWhenTappedAround()
    }
    
    init(viewModel : LoginViewModel){
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
    
    
    @objc func popVC(){
        //TODO: set differently according to login state in VM --> 일단은 노티로.
        //이게 아니라 root vc를 갈아끼워야하는 것 같음.
        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeToTabVC()
    }
    
    //changes activation of login button
    func bindLoginButton(){
        self.viewModel.bindTextfield(textfield: self.emailfield!.textfield, LoginTextfieldType: .Email)
        self.viewModel.bindTextfield(textfield: self.passwordfield!.textfield, LoginTextfieldType: .Password)
        
        self.viewModel.isValid()
            .bind(to: self.loginButton.rx.isEnabled)
            .disposed(by: bag)
        self.viewModel.isValid()
            .map { $0 ? UIColor.black: UIColor.lightGray}
            .bind(to: self.loginButton.rx.backgroundColor)
            .disposed(by: bag)
        self.viewModel.isValid()
            .map { $0 ? UIColor.white: UIColor.darkGray}
            .bind(to: self.loginButton.rx.tintColor)
            .disposed(by: bag)
    }
    
    @objc func didTapLogin(){
        self.viewModel.loginUserWithCustom()
        //TODO: error도 observe 해서 눌렀는데 에러면 에러 화면 뜨게 끔하기.
    }
    
    private func loginFailure(failureMessage: String){
        let loadingVC = LoadingViewController()

        // Animate loadingVC over the existing views on screen
        loadingVC.modalPresentationStyle = .overCurrentContext

        // Animate loadingVC with a fade in animation
        loadingVC.modalTransitionStyle = .crossDissolve
        
        loadingVC.setUpNotification(notificationText: failureMessage)
        self.present(loadingVC, animated: true, completion: nil)
        
        let seconds = 2.0
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
            loadingVC.dismiss(animated: true)
    }
    }
    
    @objc func didTapSignup(){
        let signUpVM = SignUpViewModel(usecase: self.viewModel.UserUseCase)
        let signupVC = SignUpViewController(viewModel: signUpVM)
        signupVC.modalPresentationStyle = .fullScreen
        self.present(signupVC, animated: true)
    }
    
    @objc func didTapFindPassword(){
        let signUpVM = SignUpViewModel(usecase: self.viewModel.UserUseCase)
        let findpasswordVC = FindPasswordViewController(viewModel: signUpVM)
        findpasswordVC.modalPresentationStyle = .fullScreen
        self.present(findpasswordVC, animated: true)
    }
    
    @objc func loginWithGoogle(){
        //TODO: 에러처리하기
        GIDSignIn.sharedInstance()?.signIn()
    }
    
    @objc func loginWithNaver(){
        self.NaverLoginInstance!.requestThirdPartyLogin()
    }
    
    @objc func loginSuccess(){
        if (self.loginState){
            print("login success")
            self.dismiss(animated: true)
        }else{
            loginFailure(failureMessage: "이메일이나 비밀번호를 확인해주세요.")
            print("login failure")
        }
    }
    
    private func getNaverInfo() {
        guard let isValidAccessToken = NaverLoginInstance?.isValidAccessTokenExpireTimeNow() else { return }
        
        if !isValidAccessToken {
          return
        }
        
        guard let accessToken = NaverLoginInstance?.accessToken else { return }
        
        print(accessToken, "is the access token")
        self.viewModel.loginUserWithSocial(token: accessToken, socialType: .Naver)
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
}

extension LoginViewController: NaverThirdPartyLoginConnectionDelegate {
  // 로그인 버튼을 눌렀을 경우 열게 될 브라우저
  func oauth20ConnectionDidOpenInAppBrowser(forOAuth request: URLRequest!) {
    //let naverSignInVC = NLoginThirdPartyOAuth20InAppBrowserViewController(request: request)!
   // naverSignInVC.parentOrientation = UIInterfaceOrientation(rawValue: UIDevice.current.orientation.rawValue)!
   // present(naverSignInVC, animated: false, completion: nil)
  }
  
  // 로그인에 성공했을 경우 호출
  func oauth20ConnectionDidFinishRequestACTokenWithAuthCode() {
    print("[Success] : Success Naver Login")
    getNaverInfo()
  }
  
  // 접근 토큰 갱신
  func oauth20ConnectionDidFinishRequestACTokenWithRefreshToken() {
      NaverLoginInstance?.accessToken
  }
  
  // 로그아웃 할 경우 호출(토큰 삭제)
  func oauth20ConnectionDidFinishDeleteToken() {
    NaverLoginInstance?.requestDeleteToken()
  }
  
  // 모든 Error
  func oauth20Connection(_ oauthConnection: NaverThirdPartyLoginConnection!, didFailWithError error: Error!) {
    print("[Error] :", error)
  }
}

extension LoginViewController: GIDSignInDelegate {
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
               if (error as NSError).code == GIDSignInErrorCode.hasNoAuthInKeychain.rawValue {
                   print("[Log] LoginVC: The user has not signed in before or they have since signed out.")
               } else {
                   print("[Log] LoginVC: Google login error is \(error)")
               }
               return
           }
               
           // 사용자 정보 가져오기
        if let accessToken = GIDSignIn.sharedInstance().currentUser.authentication.accessToken {
            self.viewModel.loginUserWithSocial(token: accessToken, socialType: .Google)
            print("[Log] LoginVC: Access token to Google login is ", accessToken)
        }
    }
}

//MARK: *********** DESIGN RELATED PROPERTIES ***************************
extension LoginViewController {
    
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
        self.loginButton.addTarget(self, action: #selector(didTapLogin), for: .touchUpInside)
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
        divider_2.heightAnchor.constraint(equalToConstant: self.view.frame.height/150).isActive = tru/
        
        let findPassword = UIButton()
        findPassword.setTitle("비밀번호 찾기", for: .normal)
        findPassword.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        findPassword.backgroundColor = .clear
        findPassword.translatesAutoresizingMaskIntoConstraints = false
        findPassword.setTitleColor(.black, for: .normal)
        findPassword.addTarget(self, action: #selector(didTapFindPassword), for: .touchUpInside)*/
        
        self.helpStack.addArrangedSubviews([signup])
        self.helpStack.backgroundColor = .clear
        self.helpStack.translatesAutoresizingMaskIntoConstraints = false
        self.helpStack.widthAnchor.constraint(equalToConstant: self.view.frame.width).isActive = true
        self.helpStack.heightAnchor.constraint(equalToConstant: self.view.frame.height/32).isActive = true
        self.helpStack.topAnchor.constraint(equalTo: self.loginButton.bottomAnchor, constant: self.view.frame.height/50).isActive = true
        self.helpStack.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 80).isActive = true
        self.helpStack.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -80).isActive = true
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
        self.googleLoginButton.addTarget(self, action: #selector(loginWithGoogle), for: .touchUpInside)
        
    }
    
    
    
}
