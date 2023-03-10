//
//  MyTabViewController.swift
//  KreamWaffleApp
//
//  Created by 이선재 on 2022/12/25.
//
import UIKit
import BetterSegmentedControl
import Kingfisher
import RxSwift
import AVFoundation
import AVKit
import Photos
import YPImagePicker
import PhotosUI

struct TemporaryUserData {
    let profileImageUrl = "https://upload.wikimedia.org/wikipedia/commons/thumb/5/5b/Waffles_with_Strawberries.jpg/440px-Waffles_with_Strawberries.jpg"
    let id = "kream_waffle"
    let nickname = "크림맛와플"
}

class MyTabViewController: UIViewController, UITabBarControllerDelegate {
    let disposeBag = DisposeBag()
    
    let userInfoVM : UserInfoViewModel
    let loginVM: LoginViewModel
    let userProfileVM: UserProfileViewModel
    let fixedView = UIView()
    let profileImageView = UIImageView()
    let profileNameLabel = UILabel()
    let userNameLabel = UILabel()
    let bioLabel = UILabel()
    let profileChangeButton = UIButton()
    let divider = UILabel()
    
    //Child VCs
    //구매 데이터를 usecase 로 받도록 나중에 설정할 필요있음.
    private var myShoppingVC: MyShoppingViewController
    private var myProfileVC: MyProfileViewController
    

    init(userInfoVM : UserInfoViewModel, loginVM: LoginViewModel, userProfileVM: UserProfileViewModel) {
        self.userInfoVM = userInfoVM
        self.loginVM = loginVM
        self.userProfileVM = userProfileVM
        self.myShoppingVC = MyShoppingViewController(userInfoVM: self.userInfoVM)
        self.myProfileVC = MyProfileViewController(userInfoVM: self.userInfoVM, userProfileVM: self.userProfileVM)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewWillAppear(_ animated : Bool) {
        self.loginVM.loginState.asObservable().subscribe(onNext: { status in
            if (!status){
                (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeToLoginVC()
                print("[Log] My Tab: Changing to Login VC")
            }else{
                //로그인 된 상태라면 뿌려줄 user profile 요청하기
                self.userProfileVM.requestUserProfile {
                    print("Profile Loading 실패")
                }
    }
        }).disposed(by: disposeBag)
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        setUpBackButton()
        setUpSegmentedControl()
        setUpTabBarButton()
        setUpFixedViewLayout()
        setupDivider()
        setupChildVC()
        bindViews()
    }
    
    func setUpTabBarButton(){
        let cameraImage = UIImage(systemName: "camera.circle.fill")
        let tintedCameraImage = cameraImage?.withRenderingMode(.alwaysTemplate)
        let cameraButton = UIBarButtonItem(title: "", style: .plain, target: self, action: #selector(cameraButtonTapped))
        cameraButton.image = tintedCameraImage
        cameraButton.tintColor = .darkGray
        self.navigationItem.rightBarButtonItem = cameraButton
        
        let gearImage = UIImage(systemName: "gearshape")
        let tintedGearImage = gearImage?.withRenderingMode(.alwaysTemplate)
        let gearButton = UIBarButtonItem(title: "", style: .plain, target: self, action: #selector(settingButtonTapped))
        gearButton.image = tintedGearImage
        gearButton.tintColor = .darkGray
        self.navigationItem.leftBarButtonItem = gearButton
    }
    
    @objc func settingButtonTapped(){
        let viewModel = EditAccountViewModel(usecase: self.loginVM.UserUseCase)
        let settingsVC = SettingsViewController(viewModel: viewModel)
        settingsVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(settingsVC, animated: true)
    }
                                           
    @objc func cameraButtonTapped(){
        print("📮 글 작성 버튼 TAP")
        if (self.userInfoVM.isLoggedIn()) {
            pushNewPostVC(userInfoViewModel: self.userInfoVM)
        } else {
            let loginScreen: LoginViewController! = (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.loginVC

            loginScreen.modalPresentationStyle = .fullScreen
            self.present(loginScreen, animated: false)
        }
    }
                                           
    func setUpSegmentedControl() {
        let segmentedControl = BetterSegmentedControl(
            frame: CGRect(x: 0, y: 0, width: view.bounds.width/2 - 32.0, height: 30),
            segments: LabelSegment.segments(withTitles: ["내 쇼핑", "내 프로필"],
                                            normalFont: .boldSystemFont(ofSize: 17.0),
                                            normalTextColor: .lightGray,
                                            selectedFont: .boldSystemFont(ofSize: 17.0),
                                            selectedTextColor: .black
                                           ),
            options: [.backgroundColor(.white),
                      .indicatorViewBackgroundColor(.white),
                      .cornerRadius(3.0),
                      .animationSpringDamping(1.0)]
        )

        segmentedControl.addTarget(
            self,
            action: #selector(navigationSegmentedControlValueChanged(_:)),
            for: .valueChanged)

        segmentedControl.sizeToFit()
        navigationItem.titleView = segmentedControl
    }
    
    func setUpCameraButton(){
        let cameraImage = UIImage(systemName: "camera.circle.fill")
        let tintedCameraImage = cameraImage?.withRenderingMode(.alwaysTemplate)
        let cameraButton = UIBarButtonItem(title: "", style: .plain, target: self, action: #selector(cameraButtonTapped))
        cameraButton.image = tintedCameraImage
        cameraButton.tintColor = .darkGray
        self.navigationItem.rightBarButtonItem = cameraButton
    }
    
    func setUpFixedViewLayout() {
        self.fixedView.backgroundColor = .white
        self.view.addSubview(self.fixedView)

        self.fixedView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.fixedView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 0),
            self.fixedView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: 0),
            self.fixedView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            self.fixedView.heightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.heightAnchor, multiplier: 0.25),
        ])
        
        setUpImageViewLayout()
        setUpLabelLayout()
        setUpButtonLayout()
    }
    
    func setUpImageViewLayout() {
        self.view.addSubview(self.profileImageView)
        self.profileImageView.contentMode = .scaleAspectFill
        
        let profileImageViewWidth = CGFloat(100)

        self.profileImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.profileImageView.leadingAnchor.constraint(equalTo: self.fixedView.leadingAnchor, constant: 20),
            self.profileImageView.widthAnchor.constraint(equalToConstant: profileImageViewWidth),
            self.profileImageView.topAnchor.constraint(equalTo: self.fixedView.topAnchor, constant: 10),
            self.profileImageView.heightAnchor.constraint(equalToConstant: profileImageViewWidth),
        ])
        
        self.profileImageView.layer.cornerRadius = profileImageViewWidth / 2
        self.profileImageView.clipsToBounds = true
    }
    
    func setUpLabelLayout() {
        self.view.addSubview(self.profileNameLabel)

        self.profileNameLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        self.profileNameLabel.textColor = .black
        self.profileNameLabel.lineBreakMode = .byTruncatingTail
        self.profileNameLabel.numberOfLines = 1
        self.profileNameLabel.textAlignment = .left
        self.profileNameLabel.adjustsFontSizeToFitWidth = false
        
        self.profileNameLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.profileNameLabel.leadingAnchor.constraint(equalTo: self.profileImageView.trailingAnchor, constant: 20),
            self.profileNameLabel.trailingAnchor.constraint(equalTo: self.fixedView.trailingAnchor),
            self.profileNameLabel.heightAnchor.constraint(equalToConstant: 20),
            self.profileNameLabel.centerYAnchor.constraint(equalTo: self.fixedView.centerYAnchor, constant: -40),
        ])
        
        self.view.addSubview(self.userNameLabel)

        self.userNameLabel.font = UIFont.boldSystemFont(ofSize: 14)
        self.userNameLabel.textColor = .black
        self.userNameLabel.lineBreakMode = .byTruncatingTail
        self.userNameLabel.numberOfLines = 1
        self.userNameLabel.textAlignment = .left
        self.userNameLabel.adjustsFontSizeToFitWidth = false
        
        self.userNameLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.userNameLabel.leadingAnchor.constraint(equalTo: self.profileImageView.leadingAnchor),
            self.userNameLabel.trailingAnchor.constraint(equalTo: self.fixedView.trailingAnchor),
            self.userNameLabel.topAnchor.constraint(equalTo: self.profileImageView.bottomAnchor, constant: 5)
        ])
        
        self.view.addSubview(self.bioLabel)
        
        self.bioLabel.font = UIFont.systemFont(ofSize: 14, weight: .light)
        self.bioLabel.textColor = .black
        self.bioLabel.lineBreakMode = .byTruncatingTail
        self.bioLabel.numberOfLines = 1
        self.bioLabel.textAlignment = .left
        self.bioLabel.adjustsFontSizeToFitWidth = false
        
        self.bioLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.bioLabel.leadingAnchor.constraint(equalTo: self.profileImageView.leadingAnchor),
            self.bioLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20),
            self.bioLabel.topAnchor.constraint(equalTo: self.userNameLabel.bottomAnchor, constant: 5)
        ])
    }
    
    
    func setUpButtonLayout() {
        self.view.addSubview(self.profileChangeButton)
        
        self.profileChangeButton.setTitle("프로필 관리", for: .normal)
        self.profileChangeButton.titleLabel!.font = .systemFont(ofSize: 14.0, weight: .semibold)
        self.profileChangeButton.setTitleColor(.black, for: .normal)
        self.profileChangeButton.layer.cornerRadius = 7.5
        self.profileChangeButton.layer.borderWidth = 1
        self.profileChangeButton.layer.borderColor = colors.lessLightGray.cgColor

        self.profileChangeButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.profileChangeButton.leadingAnchor.constraint(equalTo: self.profileNameLabel.leadingAnchor),
            self.profileChangeButton.trailingAnchor.constraint(equalTo: self.fixedView.trailingAnchor, constant: -20),
            self.profileChangeButton.heightAnchor.constraint(equalToConstant: 24),
            self.profileChangeButton.topAnchor.constraint(equalTo: self.profileNameLabel.bottomAnchor, constant: 10),
        ])
        self.profileChangeButton.addTarget(self, action: #selector(profileChangeButtonTapped), for: .touchUpInside)
    }
    
    func bindViews() {
        //이미지 릴레이에서 이미지 새로 받으면 이걸로 세팅
        /*
        self.userProfileVM.imageRelay.subscribe(onNext: { [weak self] _ in
            if let image = UserDefaults.standard.loadProfileImage() {
                print("[Log] My tab: 캐시에서 이미지 불러욤.")
                self?.profileImageView.image = image
            }
        }).disposed(by: disposeBag)*/
        
        self.userProfileVM.userProfileDataSource.subscribe(onNext: { [weak self] profile in
            self?.setUpData(with: profile)
        }).disposed(by: disposeBag)
        
        //binding current value label to newest
        self.userProfileVM.tapRelay.asObservable()
            .subscribe{ [self] editCase in
                switch (editCase.element){
                case .profileName:
                    self.profileNameLabel.text = userProfileVM.profileNameRelay.value
                case .userName:
                    self.userNameLabel.text = userProfileVM.userNameRelay.value
                case .introduction:
                    self.bioLabel.text = userProfileVM.bioRelay.value
                default:
                    print("")
                }
        }.disposed(by: disposeBag)
    }
    
    func setUpData(with profile: Profile) {
        //프로필 이미지가 있다면 설정
        //이거 왜 그럴까? 아무튼 changedProfile 구독해서 만약 changed했다면 캐시에서 불러오도록하기 
        if let url = URL.init(string: profile.image) {
            let resource = ImageResource(downloadURL: url)
            KingfisherManager.shared.retrieveImage(with: resource, options: nil, progressBlock: nil) { result in
                switch result {
                case .success(let value):
                    self.profileImageView.image = value.image
                case .failure(_):
                    if let image = UserDefaults.standard.loadProfileImage() {
                        print("[Log] My tab: 캐시에서 이미지 불러욤.")
                        self.profileImageView.image = image
                    }else{
                        //캐시도 없다면 기본으로 설정
                        self.profileImageView.image = UIImage(systemName: "person.crop.circle.fill")?.withRenderingMode(.alwaysTemplate)
                        //그게 아니라면 여기서 난 문제
                        self.profileImageView.tintColor = .orange
                    }
                }
            }
        }else{
            if let image = UserDefaults.standard.loadProfileImage() {
                print("[Log] My tab: 캐시에서 이미지 불러욤.")
                self.profileImageView.image = image
            }else{
                //캐시도 없다면 기본으로 설정
                self.profileImageView.image = UIImage(systemName: "person.crop.circle.fill")?.withRenderingMode(.alwaysTemplate)
                //그게 아니라면 여기서 난 문제
                self.profileImageView.tintColor = .orange
            }
        }
        
        self.profileNameLabel.text = profile.profile_name
        self.userNameLabel.text = profile.user_name
        self.bioLabel.text = profile.introduction
    }
    
    func setupDivider(){
        self.view.addSubview(divider)
        self.divider.backgroundColor = colors.lightGray
        self.divider.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.divider.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.divider.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            self.divider.heightAnchor.constraint(equalToConstant: 15),
            self.divider.topAnchor.constraint(equalTo: self.bioLabel.bottomAnchor, constant: self.view.frame.height/64),

        ])
    }
    
    func setupChildVC(){
        self.add(self.myShoppingVC)
        self.add(self.myProfileVC)
        self.myShoppingVC.view.frame = CGRect(x: 0, y: 270, width: self.view.frame.width, height: self.view.frame.height)
        self.myProfileVC.view.frame = CGRect(x: 0, y: 270, width: self.view.frame.width, height: self.view.frame.height)
        self.myProfileVC.view.isHidden = true
    }
    
    @objc func navigationSegmentedControlValueChanged(_ sender: BetterSegmentedControl) {
        //***** !! To 은혜님 !! ******
        // 여기서 어떤 뷰컨 숨기고 어떤 뷰컨 드러낼지 설정하시면 됩니다!
        //넹
        if sender.index == 0 {
            //print("Turning lights on.")
            //view.backgroundColor = .white
            self.myShoppingVC.view.isHidden = false
            self.myProfileVC.view.isHidden = true
        } else {
            //print("Turning lights off.")
            //view.backgroundColor = .darkGray
            self.myShoppingVC.view.isHidden = true
            self.myProfileVC.view.isHidden = false
        }
    }
    
    @objc
    func profileChangeButtonTapped() {
        let profileChangeVC = EditProfileViewController(viewModel: self.userProfileVM)
        profileChangeVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(profileChangeVC, animated: true)
    }
}
