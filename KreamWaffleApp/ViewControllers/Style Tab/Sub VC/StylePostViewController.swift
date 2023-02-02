//
//  StyleTabPostDetailViewController.swift
//  KreamWaffleApp
//
//  Created by 최성혁 on 2023/01/06.
//

import Foundation
import UIKit
import ImageSlideshow
import RxSwift
import Kingfisher

final class StylePostViewController: UIViewController {
    
    private let idLabelHeight: CGFloat = 20
    private let spacing: CGFloat = 10
    private let likeAndCommentButtonSideLength: CGFloat = 50
    
    private let stylePostViewModel: StylePostViewModel
    private let userInfoViewModel: UserInfoViewModel
    
    private let disposeBag = DisposeBag()
    private let scrollViewRefreshControl = UIRefreshControl()
    
    private var isLiked: Bool = false {
        didSet {
            if (isLiked) {
                likeButton.setImage(UIImage(systemName: "heart.circle"), for: .normal)
            } else {
                likeButton.setImage(UIImage(systemName: "face.smiling"), for: .normal)
            }
        }
    }
    private var writerUserId: Int = 0
    
    //main views
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let slideshow = ImageSlideshow()
    
    //기타 view
    private let userNameLabel = UILabel()
    private let contentLabel = UILabel()
    private let numLikesLabel = UILabel()
    private let profileImageView = UIImageView()
    
    //buttons
    private let followButton = FollowButton()
    private let likeButton = UIButton()
    private let commentButton = UIButton()
    
//    private var imageHeight = CGFloat()
    
    init(stylePostViewModel: StylePostViewModel, userInfoViewModel: UserInfoViewModel) {
        self.stylePostViewModel = stylePostViewModel
        self.userInfoViewModel = userInfoViewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        self.view.backgroundColor = .white
        addAllSubviews()
        setUpNavigationBar()
        setUpScrollView()
        setUpLabelLayout()
        setUpButtonLayout()
        setUpRefreshControl()
        bindUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.hidesBottomBarWhenPushed = false;
        self.tabBarController?.tabBar.isHidden = false
        self.tabBarController?.tabBar.backgroundColor = .white
        refreshData()
    }
    
    private func refreshData() {
        Task {
            await self.userInfoViewModel.checkAccessToken()
            let token = self.userInfoViewModel.UserResponse?.accessToken
            
            self.stylePostViewModel.requestPost(token: token) { [weak self] in
                let alert = UIAlertController(title: "실패", message: "네트워크 연결을 확인해주세요", preferredStyle: UIAlertController.Style.alert)
                let okAction = UIAlertAction(title: "OK", style: .default) { _ in
                    self?.navigationController?.popViewController(animated: true)
                }
                alert.addAction(okAction)
                self?.present(alert, animated: false, completion: nil)
            }
        }
    }
    
    private func addAllSubviews() {
        view.addSubviews(scrollView, self.followButton)
        scrollView.addSubview(contentView)
        contentView.addSubviews(profileImageView, userNameLabel, numLikesLabel, contentLabel, likeButton, commentButton, self.slideshow)
    }
    
    private func setUpNavigationBar() {
        navigationController?.navigationBar.tintColor = .lightGray
        self.setUpBackButton()
        self.navigationItem.backButtonTitle = ""
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.black]
//        navigationItem.title = "최신"
    }
    
    private func setUpScrollView() {
        scrollView.backgroundColor = .white
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
        contentView.backgroundColor = .white
        contentView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            contentView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            contentView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor, constant: -100)
        ])
        
        contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true

        let contentViewHeight = contentView.heightAnchor.constraint(greaterThanOrEqualTo: view.heightAnchor)
        contentViewHeight.priority = .defaultLow
        contentViewHeight.isActive = true
        scrollView.showsVerticalScrollIndicator = false
    }
    
    private func setUpLabelLayout() {
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        profileImageView.contentMode = .scaleAspectFit
        profileImageView.layer.cornerRadius = idLabelHeight/2
        profileImageView.clipsToBounds = true
        profileImageView.tintColor = .black
        NSLayoutConstraint.activate([
            profileImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            profileImageView.widthAnchor.constraint(equalToConstant: idLabelHeight),
            profileImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            profileImageView.heightAnchor.constraint(equalToConstant: idLabelHeight),
        ])
        
        userNameLabel.font = UIFont.boldSystemFont(ofSize: 14)
        userNameLabel.textColor = .black
        userNameLabel.lineBreakMode = .byTruncatingTail
        userNameLabel.adjustsFontSizeToFitWidth = false
        userNameLabel.numberOfLines = 1
        userNameLabel.textAlignment = .left
        
        let userNameLabelTap = UITapGestureRecognizer(target: self, action: #selector(self.idLabelTapped))
        self.userNameLabel.isUserInteractionEnabled = true
        self.userNameLabel.addGestureRecognizer(userNameLabelTap)
        
        userNameLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            userNameLabel.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 10),
            userNameLabel.widthAnchor.constraint(equalToConstant: 100),
            userNameLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            userNameLabel.heightAnchor.constraint(
                equalToConstant: idLabelHeight
            ),
        ])
        
        
        numLikesLabel.font = UIFont.systemFont(ofSize: 14)
        numLikesLabel.textColor = .lightGray
        numLikesLabel.textAlignment = .left
        numLikesLabel.adjustsFontSizeToFitWidth = false
        numLikesLabel.numberOfLines = 1
        
        let numLikesLabelTap = UITapGestureRecognizer(target: self, action: #selector(self.numLikesLabelTapped))
        self.numLikesLabel.isUserInteractionEnabled = true
        self.numLikesLabel.addGestureRecognizer(numLikesLabelTap)
        
        numLikesLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            numLikesLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            numLikesLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            numLikesLabel.topAnchor.constraint(equalTo: likeButton.bottomAnchor, constant: spacing),
            numLikesLabel.heightAnchor.constraint(equalToConstant: idLabelHeight),
        ])
        
        contentLabel.font = UIFont.systemFont(ofSize: 14)
        contentLabel.textColor = .black
        contentLabel.lineBreakStrategy = .hangulWordPriority
        contentLabel.textAlignment = .left
        contentLabel.adjustsFontSizeToFitWidth = false
        contentLabel.numberOfLines = 0
        
        contentLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            contentLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            contentLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            contentLabel.topAnchor.constraint(equalTo: numLikesLabel.bottomAnchor, constant: spacing),
            contentLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        
    }
    
    private func setUpButtonLayout() {
        followButton.backgroundColor = .black
        followButton.titleLabel!.font = .systemFont(ofSize: 14.0, weight: .semibold)
        followButton.setTitleColor(.white, for: .normal)
        followButton.layer.cornerRadius = 7.5
        followButton.addTarget(self, action: #selector(followButtonTapped), for: .touchUpInside)
        
        followButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            followButton.widthAnchor.constraint(equalToConstant: 60),
            followButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            followButton.heightAnchor.constraint(equalToConstant: idLabelHeight * 1.5),
            followButton.centerYAnchor.constraint(equalTo: userNameLabel.centerYAnchor)
        ])
        
        
        likeButton.setImage(UIImage(systemName: "face.smiling"), for: .normal)
        likeButton.addTarget(self, action: #selector(likeButtonTapped), for: .touchUpInside)
        likeButton.setPreferredSymbolConfiguration(.init(pointSize: 30, weight: .regular, scale: .default), forImageIn: .normal)
        likeButton.tintColor = .black
        likeButton.backgroundColor = .white
        
        likeButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            likeButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5),
            likeButton.widthAnchor.constraint(
                equalToConstant: likeAndCommentButtonSideLength
            ),
            likeButton.topAnchor.constraint(
                equalTo: slideshow.bottomAnchor,
                constant: spacing
            ),
            likeButton.heightAnchor.constraint(
                equalToConstant: likeAndCommentButtonSideLength
            ),
        ])
        
        commentButton.setImage(UIImage(systemName: "bubble.right"), for: .normal)
        commentButton.setPreferredSymbolConfiguration(.init(pointSize: 30, weight: .regular, scale: .default), forImageIn: .normal)
        commentButton.addTarget(self, action: #selector(commentButtonTapped), for: .touchUpInside)
        commentButton.tintColor = .black
        
        commentButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            commentButton.leadingAnchor.constraint(equalTo: likeButton.trailingAnchor),
            commentButton.widthAnchor.constraint(
                equalToConstant: likeAndCommentButtonSideLength
            ),
            commentButton.topAnchor.constraint(equalTo: self.likeButton.topAnchor),
            commentButton.heightAnchor.constraint(
                equalToConstant: likeAndCommentButtonSideLength
            )
        ])
    }
    
    private func setUpRefreshControl() {
        self.scrollViewRefreshControl.addTarget(self, action: #selector(refreshFunction), for: .valueChanged)
        self.scrollView.refreshControl = self.scrollViewRefreshControl
    }
    
    private func bindUI() {
        self.stylePostViewModel.stylePostDataSource.subscribe { [weak self] event in
            switch event {
            case .next:
                if let post = event.element {
                    if let post = post {
                        self?.setUpSlideShowLayout()
                        self?.configureSlideShow()
                        self?.setUpSlideShowData(with: post.images)
                        self?.setUpData(with: post)
                    }
                }
            case .completed:
                break
            case .error:
                break
            }
        }.disposed(by: disposeBag)
    }
    
    private func setUpSlideShowLayout() {
        let imageHeight = CGFloat(stylePostViewModel.getThumbnailImageRatio()) * (self.view.bounds.width)
        slideshow.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.slideshow.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            self.slideshow.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
            self.slideshow.topAnchor.constraint(
                equalTo: self.userNameLabel.bottomAnchor,
                constant: spacing
            ),
            self.slideshow.heightAnchor.constraint(equalToConstant: imageHeight),
        ])
    }
    
    private func configureSlideShow() {
        if (stylePostViewModel.getImageSourcesCount() > 1) {
            self.slideshow.pageIndicatorPosition = .init(horizontal: .center, vertical: .under)
            self.slideshow.contentScaleMode = UIViewContentMode.scaleAspectFit
            self.slideshow.circular = false
            
            let pageControl = UIPageControl()
            pageControl.currentPageIndicatorTintColor = UIColor.black
            pageControl.pageIndicatorTintColor = UIColor.lightGray
            self.slideshow.pageIndicator = pageControl
        }
    }
    
    private func setUpSlideShowData(with imageSourceUrls: [String]) {
        let imageSources = imageSourceUrls.map {
            KingfisherSource(urlString: $0)!
        }
        self.slideshow.setImageInputs(imageSources)
        
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(StylePostViewController.slideShowTapped))
        slideshow.addGestureRecognizer(recognizer)
    }
    
    private func setUpData(with post: Post) {
        self.followButton.configure(following: post.created_by.following)
        
        self.userNameLabel.text = post.created_by.user_name
        self.contentLabel.text = post.content
        self.contentLabel.sizeToFit()
        self.numLikesLabel.text = "공감 \(post.num_likes)개"
        self.numLikesLabel.sizeToFit()
        
        self.writerUserId = post.created_by.user_id
        
        if post.liked == "true" {
            self.isLiked = true
        } else {
            self.isLiked = false
        }
        
        let urlString = post.created_by.image
        guard let url = URL.init(string: urlString) else {
            self.profileImageView.image = UIImage(systemName: "person")
            return
        }
        let resource = ImageResource(downloadURL: url)
        
        KingfisherManager.shared.retrieveImage(with: resource, options: nil, progressBlock: nil) { result in
            switch result {
            case .success(let value):
                self.profileImageView.image = value.image
            case .failure(_):
                self.profileImageView.image = UIImage(systemName: "person")
            }
        }
        
    }
}

extension StylePostViewController { //button 관련 메서드들.
    @objc func slideShowTapped() {
        let fullScreenController = slideshow.presentFullScreenController(from: self)
        fullScreenController.slideshow.activityIndicator = DefaultActivityIndicator(style: .medium, color: nil)
    }
    
    @objc func refreshFunction() {
        refreshData()
        self.scrollViewRefreshControl.endRefreshing()
    }
    
    @objc func numLikesLabelTapped() {
        if (!self.userInfoViewModel.isLoggedIn()) {
            (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeToLoginVC()
        } else {
            self.navigationController?.pushViewController(LikedUserListViewController(id: self.stylePostViewModel.getPostId(), userInfoViewModel: self.userInfoViewModel), animated: true)
        }
    }

    @objc func idLabelTapped() {
        let user_id = self.stylePostViewModel.getUserId()
        self.pushProfileVC(user_id: user_id, userInfoViewModel: self.userInfoViewModel)
    }
    
    @objc func followButtonTapped() {
        if (!self.userInfoViewModel.isLoggedIn()) {
            (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeToLoginVC()
        } else {
            Task {
                let isValidToken = await self.userInfoViewModel.checkAccessToken()
                if (isValidToken) {
                    if let token = self.userInfoViewModel.UserResponse?.accessToken {
                        self.userInfoViewModel.requestFollow(token: token, user_id: self.writerUserId) { [weak self] in
                            let alert = UIAlertController(title: "실패", message: "네트워크 연결을 확인해주세요", preferredStyle: UIAlertController.Style.alert)
                            let okAction = UIAlertAction(title: "OK", style: .default) { _ in
                                self?.navigationController?.popViewController(animated: true)
                            }
                            alert.addAction(okAction)
                            self?.present(alert, animated: false, completion: nil)
                        }
                        
                        self.followButton.followButtonTapped()
                    } else {
                        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeToLoginVC()
                    }
                } else {
                    (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeToLoginVC()
                }
            }
        }
    }
    
    @objc func likeButtonTapped() {
        if (!self.userInfoViewModel.isLoggedIn()) {
            (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeToLoginVC()
        } else {
            Task {
                let isValidToken = await self.userInfoViewModel.checkAccessToken()
                if isValidToken {
                    if let token = self.userInfoViewModel.UserResponse?.accessToken {
                        self.stylePostViewModel.likeButtonTapped(token: token) {[weak self] in
                            let alert = UIAlertController(title: "실패", message: "네트워크 연결을 확인해주세요", preferredStyle: UIAlertController.Style.alert)
                            let okAction = UIAlertAction(title: "OK", style: .default) { _ in
                                self?.navigationController?.popViewController(animated: true)
                            }
                            alert.addAction(okAction)
                            self?.present(alert, animated: false, completion: nil)
                            
                        }
                        self.isLiked = !self.isLiked
                    } else {
                        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeToLoginVC()
                    }
                } else {
                    (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeToLoginVC()
                }
            }
            
        }
    }
    
    @objc func commentButtonTapped() {
        if (!self.userInfoViewModel.isLoggedIn()) {
            (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeToLoginVC()
        } else {
            self.hidesBottomBarWhenPushed = true;
            
            let commentRepository = StyleCommentRepository()
            let commentUsecase = CommentUsecase(commentRepository: commentRepository)
            let commentViewModel = CommentViewModel(commentUsecase: commentUsecase, id: self.stylePostViewModel.getPostId())
            self.navigationController?.pushViewController(CommentViewController(userInfoViewModel: self.userInfoViewModel, commentViewModel: commentViewModel), animated: true)
        }
    }
}
