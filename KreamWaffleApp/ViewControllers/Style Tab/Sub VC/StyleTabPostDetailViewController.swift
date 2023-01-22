//
//  StyleTabPostDetailViewController.swift
//  KreamWaffleApp
//
//  Created by 최성혁 on 2023/01/06.
//

import Foundation
import UIKit
import ImageSlideshow

final class StyleTabPostDetailViewController: UIViewController {
    
    private let idLabelHeight: CGFloat = 20
    private let spacing: CGFloat = 10
    private let likeAndCommentButtonSideLength: CGFloat = 50
    
    private let styleTabDetailViewModel: StyleTabDetailViewModel
    private let userInfoViewModel: UserInfoViewModel
    
    //main views
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let slideshow = ImageSlideshow()
    
    //labels
    private let idLabel = UILabel()
    private let contentLabel = UILabel()
    private let numLikesLabel = UILabel()
    
    //buttons
    private let followButton = UIButton()
    private let likeButton = UIButton()
    private let commentButton = UIButton()
    
    private var imageHeight = CGFloat()
    
    init(styleTabDetailViewModel: StyleTabDetailViewModel, userInfoViewModel: UserInfoViewModel) {
        self.styleTabDetailViewModel = styleTabDetailViewModel
        self.userInfoViewModel = userInfoViewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        imageHeight = CGFloat(styleTabDetailViewModel.getThumbnailImageRatio()) * (self.view.bounds.width)
        self.view.backgroundColor = .white
        addAllSubviews()
        setUpNavigationBar()
        setUpScrollView()
        setUpLabelLayout()
        setUpButtonLayout()
        setUpSlideShowLayout()
        configureSlideShow()
        setUpSlideShowData()
        setUpData()
    }
    
    func addAllSubviews() {
        view.addSubviews(scrollView, self.followButton)
        scrollView.addSubview(contentView)
        contentView.addSubviews(idLabel, numLikesLabel, contentLabel, likeButton, commentButton, self.slideshow)
    }
    
    func setUpNavigationBar() {
        navigationController?.navigationBar.tintColor = .lightGray
        self.setUpBackButton()
        self.navigationItem.backButtonTitle = ""
//        navigationItem.title = "최신"
    }
    
    func setUpScrollView() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
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
    
    func setUpLabelLayout() {
        idLabel.font = UIFont.boldSystemFont(ofSize: 14)
        idLabel.textColor = .black
        idLabel.lineBreakMode = .byTruncatingTail
        idLabel.adjustsFontSizeToFitWidth = false
        idLabel.numberOfLines = 1
        idLabel.textAlignment = .left
        
        let idLabelTap = UITapGestureRecognizer(target: self, action: #selector(self.idLabelTapped))
        self.idLabel.isUserInteractionEnabled = true
        self.idLabel.addGestureRecognizer(idLabelTap)
        
        idLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            idLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            idLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            idLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            idLabel.heightAnchor.constraint(
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
        contentLabel.numberOfLines = Int.max
        
        contentLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            contentLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            contentLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            contentLabel.topAnchor.constraint(equalTo: numLikesLabel.bottomAnchor, constant: spacing),
            contentLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        
    }
    
    func setUpButtonLayout() {
        // **팔로우 상태에 따라 다르게. 나중에 수정해야함.
        followButton.setTitle("팔로우", for: .normal)
        // **************************************
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
            followButton.centerYAnchor.constraint(equalTo: idLabel.centerYAnchor)
        ])
        
        
        likeButton.setImage(UIImage(systemName: "face.smiling"), for: .normal)
        likeButton.addTarget(self, action: #selector(likeButtonTapped), for: .touchUpInside)
        likeButton.setPreferredSymbolConfiguration(.init(pointSize: 30, weight: .regular, scale: .default), forImageIn: .normal)

        likeButton.tintColor = .black
        
        likeButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            likeButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5),
            likeButton.widthAnchor.constraint(
                equalToConstant: likeAndCommentButtonSideLength
            ),
            likeButton.topAnchor.constraint(
                equalTo: idLabel.bottomAnchor,
                constant: spacing + imageHeight + spacing
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
    
    func setUpSlideShowLayout() {
        slideshow.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.slideshow.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            self.slideshow.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
            self.slideshow.topAnchor.constraint(
                equalTo: self.idLabel.bottomAnchor,
                constant: spacing
            ),
            self.slideshow.heightAnchor.constraint(equalToConstant: imageHeight),
        ])
    }
    
    func configureSlideShow() {
        if (styleTabDetailViewModel.getImageSources().count > 1) {
            self.slideshow.pageIndicatorPosition = .init(horizontal: .center, vertical: .under)
            self.slideshow.contentScaleMode = UIViewContentMode.scaleAspectFit
            self.slideshow.circular = false
            
            let pageControl = UIPageControl()
            pageControl.currentPageIndicatorTintColor = UIColor.black
            pageControl.pageIndicatorTintColor = UIColor.lightGray
            self.slideshow.pageIndicator = pageControl
        }
    }
    
    func setUpSlideShowData() {
        let imageSources = self.styleTabDetailViewModel.getImageSources().map {
            KingfisherSource(urlString: $0)!
        }
        self.slideshow.setImageInputs(imageSources)
        
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(StyleTabPostDetailViewController.slideShowTapped))
        slideshow.addGestureRecognizer(recognizer)
    }
    
    func setUpData() {
        self.idLabel.text = self.styleTabDetailViewModel.getProfileName()
        self.contentLabel.text = self.styleTabDetailViewModel.getContent()
        self.contentLabel.sizeToFit()
        self.numLikesLabel.text = "공감 \(self.styleTabDetailViewModel.getNumLikes())개"
        self.numLikesLabel.sizeToFit()
    }
}

extension StyleTabPostDetailViewController { //button 관련 메서드들.
    @objc func slideShowTapped() {
        let fullScreenController = slideshow.presentFullScreenController(from: self)
        fullScreenController.slideshow.activityIndicator = DefaultActivityIndicator(style: .medium, color: nil)
    }
    
    @objc func numLikesLabelTapped() {
        self.navigationController?.pushViewController(LikedUserListViewController(userInfoViewModel: self.userInfoViewModel), animated: true)
    }

    @objc func idLabelTapped() {
        let user_id = self.styleTabDetailViewModel.getUserId()
        self.pushUserProfileVC(user_id: user_id, userInfoViewModel: self.userInfoViewModel)
    }
    
    @objc func followButtonTapped() {
        print("follow button")
    }
    
    @objc func likeButtonTapped() {
        print("like button")
    }
    
    @objc func commentButtonTapped() {
        print("comment button")
    }
}
