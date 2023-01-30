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
    
    var selectedItems = [YPMediaItem]()
    
    let bag = DisposeBag()
    
    let userInfoVM : UserInfoViewModel
    let loginVM: LoginViewModel
    let fixedView = UIView()
    let profileImageView = UIImageView()
    let profileNameLabel = UILabel()
    let userNameLabel = UILabel()
    let profileChangeButton = UIButton()
    let divider = UILabel()
    
    //Child VCs
    //구매 데이터를 usecase 로 받도록 나중에 설정할 필요있음.
    private var myShoppingVC = MyShoppingViewController()
    private var myProfileVC = MyProfileViewController()
    
    
    // **************** 임시!! ********************
    let temporaryUserData = TemporaryUserData()
    // **************** 임시!! ********************

    init(userInfoVM : UserInfoViewModel, loginVM: LoginViewModel) {
        self.userInfoVM = userInfoVM
        self.loginVM = loginVM
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated : Bool) {
        self.loginVM.loginState.asObservable().subscribe { status in
            if (status.element! == false){
                (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeToLoginVC()
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpSegmentedControl()
        setUpTabBarButton()
        setUpFixedViewLayout()
        setUpData()
        setupDivider()
        setupChildVC()
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
        let settingsVC = SettingsViewController(viewModel: self.loginVM)
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
            self.profileImageView.leadingAnchor.constraint(equalTo: self.fixedView.leadingAnchor, constant: 10),
            self.profileImageView.widthAnchor.constraint(equalToConstant: profileImageViewWidth),
            self.profileImageView.topAnchor.constraint(equalTo: self.fixedView.topAnchor, constant: 10),
            self.profileImageView.heightAnchor.constraint(equalToConstant: profileImageViewWidth),
        ])
        
        self.profileImageView.layer.cornerRadius = profileImageViewWidth / 2
        self.profileImageView.clipsToBounds = true
    }
    
    func setUpLabelLayout() {
        self.view.addSubview(self.profileNameLabel)

        self.profileNameLabel.font = UIFont.boldSystemFont(ofSize: 16)
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
            self.userNameLabel.heightAnchor.constraint(equalToConstant: 20),
            self.userNameLabel.topAnchor.constraint(equalTo: self.profileImageView.bottomAnchor, constant: 10),
        ])
    }
    
    
    func setUpButtonLayout() {
        self.view.addSubview(self.profileChangeButton)
        
        self.profileChangeButton.setTitle("프로필 관리", for: .normal)
        self.profileChangeButton.titleLabel!.font = .systemFont(ofSize: 14.0, weight: .semibold)
        self.profileChangeButton.setTitleColor(.black, for: .normal)
        self.profileChangeButton.layer.cornerRadius = 7.5
        self.profileChangeButton.layer.borderWidth = 1
        self.profileChangeButton.layer.borderColor = colors.lightGray.cgColor

        self.profileChangeButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.profileChangeButton.leadingAnchor.constraint(equalTo: self.profileNameLabel.leadingAnchor),
            self.profileChangeButton.trailingAnchor.constraint(equalTo: self.fixedView.trailingAnchor, constant: -20),
            self.profileChangeButton.heightAnchor.constraint(equalToConstant: 24),
            self.profileChangeButton.topAnchor.constraint(equalTo: self.profileNameLabel.bottomAnchor, constant: 10),
        ])
        self.profileChangeButton.addTarget(self, action: #selector(profileChangeButtonTapped), for: .touchUpInside)
    }
    
    func setUpData() {
        // 서버에서 받아온 user data를 뷰에 세팅하는 함수.
        // 나중에 Rx로 바꿔야함.
        let url = URL(string: self.temporaryUserData.profileImageUrl)
        self.profileImageView.kf.setImage(with: url)
        self.profileNameLabel.text = temporaryUserData.nickname
        self.userNameLabel.text = self.userInfoVM.User?.parsed_email
    }
    
    func setupDivider(){
        self.view.addSubview(divider)
        self.divider.backgroundColor = colors.lightGray
        self.divider.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.divider.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.divider.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            self.divider.heightAnchor.constraint(equalToConstant: 15),
            self.divider.topAnchor.constraint(equalTo: self.userNameLabel.bottomAnchor, constant: self.view.frame.height/64),

        ])
    }
    
    func setupChildVC(){
        self.add(self.myShoppingVC)
        self.add(self.myProfileVC)
        //TODO: y 값 조정하기
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
        let profileChangeVC = EditProfileViewController(viewModel: self.userInfoVM)
        profileChangeVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(profileChangeVC, animated: true)
    }
}


extension MyTabViewController: YPImagePickerDelegate {
    func imagePickerHasNoItemsInLibrary(_ picker: YPImagePicker) {
        //
    }
    
    func shouldAddToSelection(indexPath: IndexPath, numSelections: Int) -> Bool {
        return true
    }
}

