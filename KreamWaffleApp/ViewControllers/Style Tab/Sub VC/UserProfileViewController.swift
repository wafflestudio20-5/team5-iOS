//
//  UserProfileViewController.swift
//  KreamWaffleApp
//
//  Created by 최성혁 on 2023/01/21.
//

import Foundation
import UIKit
import RxSwift
import Kingfisher

final class UserProfileViewController: UIViewController {
    private let userInfoViewModel: UserInfoViewModel
    private let userProfileViewModel: UserProfileViewModel
    private let styleFeedViewModel: StyleFeedViewModel
    
    private let fixedView = UIView()
    private let profileImageView = UIImageView()
    private let profileNameLabel = UILabel()
    private let userNameLabel = UILabel()
    private let introductionLabel = UILabel()
    private let divider = UILabel()
    private let followButton = FollowButton()
    
    private let disposeBag = DisposeBag()
    
    private lazy var userFeedCollectionViewVC = StyleFeedCollectionViewVC(styleFeedViewModel: styleFeedViewModel, userInfoViewModel: userInfoViewModel)
    
    init(userInfoViewModel: UserInfoViewModel, userProfileViewModel: UserProfileViewModel, styleFeedViewModel: StyleFeedViewModel) {
        self.userInfoViewModel = userInfoViewModel
        self.userProfileViewModel = userProfileViewModel
        self.styleFeedViewModel = styleFeedViewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        configureDesign()
        addSubviews()
        setUpFixedViewLayout()
        setupDivider()
        bindViews()
        requestProfile()
        setUpChildVC()
    }
    
    func configureDesign() {
        self.view.backgroundColor = .white
        self.setUpBackButton()
    }
    
    func addSubviews() {
        self.view.addSubviews(fixedView, profileImageView, profileNameLabel, userNameLabel, introductionLabel, divider, followButton)
    }
    
    func setUpFixedViewLayout() {
        self.fixedView.backgroundColor = .white

        self.fixedView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.fixedView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 0),
            self.fixedView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: 0),
            self.fixedView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            self.fixedView.bottomAnchor.constraint(equalTo: self.introductionLabel.bottomAnchor),
        ])
        
        setUpImageViewLayout()
        setUpLabelLayout()
        setUpButtonLayout()
    }
    
    func setUpImageViewLayout() {
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
        
        self.introductionLabel.font = UIFont.boldSystemFont(ofSize: 14)
        self.introductionLabel.textColor = .black
        self.introductionLabel.lineBreakStrategy = .hangulWordPriority
        self.introductionLabel.textAlignment = .left
        self.introductionLabel.adjustsFontSizeToFitWidth = false
        self.introductionLabel.numberOfLines = 0
        
        self.introductionLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.introductionLabel.leadingAnchor.constraint(equalTo: self.userNameLabel.leadingAnchor),
            self.introductionLabel.trailingAnchor.constraint(equalTo: self.fixedView.trailingAnchor),
            self.introductionLabel.topAnchor.constraint(equalTo: self.userNameLabel.bottomAnchor),
        ])
    }
    
    
    func setUpButtonLayout() {
        self.followButton.titleLabel!.font = .systemFont(ofSize: 14.0, weight: .semibold)
        self.followButton.tag = userProfileViewModel.getUserId()
        if (self.userInfoViewModel.isLoggedIn() && self.userInfoViewModel.isFollowing(user_id: self.followButton.tag)) {
            self.followButton.isFollowing = true
        }
        self.followButton.configureFollowButton()
        self.followButton.layer.cornerRadius = 7.5
        self.followButton.layer.borderWidth = 1
        self.followButton.layer.borderColor = UIColor.lightGray.cgColor

        self.followButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.followButton.leadingAnchor.constraint(equalTo: self.profileNameLabel.leadingAnchor),
            self.followButton.trailingAnchor.constraint(equalTo: self.fixedView.trailingAnchor, constant: -20),
            self.followButton.heightAnchor.constraint(equalToConstant: 24),
            self.followButton.topAnchor.constraint(equalTo: self.profileNameLabel.bottomAnchor, constant: 10),
        ])
        self.followButton.addTarget(self, action: #selector(requestFollow(sender:)), for: .touchUpInside)
    }
    
    func setupDivider(){
        self.divider.backgroundColor = colors.lightGray
        self.divider.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.divider.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.divider.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            self.divider.heightAnchor.constraint(equalToConstant: 20),
            self.divider.topAnchor.constraint(equalTo: self.fixedView.bottomAnchor, constant: 10),
        ])
    }
    
    func bindViews() {
        self.userProfileViewModel.userProfileDataSource.subscribe { [weak self] event in
            switch event {
            case .next:
                if let profile = event.element {
                    self!.setUpData(with: profile)
                }
            case .completed:
                break
            case .error:
                break
            }
        }.disposed(by: disposeBag)
    }
    
    func requestProfile() {
        self.userProfileViewModel.requestProfile()
    }
    
    func setUpData(with profile: Profile) {
        let urlString = profile.image
        guard let url = URL.init(string: urlString) else {
                return
            }
        let resource = ImageResource(downloadURL: url)

        KingfisherManager.shared.retrieveImage(with: resource, options: nil, progressBlock: nil) { result in
            switch result {
            case .success(let value):
                self.profileImageView.image = value.image
            case .failure(let error):
                print("Error: \(error)")
                //나중에는 여기 뭔가 이미지를 가져오는 과정에서 에러가 발생했다는 표시가 되는 이미지 넣자.
            }
        }
        self.profileNameLabel.text = profile.profile_name
        self.userNameLabel.text = profile.user_name
        self.introductionLabel.text = profile.introduction
        self.introductionLabel.sizeToFit()
    }
    
    func setUpChildVC() {
        self.view.addSubview(userFeedCollectionViewVC.view)
        self.addChild(userFeedCollectionViewVC)
        userFeedCollectionViewVC.didMove(toParent: self)
        
        userFeedCollectionViewVC.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.userFeedCollectionViewVC.view.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 0),
            self.userFeedCollectionViewVC.view.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: 0),
            self.userFeedCollectionViewVC.view.topAnchor.constraint(equalTo: self.divider.bottomAnchor, constant: 0),
            self.userFeedCollectionViewVC.view.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: 0),
        ])
    }
}

extension UserProfileViewController {
    @objc func requestFollow(sender: FollowButton) {
        if (!self.userInfoViewModel.isLoggedIn()) {
            let loginRepository = LoginRepository()
            let LoginUsecase = LoginUsecase(repository: loginRepository)
            let loginViewModel = LoginViewModel(UserUseCase: self.userInfoViewModel.UserUseCase, LoginUseCase: LoginUsecase)

            let loginScreen = LoginViewController(viewModel: loginViewModel)
            loginScreen.modalPresentationStyle = .fullScreen
            self.present(loginScreen, animated: false)
        } else {
            self.userInfoViewModel.requestFollow(user_id: sender.tag)
            sender.isFollowing = !sender.isFollowing
            sender.configureFollowButton()
        }
    }
}
