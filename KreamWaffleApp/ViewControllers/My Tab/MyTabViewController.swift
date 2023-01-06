//
//  MyTabViewController.swift
//  KreamWaffleApp
//
//  Created by 이선재 on 2022/12/25.
//
import UIKit
import BetterSegmentedControl
import Kingfisher

struct TemporaryUserData {
    let profileImageUrl = "https://upload.wikimedia.org/wikipedia/commons/thumb/5/5b/Waffles_with_Strawberries.jpg/440px-Waffles_with_Strawberries.jpg"
    let id = "kream_waffle"
    let nickname = "크림맛와플"
}


class MyTabViewController: UIViewController {
    let fixedView = UIView()
    let profileImageView = UIImageView()
    let nicknameLabel = UILabel()
    let idLabel = UILabel()
    let profileChangeButton = UIButton()
    
    
    // **************** 임시!! ********************
    let temporaryUserData = TemporaryUserData()
    // **************** 임시!! ********************

    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        //shoeScreen.modalPresentationStyle = .fullScreen
        let loginScreen = LoginViewController()
        let profile = ProfileViewController()
        loginScreen.modalPresentationStyle = .fullScreen
        self.present(loginScreen, animated: false)
        
        setUpSegmentedControl()
        setUpFixedViewLayout()
        setUpData()
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
        self.view.addSubview(self.nicknameLabel)

        self.nicknameLabel.font = UIFont.boldSystemFont(ofSize: 16)
        self.nicknameLabel.textColor = .black
        self.nicknameLabel.lineBreakMode = .byTruncatingTail
        self.nicknameLabel.numberOfLines = 1
        self.nicknameLabel.textAlignment = .left
        self.nicknameLabel.adjustsFontSizeToFitWidth = false
        
        self.nicknameLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.nicknameLabel.leadingAnchor.constraint(equalTo: self.profileImageView.trailingAnchor, constant: 20),
            self.nicknameLabel.trailingAnchor.constraint(equalTo: self.fixedView.trailingAnchor),
            self.nicknameLabel.heightAnchor.constraint(equalToConstant: 20),
            self.nicknameLabel.centerYAnchor.constraint(equalTo: self.fixedView.centerYAnchor, constant: -40),
        ])
        
        self.view.addSubview(self.idLabel)

        self.idLabel.font = UIFont.boldSystemFont(ofSize: 14)
        self.idLabel.textColor = .black
        self.idLabel.lineBreakMode = .byTruncatingTail
        self.idLabel.numberOfLines = 1
        self.idLabel.textAlignment = .left
        self.idLabel.adjustsFontSizeToFitWidth = false
        
        self.idLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.idLabel.leadingAnchor.constraint(equalTo: self.profileImageView.leadingAnchor),
            self.idLabel.trailingAnchor.constraint(equalTo: self.fixedView.trailingAnchor),
            self.idLabel.heightAnchor.constraint(equalToConstant: 20),
            self.idLabel.topAnchor.constraint(equalTo: self.profileImageView.bottomAnchor, constant: 10),
        ])
    }
    
    
    func setUpButtonLayout() {
        self.view.addSubview(self.profileChangeButton)
        
        self.profileChangeButton.setTitle("프로필 관리", for: .normal)
        self.profileChangeButton.titleLabel!.font = .systemFont(ofSize: 14.0, weight: .semibold)
        self.profileChangeButton.setTitleColor(.black, for: .normal)
        self.profileChangeButton.layer.cornerRadius = 7.5
        self.profileChangeButton.layer.borderWidth = 1
        self.profileChangeButton.layer.borderColor = UIColor.lightGray.cgColor

        self.profileChangeButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.profileChangeButton.leadingAnchor.constraint(equalTo: self.nicknameLabel.leadingAnchor),
            self.profileChangeButton.trailingAnchor.constraint(equalTo: self.fixedView.trailingAnchor, constant: -20),
            self.profileChangeButton.heightAnchor.constraint(equalToConstant: 24),
            self.profileChangeButton.topAnchor.constraint(equalTo: self.nicknameLabel.bottomAnchor, constant: 10),
        ])
        
        self.profileChangeButton.addTarget(self, action: #selector(profileChangeButtonTapped), for: .touchUpInside)
    }
    
    func setUpData() {
        // 서버에서 받아온 user data를 뷰에 세팅하는 함수.
        // 일단은 임시 데이터로 채우겠습니다.
        let url = URL(string: self.temporaryUserData.profileImageUrl)
        self.profileImageView.kf.setImage(with: url)
        self.nicknameLabel.text = temporaryUserData.nickname
        self.idLabel.text = temporaryUserData.id
    }
    
    @objc func navigationSegmentedControlValueChanged(_ sender: BetterSegmentedControl) {
        //***** !! To 은혜님 !! ******
        // 여기서 어떤 뷰컨 숨기고 어떤 뷰컨 드러낼지 설정하시면 됩니다!
        if sender.index == 0 {
            print("Turning lights on.")
            view.backgroundColor = .white
        } else {
            print("Turning lights off.")
            view.backgroundColor = .darkGray
        }
    }
    
    @objc func profileChangeButtonTapped() {
        print("profile Change Button Tapped")
    }
}
