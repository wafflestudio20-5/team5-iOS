//
//  SubEditProfileViewController.swift
//  KreamWaffleApp
//
//  Created by grace kim  on 2023/01/29.
//

import UIKit
import RxSwift

enum editCase {
    case profileName
    case userName
    case introduction
    
    case password
    case email
    case shoeSize
}

class SubEditProfileViewController: UIViewController, UINavigationBarDelegate {
    
    let bag = DisposeBag()
    
    var myProfile : Profile?
    var user : User?
    var editCase : editCase
    
    var navBarTitle : String?
    var detail: String?
    var textfieldTitle: String?
    var currentText : String?
    
    var detailLabel = UILabel()
    var textfieldTitleLabel = UILabel()
    var textfield : CustomTextfield?
    var line = UILabel()
    var saveButton = UIButton()
    
    var viewModel : EditAccountViewModel?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        mapData()
        addNavigationBar()
        setupSubviews()
        if (self.editCase == .password){
            self.bindForPasswordSetting()
        }
    }
    
    private func addNavigationBar() {
        let height: CGFloat = 75
        var statusBarHeight: CGFloat = 0
        if #available(iOS 13.0, *) {
            statusBarHeight = view.window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
        } else {
            statusBarHeight = UIApplication.shared.statusBarFrame.height
        }
        let navbar = UINavigationBar(frame: CGRect(x: 0, y: statusBarHeight, width: UIScreen.main.bounds.width, height: height))
        view.addSubview(navbar)
        navbar.backgroundColor = UIColor.white
        navbar.delegate = self as UINavigationBarDelegate

        let navItem = UINavigationItem()
        navItem.title = self.navBarTitle ?? "수정"
        navItem.rightBarButtonItem = UIBarButtonItem(title: "취소", style: .plain, target: self, action: #selector(tappedCancel))

        navbar.items = [navItem]
        self.view?.frame = CGRect(x: 0, y: height, width: UIScreen.main.bounds.width, height: (UIScreen.main.bounds.height - height))
    }
    
    @objc
    func tappedCancel(){
        self.dismiss(animated: true)
    }
    
    func mapData(){
        switch (self.editCase){
        case .profileName:
            self.navBarTitle = "프로필 이름 변경"
            self.detail = "나만의 프로필 이름으로 변경하세요. 변경 후 30일이 지나야 다시 변경 가능하므로 신중히 변경해주세요."
            self.currentText = self.myProfile?.profile_name
            self.textfield = CustomTextfield(titleText: "프로필 이름", errorText: "영문, 숫자, 특수기호(_ .)만 사용 가능합니다.", errorCondition: .profileName, placeholderText: "", defaultButtonImage: nil, pressedButtonImage: nil)
            self.textfield?.setupTextCounter(maxCount: 25)
        case .userName:
            self.navBarTitle = "이름 변경"
            self.detail = nil
            self.textfield = CustomTextfield(titleText: "이름", errorText: "", errorCondition: .none, placeholderText: "이름 또는 별명", defaultButtonImage: nil, pressedButtonImage: nil)
            self.textfield?.setupTextCounter(maxCount: 25)
            self.currentText = self.myProfile?.user_name
        case .introduction:
            self.navBarTitle = "소개 변경"
            self.detail = nil
            self.textfield = CustomTextfield(titleText: "소개", errorText: "", errorCondition: .none, placeholderText: nil, defaultButtonImage: nil, pressedButtonImage: nil)
            self.textfield?.setupTextCounter(maxCount: 100)
            self.currentText = self.myProfile?.introduction
        case .password:
            self.navBarTitle = "비밀번호 변경"
            self.detail = "비밀번호를 변경해주세요."
            self.currentText = nil
            self.textfield = CustomTextfield(titleText: "비밀번호", errorText: "영문, 숫자, 특수기호(_ .)만 사용 가능합니다.", errorCondition: .password, placeholderText: "", defaultButtonImage: nil, pressedButtonImage: nil)
            self.textfield?.setupTextCounter(maxCount: 25)
        case .email:
            let five = 5
        case .shoeSize:
            let five = 5
        }
    }
    
    init(myProfile: Profile?, editCase: editCase, user: User?, viewModel: EditAccountViewModel?){
        self.myProfile = myProfile
        self.user = user
        self.editCase = editCase
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    func setupSubviews(){
        self.title = self.navBarTitle
        self.view.addSubview(detailLabel)
        self.view.addSubview(textfield!)
        self.view.addSubview(saveButton)
       

        self.detailLabel.text = self.detail
        self.detailLabel.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        self.detailLabel.textColor = .darkGray
        self.detailLabel.lineBreakMode = .byWordWrapping
        self.detailLabel.numberOfLines = 0
        self.detailLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.detailLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 10),
            self.detailLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -10),
            self.detailLabel.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 80)
        ])
        
        
        self.textfield?.textfield.text = self.currentText
        self.textfield?.translatesAutoresizingMaskIntoConstraints = false
        self.textfield?.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20).isActive = true
        self.textfield?.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20).isActive = true
        self.textfield?.topAnchor.constraint(equalTo: self.detailLabel.bottomAnchor, constant: 20).isActive = true
        self.textfield?.heightAnchor.constraint(greaterThanOrEqualToConstant: 50).isActive = true
        
        self.saveButton.setTitle("저장하기", for: .normal)
        self.saveButton.translatesAutoresizingMaskIntoConstraints = false
        self.saveButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20).isActive = true
        self.saveButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20).isActive = true
        self.saveButton.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -self.view.frame.height/32).isActive = true
        self.saveButton.heightAnchor.constraint(equalToConstant: self.view.frame.height/16).isActive = true
        self.saveButton.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .light)
        self.saveButton.backgroundColor = colors.lessLightGray
        self.saveButton.titleLabel?.textColor = .white
        self.saveButton.layer.cornerRadius = 10
        self.saveButton.clipsToBounds = true
    }

    //MARK: - only for profile settings
    func bind(){
        self.textfield?.textfield.rx.text
            .orEmpty
            .distinctUntilChanged()
            .subscribe(onNext: { changedText in
                self.textfield?.editTextCounter(text: changedText)
            })
            .disposed(by: bag)
        
        self.textfield?.textfield.rx.text
            .orEmpty
            .distinctUntilChanged()
            .map{ $0 == self.currentText ? UIColor.lightGray :UIColor.black }
            .bind(to: self.saveButton.rx.backgroundColor)
            .disposed(by: bag)
        
        self.textfield?.textfield.rx.text
            .orEmpty
            .distinctUntilChanged()
            .map{ $0 != self.currentText }
            .bind(to: self.saveButton.rx.isEnabled)
            .disposed(by: bag)
    }
    
    //MARK: - only for user settings
    func bindForPasswordSetting() {
        
        self.textfield?.textfield.rx.text
            .orEmpty
            .distinctUntilChanged()
            .subscribe(onNext: { changedText in
                self.textfield?.editTextCounter(text: changedText)
                self.viewModel?.pwTextRelay.accept(changedText)
            })
            .disposed(by: bag)
        
        self.textfield?.textfield.rx.text
            .orEmpty
            .bind(to: self.viewModel!.pwTextRelay)
            .disposed(by: bag)
        
        self.viewModel?.isValidPasswordRelay()
            .map { $0 ? UIColor.black: UIColor.lightGray}
            .bind(to: self.saveButton.rx.backgroundColor)
            .disposed(by: bag)
        
        self.viewModel?.isValidPasswordRelay()
            .map { $0 ? UIColor.white: UIColor.darkGray}
            .bind(to: self.saveButton.rx.tintColor)
            .disposed(by: bag)
        
        self.viewModel?.isValidPasswordRelay()
            .bind(to: self.saveButton.rx.isEnabled)
            .disposed(by: bag)
        
        self.saveButton.rx
            .tap
            .bind {
                self.viewModel?.changePassword()
                
                //TODO: 에러처리해주기
                self.showActionCompleteNotification()
                
                /*
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
                }*/
            }
    }
    
    func showErrorNotification(errorText: String){
        let errorNotification = CustomNotificationView(notificationText: errorText)
        self.view.addSubview(errorNotification)
        errorNotification.translatesAutoresizingMaskIntoConstraints = false
        errorNotification.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 15).isActive = true
        errorNotification.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -15).isActive = true
        errorNotification.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: self.view.frame.height/64).isActive = true
        errorNotification.heightAnchor.constraint(greaterThanOrEqualToConstant: self.view.frame.height/16).isActive = true
        let seconds = 2.0
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds) { [self] in
            UIView.animate(withDuration: 1.0, delay: 0.0, options: UIView.AnimationOptions.curveEaseIn, animations: {
                errorNotification.alpha = 0.0
                }) { _ in
                errorNotification.removeFromSuperview()
                }
        }
    }
    
    func showActionCompleteNotification(){
        let loadingVC = LoadingViewController()
        loadingVC.modalPresentationStyle = .overCurrentContext
        loadingVC.modalTransitionStyle = .crossDissolve
        loadingVC.setUpNotification(notificationText: "비밀변호가 변경되었습니다.")
        self.present(loadingVC, animated: true, completion: nil)
        let seconds = 2.0
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds) { [self] in
            loadingVC.dismiss(animated: true)
            self.dismiss(animated: true)
        }
    }
    
    
    

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
