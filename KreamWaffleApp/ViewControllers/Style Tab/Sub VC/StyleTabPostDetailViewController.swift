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
    
    struct StylePostDetailViewConstants {
        static let idLabelHeight: CGFloat = 20
        static let spacing: CGFloat = 10
    }
    
    private let viewModel: StyleTabDetailViewModel
    
    //main views
    private let scrollView = UIScrollView()
    private let scrollViewContentView = UIView()
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
    
    init(viewModel: StyleTabDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        imageHeight = CGFloat(viewModel.getThumbnailImageRatio()) * (self.view.bounds.width)
        self.view.backgroundColor = .white
        setUpNavigationBar()
        setUpScrollView()
        setUpLabelLayout()
        setUpButtonLayout()
        setUpSlideShowLayout()
        configureSlideShow()
        setUpSlideShowData()
        setUpData()
    }
    
    func setUpScrollView() {
        view.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
        
        scrollView.addSubview(scrollViewContentView)
        scrollViewContentView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            scrollViewContentView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            scrollViewContentView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            scrollViewContentView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            scrollViewContentView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor)
        ])
        
        scrollViewContentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true

        let contentViewHeight = scrollViewContentView.heightAnchor.constraint(greaterThanOrEqualTo: view.heightAnchor)
        contentViewHeight.priority = .defaultLow
        contentViewHeight.isActive = true
        scrollView.showsVerticalScrollIndicator = false
    }
    
    func setUpNavigationBar() {
        navigationController?.navigationBar.tintColor = .lightGray
        navigationItem.title = "최신"
    }
    
    func setUpLabelLayout() {
        view.addSubview(idLabel)

        idLabel.font = UIFont.boldSystemFont(ofSize: 14)
        idLabel.textColor = .black
        idLabel.lineBreakMode = .byTruncatingTail
        idLabel.numberOfLines = 1
        idLabel.textAlignment = .left
        idLabel.adjustsFontSizeToFitWidth = false
        
        idLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            idLabel.leadingAnchor.constraint(equalTo: scrollViewContentView.leadingAnchor, constant: 10),
            idLabel.trailingAnchor.constraint(equalTo: scrollViewContentView.trailingAnchor, constant: -10),
            idLabel.topAnchor.constraint(equalTo: scrollViewContentView.topAnchor),
            idLabel.heightAnchor.constraint(
                equalToConstant: StylePostDetailViewConstants.idLabelHeight
            ),
        ])
        
        view.addSubview(contentLabel)
        contentLabel.font = UIFont.systemFont(ofSize: 14)
        contentLabel.textColor = .black
        contentLabel.lineBreakStrategy = .hangulWordPriority
        contentLabel.textAlignment = .left
        contentLabel.adjustsFontSizeToFitWidth = false
        contentLabel.numberOfLines = Int.max
        
        contentLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            contentLabel.leadingAnchor.constraint(equalTo: scrollViewContentView.leadingAnchor, constant: 10),
            contentLabel.trailingAnchor.constraint(equalTo: scrollViewContentView.trailingAnchor, constant: -10),
            contentLabel.topAnchor.constraint(equalTo: self.numLikesLabel.bottomAnchor),
            contentLabel.bottomAnchor.constraint(equalTo: scrollViewContentView.bottomAnchor)
        ])
        
        view.addSubview(self.numLikesLabel)
        numLikesLabel.font = UIFont.systemFont(ofSize: 14)
        numLikesLabel.textColor = .lightGray
        numLikesLabel.textAlignment = .left
        numLikesLabel.adjustsFontSizeToFitWidth = false
        numLikesLabel.numberOfLines = 1
        
        numLikesLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            numLikesLabel.leadingAnchor.constraint(equalTo: scrollViewContentView.leadingAnchor, constant: 10),
            numLikesLabel.trailingAnchor.constraint(equalTo: scrollViewContentView.trailingAnchor, constant: -10),
            numLikesLabel.topAnchor.constraint(equalTo: self.likeButton.bottomAnchor),
            numLikesLabel.bottomAnchor.constraint(equalTo: scrollViewContentView.bottomAnchor)
        ])
        
    }
    
    func setUpButtonLayout() {
        view.addSubview(self.followButton)
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
            followButton.trailingAnchor.constraint(equalTo: scrollViewContentView.trailingAnchor, constant: -10),
            followButton.heightAnchor.constraint(equalToConstant: 40),
            followButton.centerYAnchor.constraint(equalTo: self.idLabel.centerYAnchor)
        ])
        
        
        view.addSubview(likeButton)
        likeButton.setImage(UIImage(systemName: "face.smiling"), for: .normal)
        likeButton.addTarget(self, action: #selector(likeButtonTapped), for: .touchUpInside)
        
        likeButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            likeButton.leadingAnchor.constraint(equalTo: scrollViewContentView.leadingAnchor, constant: 10),
            likeButton.widthAnchor.constraint(equalToConstant: 50),
            likeButton.topAnchor.constraint(
                equalTo: scrollViewContentView.topAnchor,
                constant: imageHeight + StylePostDetailViewConstants.idLabelHeight
            ),
            likeButton.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        view.addSubview(commentButton)
        commentButton.setImage(UIImage(systemName: "bubble.right"), for: .normal)
        commentButton.addTarget(self, action: #selector(commentButtonTapped), for: .touchUpInside)
        
        commentButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            commentButton.leadingAnchor.constraint(equalTo: self.likeButton.trailingAnchor),
            commentButton.widthAnchor.constraint(equalToConstant: 50),
            commentButton.topAnchor.constraint(equalTo: self.likeButton.topAnchor),
            commentButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    func setUpSlideShowLayout() {
        self.view.addSubview(self.slideshow)
        self.slideshow.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.slideshow.leadingAnchor.constraint(equalTo: self.scrollViewContentView.leadingAnchor),
            self.slideshow.trailingAnchor.constraint(equalTo: self.scrollViewContentView.trailingAnchor),
            self.slideshow.topAnchor.constraint(
                equalTo: self.scrollViewContentView.topAnchor,
                constant: StylePostDetailViewConstants.idLabelHeight + StylePostDetailViewConstants.spacing
            ),
            self.slideshow.heightAnchor.constraint(equalToConstant: imageHeight),
        ])
    }
    
    func configureSlideShow() {
        self.slideshow.pageIndicatorPosition = .init(horizontal: .center, vertical: .under)
        self.slideshow.contentScaleMode = UIViewContentMode.scaleAspectFit
        self.slideshow.circular = false
        
        let pageControl = UIPageControl()
        pageControl.currentPageIndicatorTintColor = UIColor.black
        pageControl.pageIndicatorTintColor = UIColor.lightGray
        self.slideshow.pageIndicator = pageControl

    }
    
    func setUpSlideShowData() {
        let imageSources = self.viewModel.getImageSources().map {
            KingfisherSource(urlString: $0)!
        }
        self.slideshow.setImageInputs(imageSources)
        
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(StyleTabPostDetailViewController.slideShowTapped))
        slideshow.addGestureRecognizer(recognizer)
    }
    
    func setUpData() {
        self.idLabel.text = self.viewModel.getUserId()
        self.contentLabel.text = self.viewModel.getContent()
        self.contentLabel.sizeToFit()
        self.numLikesLabel.text = "😀\(self.viewModel.getNumLikes())"
        self.numLikesLabel.sizeToFit()
    }
}

extension StyleTabPostDetailViewController { //button 관련 메서드들.
    @objc func slideShowTapped() {
        let fullScreenController = slideshow.presentFullScreenController(from: self)
        fullScreenController.slideshow.activityIndicator = DefaultActivityIndicator(style: .white, color: nil)
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
