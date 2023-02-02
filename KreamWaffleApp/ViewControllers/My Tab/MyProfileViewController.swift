//
//  MyProfileViewController.swift
//  KreamWaffleApp
//
//  Created by grace kim  on 2023/01/10.
//

import UIKit
import AVFoundation
import AVKit
import Photos
import RxCocoa
import RxSwift

class MyProfileViewController: UIViewController {
    private let userInfoVM: UserInfoViewModel
    private var userStyleFeedCollectionViewVC: StyleFeedCollectionViewVC?
    private let disposeBag = DisposeBag()
    
    init(userInfoVM: UserInfoViewModel) {
        self.userInfoVM = userInfoVM
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func shouldAddToSelection(indexPath: IndexPath, numSelections: Int) -> Bool {
        return true
    }
    
    let followerBar = MyTabSharedUIStackVIew(title1: "0", subtitle1: "게시물", title2: "2", subtitle2: "팔로워", title3: "0", subtitle3: "팔로잉", setCount: 3)
    let noPostView = UIStackView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        addSubviews()
        setUpSubviews()
        setUpChildStyleFeedCollectionView()
        bindChildStyleFeedCollectionView()
    }
    
    func addSubviews(){
        self.view.addSubview(followerBar)
        self.view.addSubview(noPostView)
    }
    
    func setUpSubviews(){
        self.followerBar.translatesAutoresizingMaskIntoConstraints = false
        self.followerBar.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0).isActive = true
        self.followerBar.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0).isActive = true
        self.followerBar.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        self.followerBar.heightAnchor.constraint(equalToConstant: self.view.frame.height/16).isActive = true
       
        setupNoPostView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //adding bottom border to follower bar
        self.followerBar.layer.addBorder([.bottom], color: colors.lightGray, width: 1.0)
        configureFollowerBarTapGesture()
    }
    
    
    func setupNoPostView(){
        let cameraImage = UIImage(named: "camera")
        cameraImage?.withTintColor(colors.lightGray)
        let resizedImage = cameraImage?.resize(targetSize: CGSize(width: 50, height: 50))
        let cameraImageView = UIImageView(image: resizedImage)
        
        let profileLabel = UILabel()
        profileLabel.text = "프로필"
        profileLabel.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        profileLabel.textColor = .black
        
        let detailLabel = UILabel()
        detailLabel.text = "사진을 공유하면 내 프로필에 표시됩니다."
        detailLabel.font = UIFont.systemFont(ofSize: 13, weight: .medium)
        detailLabel.textColor = .systemGray
        
        let addPhotoButton = AutoAddPaddingButtton()
        addPhotoButton.setTitle("첫 사진 공유", for: .normal)
        addPhotoButton.setTitleColor(.darkGray, for: .normal)
        addPhotoButton.titleLabel?.font = UIFont.systemFont(ofSize: 13, weight: .medium)
        addPhotoButton.layer.borderColor = UIColor.darkGray.cgColor
        addPhotoButton.layer.borderWidth = 1
        addPhotoButton.layer.cornerRadius = 10
        addPhotoButton.addTarget(self, action: #selector(cameraButtonTapped), for: .touchUpInside)
        
        self.noPostView.addArrangedSubviews([cameraImageView, profileLabel, detailLabel, addPhotoButton])
        noPostView.axis = .vertical
        noPostView.distribution = .equalSpacing
        noPostView.spacing = 10
        noPostView.alignment = .center
        noPostView.translatesAutoresizingMaskIntoConstraints = false
        noPostView.topAnchor.constraint(equalTo: self.followerBar.bottomAnchor, constant: 50).isActive = true
        noPostView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
    }
    
    func configureFollowerBarTapGesture() {
        self.followerBar.subView2.isUserInteractionEnabled = true
        self.followerBar.subView2.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.followerNumLabelTapped)))
        
        self.followerBar.subView3.isUserInteractionEnabled = true
        self.followerBar.subView3.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.followingNumLabelTapped)))
    }

    
    func setUpChildStyleFeedCollectionView() {
        let styleFeedRepository = StyleFeedRepository()
        let styleFeedUsecase = StyleFeedUsecase(repository: styleFeedRepository, type: "default", user_id: userInfoVM.User!.id)
        let styleFeedVM = StyleFeedViewModel(styleFeedUsecase: styleFeedUsecase)
        self.userStyleFeedCollectionViewVC = StyleFeedCollectionViewVC(styleFeedViewModel: styleFeedVM, userInfoViewModel: self.userInfoVM)
        
        self.view.addSubview(userStyleFeedCollectionViewVC!.view)
        self.addChild(userStyleFeedCollectionViewVC!)
        userStyleFeedCollectionViewVC!.didMove(toParent: self)

        userStyleFeedCollectionViewVC!.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.userStyleFeedCollectionViewVC!.view.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.userStyleFeedCollectionViewVC!.view.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            self.userStyleFeedCollectionViewVC!.view.topAnchor.constraint(equalTo: self.followerBar.bottomAnchor),
            self.userStyleFeedCollectionViewVC!.view.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
        ])
        
        self.userStyleFeedCollectionViewVC!.view.isHidden = true
    }
    
    func bindChildStyleFeedCollectionView() {
        self.userStyleFeedCollectionViewVC!.isEmptyFeedRelay
            .bind(to: self.userStyleFeedCollectionViewVC!.view.rx.isHidden)
            .disposed(by: disposeBag)
    }

    
    lazy var selectedImageV : UIImageView = {
        let imageView = UIImageView(frame: CGRect(x: 0,
                                                  y: 0,
                                                  width: UIScreen.main.bounds.width,
                                                  height: UIScreen.main.bounds.height * 0.45))
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    @objc func cameraButtonTapped(){
        Task {
            let isValidToken = await self.userInfoVM.checkAccessToken()
            if isValidToken {
                pushNewPostVC(userInfoViewModel: self.userInfoVM)
            } else {
                (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeToLoginVC()
            }
        }
    }
    
    @objc func followerNumLabelTapped() {
        if (!self.userInfoVM.isLoggedIn()) {
            (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeToLoginVC()
        } else {
            Task {
                let isValidToken = await self.userInfoVM.checkAccessToken()
                if (isValidToken) {
                    let followUserListViewController = FollowUserListViewController(id: userInfoVM.getUserId()!, userInfoViewModel: self.userInfoVM, selectedSegmentIdx: 0)
                    self.navigationController?.pushViewController(followUserListViewController, animated: false)
                }
                else {
                    (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeToLoginVC()
                }
            }
        }
    }
    
    @objc func followingNumLabelTapped() {
        
        if (!self.userInfoVM.isLoggedIn()) {
            (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeToLoginVC()
        } else {
            Task {
                let isValidToken = await self.userInfoVM.checkAccessToken()
                if (isValidToken) {
                    let followUserListViewController = FollowUserListViewController(id: userInfoVM.getUserId()!, userInfoViewModel: self.userInfoVM, selectedSegmentIdx: 1)
                    self.navigationController?.pushViewController(followUserListViewController, animated: false)
                } else {
                    (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeToLoginVC()
                }
            }
        }
    }
}
