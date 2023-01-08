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
    private let slideshow = ImageSlideshow()
    private var imageHeight = CGFloat()
    private let idLabel = UILabel()
    private let contentLabel = UILabel()
    private let testString = "eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee"
    
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
        setUpLabelLayout()
        setUpSlideShowLayout()
        configureSlideShow()
        setUpSlideShowData()
        setUpData()
    }
    
    func setUpNavigationBar() {
        self.navigationController?.navigationBar.tintColor = .lightGray
        self.navigationItem.title = "최신"
    }
    
    func setUpLabelLayout() {
        self.view.addSubview(self.idLabel)

        self.idLabel.font = UIFont.boldSystemFont(ofSize: 14)
        self.idLabel.textColor = .black
        self.idLabel.lineBreakMode = .byTruncatingTail
        self.idLabel.numberOfLines = 1
        self.idLabel.textAlignment = .left
        self.idLabel.adjustsFontSizeToFitWidth = false
        
        self.idLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.idLabel.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            self.idLabel.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            self.idLabel.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            self.idLabel.heightAnchor.constraint(
                equalToConstant: StylePostDetailViewConstants.idLabelHeight
            ),
        ])
        
        self.view.addSubview(self.contentLabel)
        self.contentLabel.font = UIFont.systemFont(ofSize: 14)
        self.contentLabel.textColor = .black
        self.contentLabel.lineBreakStrategy = .hangulWordPriority
        self.contentLabel.textAlignment = .left
        self.contentLabel.adjustsFontSizeToFitWidth = false
        self.contentLabel.numberOfLines = Int.max
        
        //scrollview로 바꿔서 해보자!
        self.contentLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.contentLabel.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            self.contentLabel.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            self.contentLabel.topAnchor.constraint(
                equalTo: self.view.safeAreaLayoutGuide.topAnchor,
                constant: imageHeight + StylePostDetailViewConstants.idLabelHeight - 100
            ),
            self.contentLabel.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
    }
    
    func setUpSlideShowLayout() {
        self.view.addSubview(self.slideshow)
        self.slideshow.translatesAutoresizingMaskIntoConstraints = false
        
        //양쪽에 딱 붙게 만들고 싶은데 그게 안됨... 라이브러리 자체에 padding이 들어가 있는 것 같은데..
        //일단 공유회의 발표가 급하니 그 후에 방법을 찾아보기로..
        NSLayoutConstraint.activate([
            self.slideshow.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            self.slideshow.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
            self.slideshow.topAnchor.constraint(
                equalTo: self.view.safeAreaLayoutGuide.topAnchor,
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
        
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(StyleTabPostDetailViewController.didTap))
        slideshow.addGestureRecognizer(recognizer)
    }
    
    func setUpData() {
        self.idLabel.text = self.viewModel.getUserId()
        self.contentLabel.text = self.viewModel.getContent()
        self.contentLabel.text = testString
//        let newSize = contentLabel.sizeThatFits( CGSize(width: contentLabel.frame.width, height: CGFloat.greatestFiniteMagnitude))
//        self.contentLabel.frame.size.height = newSize.height
        self.contentLabel.sizeToFit()

    }

    
    @objc func didTap() {
        let fullScreenController = slideshow.presentFullScreenController(from: self)
        // set the activity indicator for full screen controller (skipping the line will show no activity indicator)
        fullScreenController.slideshow.activityIndicator = DefaultActivityIndicator(style: .white, color: nil)
    }
}
