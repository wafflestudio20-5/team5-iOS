//
//  SignUpViewController.swift
//  KreamWaffleApp
//
//  Created by grace kim  on 2023/01/01.
//

import UIKit
import RxSwift
import RxCocoa

class SignUpViewController: UIViewController, UIViewControllerTransitioningDelegate {
    
    var viewModel : SignUpViewModel
    let bag = DisposeBag()
    
    var backButton = UIButton()
    var titleLabel = UILabel()
    var emailField : CustomTextfield?
    var passwordField : CustomTextfield?
    
    var sizeField : ShoeSizefield?
    var sizeSelected = false
    
    var necessaryTerms : TermsButton?
    var necessaryTermChecked = false
    var additionalTerms : TermsButton?
    
    var signupButton = UIButton()

    
    init(viewModel : SignUpViewModel){
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.emailField = CustomTextfield(titleText: "이메일 주소 *", errorText: "올바른 이메일을 입력해주세요.", errorCondition: .email, placeholderText: nil, defaultButtonImage: "xmark.circle.fill", pressedButtonImage: "xmark.circle.fill")
        self.passwordField = CustomTextfield(titleText: "비밀번호 *", errorText: "영문, 숫자, 특수문자를 조합해서 입력해주세요. (8-16자)", errorCondition: .password, placeholderText: nil, defaultButtonImage: "eye.slash", pressedButtonImage: "eye")
        self.sizeField = ShoeSizefield(selectedSize: nil)
        self.necessaryTerms = TermsButton(title: "[필수] 만 14세 이상이며 모두 동의합니다.", rightButtonImage: "plus", pressedRightButtonImage: "minus")
        self.additionalTerms = TermsButton(title: "[선택] 광고성 정보 수신에 모두 동의합니다.", rightButtonImage: "plus", pressedRightButtonImage: "minus")
        self.emailField?.textfield.becomeFirstResponder()
        bindSignUpFields()
        addSubviews()
        configureSubviews()
        self.hideKeyboardWhenTappedAround()
    }
    
    func bindSignUpFields(){
        self.emailField!.textfield.rx.text
            .orEmpty
            .bind(to: self.viewModel.emailTextRelay)
            .disposed(by: bag)
        
        self.passwordField!.textfield.rx.text
            .orEmpty
            .bind(to: self.viewModel.pwTextRelay)
            .disposed(by: bag)
        
        self.viewModel.shoeSizeRelay.subscribe { size in
            if (size.element != 0){
            self.sizeField?.textfield.text = String(size.element ?? 0)
            }else{
            self.sizeField?.textfield.text = "사이즈를 선택하세요."
            }
        }.disposed(by: bag)
        
        self.viewModel.isValidSignUp()
            .bind(to: self.signupButton.rx.isEnabled)
            .disposed(by: bag)
        
        self.viewModel.isValidSignUp()
            .map { $0 ? UIColor.black: UIColor.lightGray}
            .bind(to: self.signupButton.rx.backgroundColor)
            .disposed(by: bag)
        
        self.viewModel.isValidSignUp()
            .map { $0 ? UIColor.white: UIColor.darkGray}
            .bind(to: self.signupButton.rx.tintColor)
            .disposed(by: bag)
        
        self.signupButton.rx
            .tap
            .bind {
                self.viewModel.didTapSignup()
                self.viewModel.errorRelay
                    .asObservable()
                    .subscribe { error in //TODO: sync 가 안맞음. 수정하기
                    if (error.element == LoginError.signupError ){
                        print("[Log] Signup VC: Error in signup")
                        self.showErrorNotification(errorText: "이메일이나 비밀번호를 확인해주세요.")
                    }else if (error.element == LoginError.alreadySignedUpError){
                        self.showErrorNotification(errorText: "이미 회원가입된 이메일입니다.")
                    }else{
                        self.showEmailSentNotification()
                    }
                }
            }
        
        self.necessaryTerms?.checkButton.rx
            .tap
            .bind { [self] in
                self.necessaryTermChecked = !self.necessaryTermChecked
                self.viewModel.liabilityCheckRelay.accept(necessaryTermChecked)
            }
    }
    
    
    func addSubviews(){
        self.view.addSubview(backButton)
        self.view.addSubview(titleLabel)
        self.view.addSubview(emailField!)
        self.view.addSubview(passwordField!)
        self.view.addSubview(sizeField!)
        self.view.addSubview(necessaryTerms!)
        self.view.addSubview(additionalTerms!)
        self.view.addSubview(signupButton)
    }
    
    func configureSubviews(){
        configureBackandTitle()
        configureTextfields()
        configureShoeSizeField()
        configureTerms()
        configureSignup()
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
        //self.emailField?.textfield.addTarget(self, action: #selector(allFieldValid), for: .allEvents)
        
        self.passwordField?.translatesAutoresizingMaskIntoConstraints = false
        self.passwordField?.topAnchor.constraint(equalTo: self.emailField!.bottomAnchor, constant: 30).isActive = true
        self.passwordField?.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20).isActive = true
        self.passwordField?.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20).isActive = true
        self.passwordField?.heightAnchor.constraint(greaterThanOrEqualToConstant: 50).isActive = true
        //self.passwordField?.textfield.addTarget(self, action: #selector(allFieldValid), for: .allEvents)
    }
    
    func configureShoeSizeField(){
        self.sizeField?.translatesAutoresizingMaskIntoConstraints = false
        self.sizeField?.topAnchor.constraint(equalTo: self.passwordField!.bottomAnchor, constant: 30).isActive = true
        self.sizeField?.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20).isActive = true
        self.sizeField?.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20).isActive = true
        self.sizeField?.heightAnchor.constraint(greaterThanOrEqualToConstant: 50).isActive = true
        self.sizeField?.button.addTarget(self, action: #selector(didTapSelectShoeSize), for: .touchUpInside)
    }
    
    func configureTerms(){
        self.necessaryTerms?.translatesAutoresizingMaskIntoConstraints = false
        self.necessaryTerms?.topAnchor.constraint(equalTo: self.sizeField!.bottomAnchor, constant: 30).isActive = true
        self.necessaryTerms?.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20).isActive = true
        self.necessaryTerms?.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20).isActive = true
        self.necessaryTerms?.heightAnchor.constraint(greaterThanOrEqualToConstant: 30).isActive = true
        //self.necessaryTerms?.checkButton.addTarget(self, action: #selector(allFieldValid), for: .touchUpInside)
        
        self.additionalTerms?.translatesAutoresizingMaskIntoConstraints = false
        self.additionalTerms?.topAnchor.constraint(equalTo: self.necessaryTerms!.bottomAnchor, constant: 15).isActive = true
        self.additionalTerms?.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20).isActive = true
        self.additionalTerms?.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20).isActive = true
        self.additionalTerms?.heightAnchor.constraint(greaterThanOrEqualToConstant: 30).isActive = true
    }
    
    func configureSignup(){
        self.signupButton.translatesAutoresizingMaskIntoConstraints = false
        self.signupButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20).isActive = true
        self.signupButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20).isActive = true
        self.signupButton.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -self.view.frame.height/32).isActive = true
        self.signupButton.heightAnchor.constraint(equalToConstant: self.view.frame.height/16).isActive = true
        self.signupButton.setTitle("가입하기", for: .normal)
        self.signupButton.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .light)
        self.signupButton.backgroundColor = colors.lessLightGray
        self.signupButton.titleLabel?.textColor = .white
        self.signupButton.layer.cornerRadius = 10
        self.signupButton.clipsToBounds = true
    }
    
    func showErrorNotification(errorText: String){
        let errorNotification = CustomNotificationView(notificationText: errorText)
        self.view.addSubview(errorNotification)
        errorNotification.translatesAutoresizingMaskIntoConstraints = false
        errorNotification.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 15).isActive = true
        errorNotification.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -15).isActive = true
        errorNotification.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: self.view.frame.height/64).isActive = true
        errorNotification.heightAnchor.constraint(greaterThanOrEqualToConstant: self.view.frame.height/16).isActive = true
        let seconds = 2.5
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds) { [self] in
            UIView.animate(withDuration: 1.0, delay: 0.0, options: UIView.AnimationOptions.curveEaseIn, animations: {
                errorNotification.alpha = 0.0
                }) { _ in
                errorNotification.removeFromSuperview()
                }
        }
    }
    
    func showEmailSentNotification(){
        let loadingVC = LoadingViewController()

        // Animate loadingVC over the existing views on screen
        loadingVC.modalPresentationStyle = .overCurrentContext

        // Animate loadingVC with a fade in animation
        loadingVC.modalTransitionStyle = .crossDissolve
            
        loadingVC.setUpNotification(notificationText: "이메일로 인증링크가 발송되었습니다.")
        self.present(loadingVC, animated: true, completion: nil)
            
        let seconds = 2.0
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds) { [self] in
            loadingVC.dismiss(animated: true)
            self.dismiss(animated: true)
        }
    }
    
    @objc func didTapSelectShoeSize(){
        let vc = ShoeSizeSelectionViewController(viewModel: self.viewModel, loginVM: nil)
        //vc.view.backgroundColor = .systemYellow
        vc.modalPresentationStyle = .pageSheet
        if let sheet = vc.sheetPresentationController {
            //지원할 크기 지정
            sheet.detents = [.medium()]
            //크기 변하는거 감지
            sheet.delegate = self
                   
            //시트 상단에 그래버 표시 (기본 값은 false)
            sheet.prefersGrabberVisible = true
                    
            //처음 크기 지정 (기본 값은 가장 작은 크기)
            //sheet.selectedDetentIdentifier = .large
                    
            //뒤 배경 흐리게 제거 (기본 값은 모든 크기에서 배경 흐리게 됨)
            //sheet.largestUndimmedDetentIdentifier = .medium
        }
        
        self.present(vc, animated: true, completion: nil)
        
    }
}

extension SignUpViewController: UISheetPresentationControllerDelegate {
    func sheetPresentationControllerDidChangeSelectedDetentIdentifier(_ sheetPresentationController: UISheetPresentationController) {
        //크기 변경 됐을 경우
        print(sheetPresentationController.selectedDetentIdentifier == .large ? "large" : "medium")
    }
}
