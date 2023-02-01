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

final class ProfileViewController: UIViewController {
    private let userInfoViewModel: UserInfoViewModel
    private let profileViewModel: ProfileViewModel
    private let styleFeedViewModel: StyleFeedViewModel
    
    private let fixedView = UIView()
    private let profileImageView = UIImageView()
    private let profileNameLabel = UILabel()
    private let userNameLabel = UILabel()
    private let introductionLabel = UILabel()
    private let postNumLabel = UILabel()
    private let followerNumLabel = UILabel()
    private let followingNumLabel = UILabel()
    private let fixedPostNumLabel = UILabel()
    private let fixedFollowerNumLabel = UILabel()
    private let fixedFollowingNumLabel = UILabel()
    private let mainDivider = UILabel()
    private let subDivider = UILabel()
    private let followButton = FollowButton()
    
    private let disposeBag = DisposeBag()
    
    private lazy var userFeedCollectionViewVC = StyleFeedCollectionViewVC(styleFeedViewModel: styleFeedViewModel, userInfoViewModel: userInfoViewModel)
    
    init(userInfoViewModel: UserInfoViewModel, profileViewModel: ProfileViewModel, styleFeedViewModel: StyleFeedViewModel) {
        self.userInfoViewModel = userInfoViewModel
        self.profileViewModel = profileViewModel
        self.styleFeedViewModel = styleFeedViewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        self.view.backgroundColor = .white
//        requestProfile()
        configureDesign()
        addSubviews()
        setUpFixedViewLayout()
        setupDividers()
        bindViews()
        setUpChildVC()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        requestProfile()
    }
    
    func configureDesign() {
        self.view.backgroundColor = .white
        self.setUpBackButton()
    }
    
    func addSubviews() {
        self.view.addSubviews(fixedView, profileImageView, profileNameLabel, userNameLabel, introductionLabel, mainDivider, followButton,
        subDivider, postNumLabel, followerNumLabel, followingNumLabel, fixedPostNumLabel, fixedFollowerNumLabel, fixedFollowingNumLabel)
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
        
        let labelWidth = self.view.frame.size.width/3
        let labelHeight: CGFloat = 20
        
        self.postNumLabel.font = UIFont.boldSystemFont(ofSize: 16)
        self.postNumLabel.textColor = .black
        self.postNumLabel.lineBreakMode = .byTruncatingTail
        self.postNumLabel.textAlignment = .center
        self.postNumLabel.adjustsFontSizeToFitWidth = false
        self.postNumLabel.numberOfLines = 1
        
        self.postNumLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.postNumLabel.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            self.postNumLabel.widthAnchor.constraint(equalToConstant: labelWidth),
            self.postNumLabel.topAnchor.constraint(equalTo: self.mainDivider.bottomAnchor, constant: 10),
            self.postNumLabel.heightAnchor.constraint(equalToConstant: labelHeight)
        ])
        
        self.followerNumLabel.font = UIFont.boldSystemFont(ofSize: 16)
        self.followerNumLabel.textColor = .black
        self.followerNumLabel.lineBreakMode = .byTruncatingTail
        self.followerNumLabel.textAlignment = .center
        self.followerNumLabel.adjustsFontSizeToFitWidth = false
        self.followerNumLabel.numberOfLines = 1
        
        self.followerNumLabel.isUserInteractionEnabled = true
        self.followerNumLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.followerNumLabelTapped)))
        
        self.followerNumLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.followerNumLabel.leadingAnchor.constraint(equalTo: self.postNumLabel.trailingAnchor),
            self.followerNumLabel.widthAnchor.constraint(equalToConstant: labelWidth),
            self.followerNumLabel.topAnchor.constraint(equalTo: self.postNumLabel.topAnchor),
            self.followerNumLabel.heightAnchor.constraint(equalTo: self.postNumLabel.heightAnchor)
        ])
        
        self.followingNumLabel.font = UIFont.boldSystemFont(ofSize: 16)
        self.followingNumLabel.textColor = .black
        self.followingNumLabel.lineBreakMode = .byTruncatingTail
        self.followingNumLabel.textAlignment = .center
        self.followingNumLabel.adjustsFontSizeToFitWidth = false
        self.followingNumLabel.numberOfLines = 1
        
        self.followingNumLabel.isUserInteractionEnabled = true
        self.followingNumLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.followingNumLabelTapped)))
        
        self.followingNumLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.followingNumLabel.leadingAnchor.constraint(equalTo: self.followerNumLabel.trailingAnchor),
            self.followingNumLabel.widthAnchor.constraint(equalToConstant: labelWidth),
            self.followingNumLabel.topAnchor.constraint(equalTo: self.postNumLabel.topAnchor),
            self.followingNumLabel.heightAnchor.constraint(equalTo: self.postNumLabel.heightAnchor)
        ])
        
        setUpFixedLabelLayout() //중요하지 않은 라벨들. 내용 다 고정된.
    }
    
    
    func setUpButtonLayout() {
        self.followButton.titleLabel!.font = .systemFont(ofSize: 14.0, weight: .semibold)
        self.followButton.tag = profileViewModel.getUserId()
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
    
    func setupDividers(){
        self.mainDivider.backgroundColor = colors.lightGray
        self.mainDivider.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.mainDivider.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.mainDivider.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            self.mainDivider.heightAnchor.constraint(equalToConstant: 20),
            self.mainDivider.topAnchor.constraint(equalTo: self.fixedView.bottomAnchor, constant: 10),
        ])
        
        self.subDivider.backgroundColor = colors.lightGray
        self.subDivider.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.subDivider.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.subDivider.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            self.subDivider.heightAnchor.constraint(equalToConstant: 1),
            self.subDivider.topAnchor.constraint(equalTo: self.fixedPostNumLabel.bottomAnchor, constant: 10),
        ])
    }
    
    func bindViews() {
        self.profileViewModel.userProfileDataSource.subscribe { [weak self] event in
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
        let token: String? = self.userInfoViewModel.UserResponse?.accessToken
        self.profileViewModel.requestProfile(token: token) { [weak self] in
            let alert = UIAlertController(title: "실패", message: "네트워크 연결을 확인해주세요", preferredStyle: UIAlertController.Style.alert)
            let okAction = UIAlertAction(title: "OK", style: .default) { _ in
                self?.navigationController?.popViewController(animated: true)
            }
            alert.addAction(okAction)
            self?.present(alert, animated: false, completion: nil)
        }
    }
    
    func setUpData(with fetchedProfile: Profile) {
        self.followButton.configure(following: fetchedProfile.following)
        
        let urlString = fetchedProfile.image
        if let url = URL.init(string: urlString) {
            let resource = ImageResource(downloadURL: url)
            
            KingfisherManager.shared.retrieveImage(with: resource, options: nil, progressBlock: nil) { result in
                switch result {
                case .success(let value):
                    self.profileImageView.image = value.image
                case .failure(_):
                    self.profileImageView.image = UIImage(systemName: "person")
                }
            }
        } else {
            self.profileImageView.image = UIImage(systemName: "person")
        }
        
        
        self.profileNameLabel.text = fetchedProfile.profile_name
        self.userNameLabel.text = fetchedProfile.user_name
        self.introductionLabel.text = fetchedProfile.introduction
        self.introductionLabel.sizeToFit()
        self.postNumLabel.text = String(0) //나중에 API 수정되면 고치기
        self.followerNumLabel.text = String(fetchedProfile.num_followers)
        self.followingNumLabel.text = String(fetchedProfile.num_followings)
    }
    
    func setUpChildVC() {
        self.view.addSubview(userFeedCollectionViewVC.view)
        self.addChild(userFeedCollectionViewVC)
        userFeedCollectionViewVC.didMove(toParent: self)
        
        userFeedCollectionViewVC.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.userFeedCollectionViewVC.view.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 0),
            self.userFeedCollectionViewVC.view.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: 0),
            self.userFeedCollectionViewVC.view.topAnchor.constraint(equalTo: self.subDivider.bottomAnchor, constant: 0),
            self.userFeedCollectionViewVC.view.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: 0),
        ])
    }
    
    func setUpFixedLabelLayout() {
        self.fixedPostNumLabel.font = UIFont.systemFont(ofSize: 14)
        self.fixedPostNumLabel.textColor = .black
        self.fixedPostNumLabel.lineBreakMode = .byTruncatingTail
        self.fixedPostNumLabel.textAlignment = .center
        self.fixedPostNumLabel.adjustsFontSizeToFitWidth = false
        self.fixedPostNumLabel.numberOfLines = 1
        self.fixedPostNumLabel.text = "게시물"
        
        self.fixedPostNumLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.fixedPostNumLabel.centerXAnchor.constraint(equalTo: self.postNumLabel.centerXAnchor),
            self.fixedPostNumLabel.topAnchor.constraint(equalTo: self.postNumLabel.bottomAnchor),
            self.fixedPostNumLabel.heightAnchor.constraint(equalTo: self.postNumLabel.heightAnchor)
        ])
        
        self.fixedFollowerNumLabel.font = UIFont.systemFont(ofSize: 14)
        self.fixedFollowerNumLabel.textColor = .black
        self.fixedFollowerNumLabel.lineBreakMode = .byTruncatingTail
        self.fixedFollowerNumLabel.textAlignment = .center
        self.fixedFollowerNumLabel.adjustsFontSizeToFitWidth = false
        self.fixedFollowerNumLabel.numberOfLines = 1
        self.fixedFollowerNumLabel.text = "팔로워"
        
        self.fixedFollowerNumLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.fixedFollowerNumLabel.centerXAnchor.constraint(equalTo: self.followerNumLabel.centerXAnchor),
            self.fixedFollowerNumLabel.topAnchor.constraint(equalTo: self.followerNumLabel.bottomAnchor),
            self.fixedFollowerNumLabel.heightAnchor.constraint(equalTo: self.postNumLabel.heightAnchor)
        ])
        
        self.fixedFollowingNumLabel.font = UIFont.systemFont(ofSize: 14)
        self.fixedFollowingNumLabel.textColor = .black
        self.fixedFollowingNumLabel.lineBreakMode = .byTruncatingTail
        self.fixedFollowingNumLabel.textAlignment = .center
        self.fixedFollowingNumLabel.adjustsFontSizeToFitWidth = false
        self.fixedFollowingNumLabel.numberOfLines = 1
        self.fixedFollowingNumLabel.text = "팔로잉"
        
        self.fixedFollowingNumLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.fixedFollowingNumLabel.centerXAnchor.constraint(equalTo: self.followingNumLabel.centerXAnchor),
            self.fixedFollowingNumLabel.topAnchor.constraint(equalTo: self.followingNumLabel.bottomAnchor),
            self.fixedFollowingNumLabel.heightAnchor.constraint(equalTo: self.postNumLabel.heightAnchor)
        ])
    }
}

extension ProfileViewController {
    @objc func requestFollow(sender: FollowButton) {
        if (!self.userInfoViewModel.isLoggedIn()) {
            (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeToLoginVC()
        } else {
            Task {
                let isValidToken = await self.userInfoViewModel.checkAccessToken()
                if (isValidToken) {
                    if let token = self.userInfoViewModel.UserResponse?.accessToken {
                        self.userInfoViewModel.requestFollow(token: token, user_id: sender.tag) { [weak self] in
                            let alert = UIAlertController(title: "실패", message: "네트워크 연결을 확인해주세요", preferredStyle: UIAlertController.Style.alert)
                            let okAction = UIAlertAction(title: "OK", style: .default) { _ in
                                self?.navigationController?.popViewController(animated: true)
                            }
                            alert.addAction(okAction)
                            self?.present(alert, animated: false, completion: nil)
                            
                        }
                        
                        sender.followButtonTapped()
                    } else {
                        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeToLoginVC()
                    }
                } else {
                    (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeToLoginVC()
                }
            }
        }
    }
    
    @objc func followerNumLabelTapped() {
        if (!self.userInfoViewModel.isLoggedIn()) {
            (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeToLoginVC()
        } else {
            Task {
                let isValidToken = await self.userInfoViewModel.checkAccessToken()
                if (isValidToken) {
                    let followUserListViewController = FollowUserListViewController(id: profileViewModel.getUserId(), userInfoViewModel: self.userInfoViewModel, selectedSegmentIdx: 0)
                    self.navigationController?.pushViewController(followUserListViewController, animated: false)
                }
                else {
                    (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeToLoginVC()
                }
            }
        }
    }
    
    @objc func followingNumLabelTapped() {
        
        if (!self.userInfoViewModel.isLoggedIn()) {
            (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeToLoginVC()
        } else {
            Task {
                let isValidToken = await self.userInfoViewModel.checkAccessToken()
                if (isValidToken) {
                    let followUserListViewController = FollowUserListViewController(id: profileViewModel.getUserId(), userInfoViewModel: self.userInfoViewModel, selectedSegmentIdx: 1)
                    self.navigationController?.pushViewController(followUserListViewController, animated: false)
                } else {
                    (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeToLoginVC()
                }
            }
        }
    }
}
