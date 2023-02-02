//
//  ProductDetailViewController.swift
//  KreamWaffleApp
//
//  Created by 이선재 on 2022/12/26.
//
import UIKit
import ImageSlideshow

class ProductDetailViewController: UIViewController, UISheetPresentationControllerDelegate {
    private let viewModel: ShopTabDetailViewModel
    
    //main views
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let slideshow = ImageSlideshow()
    
    let brandLabel = UILabel()
    let eng_nameLabel = UILabel()
    let kor_nameLabel = UILabel()
    var sizeField : ShoeSizefield?
//    let sizeButton = UIButton()
    let priceLabel = UILabel()
    let priceSubLabel = UILabel()
    
    var bookmarkCount = Int()
    var purchasePrice = Int()
    var sellPrice = Int()
    
    let bookmarkButton = UIButton()
    let purchaseButton = UIButton()
    let sellButton = UIButton()
    
    // font sizes
    let h1FontSize: CGFloat = 18 // brandLabel, priceLabel
    let h2FontSize: CGFloat = 16 // eng_nameLabel
    let h3FontSize: CGFloat = 14 // kor_nameLabel, priceSubLabel
    let h4FontSize: CGFloat = 13 // priceSubLabel
    let mainFontColor: UIColor = .black
    let subFontColor: UIColor = .darkGray
    let marginConstant: CGFloat = 15
    
    // other variables
    private var imageHeight = CGFloat()
    
    init(viewModel: ShopTabDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        addSubviews()
    }
    
    override func loadView() {
        self.view = UIView()
        configure()
        applyDesign()
        setUpSlideshow()
        
//        setupImageView()
        setupBrandLabel()
        setupeng_nameLabel()
        setupkor_nameLabel()
        
        setupShoeSizeField()
//        setupSizeButton()
        
        setupPriceLabel()
    }
    
    private func addSubviews() {
//        self.view.addSubview(scrollView)
//        self.scrollView.addSubview(cate)
    }

    
    private func configure() {
        imageHeight = CGFloat(viewModel.getThumbnailImageRatio()) * (self.view.bounds.width)

        self.brandLabel.text = "\(self.viewModel.getBrand())"
        self.eng_nameLabel.text = self.viewModel.getEngName()
        self.kor_nameLabel.text = self.viewModel.getKorName()
        self.priceLabel.text = "\(self.viewModel.getPrice())원"
//        self.bookmarkCount = self.viewModel.getTotalWishes()
//        self.purchasePrice = self.viewModel.price
    }
    
    private func applyDesign() {
        self.view.backgroundColor = .white
//        self.contentView.layer.cornerRadius = 20.0
//        self.contentView.isOpaque = true
    }
    
    private func setUpSlideshow() {
        configureSlideshow()
        setUpSlideshowData()
        
        self.view.addSubview(self.slideshow)
        slideshow.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.slideshow.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            self.slideshow.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
            self.slideshow.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            self.slideshow.heightAnchor.constraint(equalToConstant: 400),
//            self.slideshow.heightAnchor.constraint(equalToConstant: imageHeight),
        ])
    }
    
    func configureSlideshow() {
        if (viewModel.getImageSources().count > 1) {
            self.slideshow.pageIndicatorPosition = .init(horizontal: .center, vertical: .under)
            self.slideshow.contentScaleMode = UIViewContentMode.scaleAspectFit
            self.slideshow.circular = false
            
            let pageControl = UIPageControl()
            pageControl.currentPageIndicatorTintColor = UIColor.black
            pageControl.pageIndicatorTintColor = UIColor.lightGray
            self.slideshow.pageIndicator = pageControl
        }
    }
    
    func setUpSlideshowData() {
        let imageSources = self.viewModel.getImageSources().map {
            KingfisherSource(urlString: $0.url)!
        }
        self.slideshow.setImageInputs(imageSources)
        
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(slideShowTapped))
        slideshow.addGestureRecognizer(recognizer)
    }
    
//    private func setupImageView() {
//        self.imageView.sizeToFit()
//        self.imageView.contentMode = .scaleAspectFill
//        self.imageView.backgroundColor = .lightGray
//
//        self.view.addSubview(self.imageView)
//        self.imageView.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate([
//            self.imageView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
//            self.imageView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
//            self.imageView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
////            self.imageView.bottomAnchor.constraint(equalTo: self.imageView.topAnchor, constant: 150)
//        ])
//    }
    
    private func setupBrandLabel() {
        self.brandLabel.font = UIFont.boldSystemFont(ofSize: self.h1FontSize)
        self.brandLabel.textColor = self.mainFontColor
        self.brandLabel.numberOfLines = 1
        self.brandLabel.lineBreakMode = .byTruncatingTail
//        self.brandLabel.textAlignment = .left
        self.brandLabel.adjustsFontSizeToFitWidth = false
        
        self.view.addSubview(self.brandLabel)
        brandLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            brandLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            brandLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: self.marginConstant),
            brandLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -self.marginConstant),
            brandLabel.topAnchor.constraint(equalTo: self.slideshow.bottomAnchor, constant: 20),
//            brandLabel.bottomAnchor.constraint(equalTo: self.brandLabel.topAnchor, constant: 14)
        ])
    }
    
    private func setupeng_nameLabel() {
        self.eng_nameLabel.font = UIFont.systemFont(ofSize: self.h2FontSize)
        self.eng_nameLabel.textColor = self.mainFontColor
        self.eng_nameLabel.numberOfLines = 0
        self.eng_nameLabel.lineBreakMode = .byWordWrapping
//        self.eng_nameLabel.textAlignment = .left
        self.eng_nameLabel.adjustsFontSizeToFitWidth = false
        
        
        self.view.addSubview(self.eng_nameLabel)
        eng_nameLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            eng_nameLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            eng_nameLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: self.marginConstant),
            eng_nameLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -self.marginConstant),
            eng_nameLabel.topAnchor.constraint(equalTo: self.brandLabel.bottomAnchor, constant: 5),
//            eng_nameLabel.bottomAnchor.constraint(equalTo: self.eng_nameLabel.topAnchor, constant: 30)
        ])
    }
    
    private func setupkor_nameLabel() {
        self.kor_nameLabel.font = UIFont.systemFont(ofSize: self.h3FontSize)
        self.kor_nameLabel.textColor = self.subFontColor
        self.kor_nameLabel.numberOfLines = 0
        self.kor_nameLabel.lineBreakMode = .byWordWrapping
//        self.kor_nameLabel.textAlignment = .left
        self.kor_nameLabel.adjustsFontSizeToFitWidth = false
        
        
        self.view.addSubview(self.kor_nameLabel)
        kor_nameLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            kor_nameLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            kor_nameLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: self.marginConstant),
            kor_nameLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -self.marginConstant),
            kor_nameLabel.topAnchor.constraint(equalTo: self.eng_nameLabel.bottomAnchor, constant: 2),
//            kor_nameLabel.bottomAnchor.constraint(equalTo: self.kor_nameLabel.topAnchor, constant: 30)
        ])
    }
    
    private func setupShoeSizeField() {
        self.sizeField = ShoeSizefield(selectedSize: nil)
        self.view.addSubview(sizeField!)
        self.sizeField?.translatesAutoresizingMaskIntoConstraints = false
        self.sizeField?.topAnchor.constraint(equalTo: self.kor_nameLabel.bottomAnchor, constant: 30).isActive = true
        self.sizeField?.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20).isActive = true
        self.sizeField?.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20).isActive = true
        self.sizeField?.heightAnchor.constraint(greaterThanOrEqualToConstant: 50).isActive = true
        self.sizeField?.button.addTarget(self, action: #selector(didTapSelectShoeSize), for: .touchUpInside)
    }
    
//    private func setupSizeButton() {
//        // Setup button text
//        self.sizeButton.setTitle("모든 사이즈", for: .normal)
//        self.sizeButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: self.h2FontSize)
//        self.sizeButton.setTitleColor(self.mainFontColor, for: .normal)
//        self.sizeButton.contentHorizontalAlignment = .left
//
//        // Setup button image
//        self.sizeButton.setImage(UIImage(systemName: "arrowtriangle.down.circle"), for: .normal)
//        self.sizeButton.tintColor = self.mainFontColor
//        self.sizeButton.semanticContentAttribute = .forceRightToLeft // puts image right of text
//
//        // Setup button border
//        self.sizeButton.layer.borderColor = self.subFontColor.cgColor
//        self.sizeButton.layer.borderWidth = 1
//        self.sizeButton.layer.cornerRadius = 5
//
//        self.sizeButton.addTarget(self, action: #selector(tappedSizeButton), for: .touchUpInside)
//
//        self.view.addSubview(self.sizeButton)
//        self.sizeButton.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate([
//            sizeButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
//            sizeButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: self.marginConstant),
//            sizeButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -self.marginConstant),
//            sizeButton.topAnchor.constraint(equalTo: self.kor_nameLabel.bottomAnchor, constant: 20),
////            priceLabel.bottomAnchor.constraint(equalTo: self.priceLabel.topAnchor, constant: 30)
//        ])
//    }
    
    private func setupPriceLabel() {
        self.priceLabel.font = UIFont.boldSystemFont(ofSize: self.h1FontSize)
        self.priceLabel.textColor = self.mainFontColor
        self.priceLabel.lineBreakMode = .byWordWrapping
        self.priceLabel.numberOfLines = 1
        self.priceLabel.textAlignment = .right
        self.priceLabel.adjustsFontSizeToFitWidth = true
        
        self.view.addSubview(self.priceLabel)
        priceLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            priceLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            priceLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: self.marginConstant),
            priceLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -self.marginConstant),
            priceLabel.topAnchor.constraint(equalTo: self.sizeField!.bottomAnchor, constant: 20),
//            priceLabel.bottomAnchor.constraint(equalTo: self.priceLabel.topAnchor, constant: 30)
        ])
        
        self.priceSubLabel.text = "최근 거래가"
        self.priceSubLabel.font = UIFont.systemFont(ofSize: self.h4FontSize)
        self.priceSubLabel.textColor = self.subFontColor
        
        self.view.addSubview(self.priceSubLabel)
        self.priceSubLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.priceSubLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.priceSubLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: self.marginConstant),
            self.priceSubLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -self.marginConstant),
            self.priceSubLabel.topAnchor.constraint(equalTo: self.sizeField!.bottomAnchor, constant: 20),
//            priceSubLabel.bottomAnchor.constraint(equalTo: self.priceLabel.topAnchor, constant: 30)
        ])
    }
    
    @objc func slideShowTapped() {
        let fullScreenController = slideshow.presentFullScreenController(from: self)
        fullScreenController.slideshow.activityIndicator = DefaultActivityIndicator(style: .medium, color: nil)
    }
    
    @objc func didTapSelectShoeSize() {
        var productSizeList = [230, 235, 240]
        
        let productSizeSelectionVC = ShoeSizeSelectionViewController(viewModel: nil, loginVM: nil)
        productSizeSelectionVC.modalPresentationStyle = .pageSheet
        
        if let sheet = productSizeSelectionVC.sheetPresentationController {
            //지원할 크기 지정
            sheet.detents = [.medium()]
            //크기 변하는거 감지
            sheet.delegate = self
                   
            //시트 상단에 그래버 표시 (기본 값은 false)
            sheet.prefersGrabberVisible = true
                    
            //처음 크기 지정 (기본 값은 가장 작은 크기)
            //sheet.selectedDetentIdentifier = .large
                    
            //뒤 배경 흐리게 제거 (기본 값은 모든 크기에서 배경 흐리게 됨)
            //sheet.largestUndimmedDetentIdentifier = .medium
        }
        
        self.present(productSizeSelectionVC, animated: true, completion: nil)
    }

    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
