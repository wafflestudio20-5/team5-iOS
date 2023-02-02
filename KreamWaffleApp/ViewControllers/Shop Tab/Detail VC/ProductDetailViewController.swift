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
    var sizeField : ShopDetailSizefield?
//    let sizeButton = UIButton()
    let priceLabel = UILabel()
    let priceSubLabel = UILabel()
    
    var bookmarkCount = Int()
    var purchasePrice = Int()
    var sellPrice = Int()
    
    // bottom toolbar
    let bottomBar = UIView()
    let bookmarkButton = UIView()
    let purchaseButton = UIView()
    let sellButton = UIView()
    
    // font sizes
    let h1FontSize: CGFloat = 18 // brandLabel, priceLabel
    let h2FontSize: CGFloat = 16 // eng_nameLabel
    let h3FontSize: CGFloat = 14 // kor_nameLabel, priceSubLabel
    let h4FontSize: CGFloat = 13 // priceSubLabel
    let mainFontColor: UIColor = .black
    let subFontColor: UIColor = .darkGray
//    let bottomBarSubColor: UIColor = UIColor(red: 0.5412, green: 0.2588, blue: 0.2275, alpha: 1.0)
    let marginConstant: CGFloat = 15
    
    // other variables
    private var imageHeight = CGFloat()
    
    init(viewModel: ShopTabDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = UIView()
        configure()
        applyDesign()
        
        addSubviews()
        setUpScrollView()
        
        setUpSlideshow()
        setupBrandLabel()
        setupeng_nameLabel()
        setupkor_nameLabel()
        setupShoeSizeField()
        setupPriceLabel()
        
        setUpBottomBar()
        
        addGestures()
    }
    
    private func configure() {
        imageHeight = CGFloat(viewModel.getThumbnailImageRatio()) * (self.view.bounds.width)

        self.brandLabel.text = "\(self.viewModel.getBrand())"
        self.eng_nameLabel.text = self.viewModel.getEngName()
        self.kor_nameLabel.text = self.viewModel.getKorName()
        
        let formattedPrice = PriceFormatter.formatNumberToCurrency(intToFormat: self.viewModel.getPrice())
        self.priceLabel.text = "\(formattedPrice)원"
//        self.bookmarkCount = self.viewModel.getTotalWishes()
//        self.purchasePrice = self.viewModel.price
    }
    
    private func applyDesign() {
        self.view.backgroundColor = .white
//        self.contentView.layer.cornerRadius = 20.0
//        self.contentView.isOpaque = true
        
    }
    
    private func addSubviews() {
        self.view.addSubviews(scrollView, bottomBar)
        self.scrollView.addSubview(contentView)
        self.contentView.addSubviews(slideshow, brandLabel, eng_nameLabel, kor_nameLabel, priceLabel, priceSubLabel)
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
    
    private func setUpSlideshow() {
        configureSlideshow()
        setUpSlideshowData()
        
        slideshow.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.slideshow.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            self.slideshow.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            self.slideshow.topAnchor.constraint(equalTo: contentView.topAnchor),
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
            KingfisherSource(urlString: $0)!
        }
        self.slideshow.setImageInputs(imageSources)
        
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(slideShowTapped))
        slideshow.addGestureRecognizer(recognizer)
    }
    
    private func setupBrandLabel() {
        self.brandLabel.font = UIFont.systemFont(ofSize: self.h1FontSize, weight: .black)
        self.brandLabel.textColor = self.mainFontColor
        self.brandLabel.numberOfLines = 1
        self.brandLabel.lineBreakMode = .byTruncatingTail
//        self.brandLabel.textAlignment = .left
        self.brandLabel.adjustsFontSizeToFitWidth = false
        
//        self.view.addSubview(self.brandLabel)
        brandLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            brandLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            brandLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: self.marginConstant),
            brandLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -self.marginConstant),
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
        
        
//        self.view.addSubview(self.eng_nameLabel)
        eng_nameLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            eng_nameLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            eng_nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: self.marginConstant),
            eng_nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -self.marginConstant),
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
        
        
//        self.view.addSubview(self.kor_nameLabel)
        kor_nameLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            kor_nameLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            kor_nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: self.marginConstant),
            kor_nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -self.marginConstant),
            kor_nameLabel.topAnchor.constraint(equalTo: self.eng_nameLabel.bottomAnchor, constant: 2),
//            kor_nameLabel.bottomAnchor.constraint(equalTo: self.kor_nameLabel.topAnchor, constant: 30)
        ])
    }
    
    private func setupShoeSizeField() {
        self.sizeField = ShopDetailSizefield(selectedSize: nil)
//        self.view.addSubview(sizeField!)
        self.contentView.addSubview(sizeField!)
        self.sizeField?.translatesAutoresizingMaskIntoConstraints = false
        
        self.sizeField?.topAnchor.constraint(equalTo: self.kor_nameLabel.bottomAnchor, constant: 20).isActive = true
        self.sizeField?.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: self.marginConstant).isActive = true
        self.sizeField?.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -self.marginConstant).isActive = true
        self.sizeField?.heightAnchor.constraint(greaterThanOrEqualToConstant: 50).isActive = true
        self.sizeField?.button.addTarget(self, action: #selector(didTapSelectSize), for: .touchUpInside)
    }
    
    private func setupPriceLabel() {
        self.priceLabel.font = UIFont.systemFont(ofSize: self.h1FontSize, weight: .black)
        self.priceLabel.textColor = self.mainFontColor
        self.priceLabel.lineBreakMode = .byWordWrapping
        self.priceLabel.numberOfLines = 1
        self.priceLabel.textAlignment = .right
        self.priceLabel.adjustsFontSizeToFitWidth = true
        
//        self.view.addSubview(self.priceLabel)
        priceLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            priceLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            priceLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: self.marginConstant),
            priceLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -self.marginConstant),
            priceLabel.topAnchor.constraint(equalTo: self.sizeField!.bottomAnchor, constant: 10),
//            priceLabel.bottomAnchor.constraint(equalTo: self.priceLabel.topAnchor, constant: 30)
        ])
        
        self.priceSubLabel.text = "최근 거래가"
        self.priceSubLabel.font = UIFont.systemFont(ofSize: self.h4FontSize)
        self.priceSubLabel.textColor = self.subFontColor
        
//        self.view.addSubview(self.priceSubLabel)
        self.priceSubLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.priceSubLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            self.priceSubLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: self.marginConstant),
            self.priceSubLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -self.marginConstant),
            self.priceSubLabel.topAnchor.constraint(equalTo: self.sizeField!.bottomAnchor, constant: 10),
//            priceSubLabel.bottomAnchor.constraint(equalTo: self.priceLabel.topAnchor, constant: 30)
        ])
    }
    
    private func setUpBottomBar() {
        bottomBar.backgroundColor = colors.lightGray
        
        self.view.addSubview(bottomBar)
        self.bottomBar.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.bottomBar.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.bottomBar.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.bottomBar.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            self.bottomBar.topAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -95),
            self.bottomBar.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
        
        setUpBookmarkButton()
        setUpPurchaseButton()
        setUpSellButton()
        
    }
    
    private func setUpBookmarkButton() {
        self.bottomBar.addSubview(bookmarkButton)
        bookmarkButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.bookmarkButton.leadingAnchor.constraint(equalTo: bottomBar.leadingAnchor, constant: 10),
            self.bookmarkButton.trailingAnchor.constraint(equalTo: bottomBar.leadingAnchor, constant: 60),
            self.bookmarkButton.topAnchor.constraint(equalTo: bottomBar.topAnchor, constant: 13),
            self.bookmarkButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
        // image
        let imgView: UIImageView = {
            let imgView = UIImageView()
            imgView.image = UIImage(systemName: "bookmark")
//            imgView.backgroundColor = .red
            imgView.tintColor = .black
            return imgView
        }()
        
        self.bookmarkButton.addSubview(imgView)
        imgView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imgView.centerXAnchor.constraint(equalTo: bookmarkButton.centerXAnchor),
            imgView.topAnchor.constraint(equalTo: bookmarkButton.topAnchor, constant: 5),
        ])
        
        // label
        let label: UILabel = {
            let label = UILabel()
            label.text = "3.7만"
            label.textColor = .black
            label.font = UIFont.systemFont(ofSize: self.h4FontSize, weight: .regular)
            return label
        }()
        
        self.bookmarkButton.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: bookmarkButton.centerXAnchor),
            label.topAnchor.constraint(equalTo: imgView.bottomAnchor, constant: 1),
        ])
       
    }
    
    private func setUpPurchaseButton() {
        purchaseButton.backgroundColor = UIColor(red: 0.9373, green: 0.3843, blue: 0.3255, alpha: 1.0)
        purchaseButton.layer.cornerRadius = 10
        
        self.bottomBar.addSubview(purchaseButton)
        purchaseButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.purchaseButton.leadingAnchor.constraint(equalTo: bookmarkButton.trailingAnchor, constant: 10),
            self.purchaseButton.trailingAnchor.constraint(equalTo: bookmarkButton.trailingAnchor, constant: 150),
            self.purchaseButton.topAnchor.constraint(equalTo: bottomBar.topAnchor, constant: 10),
            self.purchaseButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
        
        // title label
        let titleLabel: UILabel = {
            let label = UILabel()
            label.text = "구매"
            label.textColor = .white
            label.font = UIFont.systemFont(ofSize: self.h2FontSize, weight: .bold)
            return label
        }()
        self.purchaseButton.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.centerYAnchor.constraint(equalTo: purchaseButton.centerYAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: purchaseButton.leadingAnchor, constant: 10),
        ])
        
        // price label
        let priceLabel: UILabel = {
            let label = UILabel()
            label.text = "10,000"
            label.textColor = .white
            label.font = UIFont.systemFont(ofSize: self.h3FontSize, weight: .bold)
            return label
        }()
        self.purchaseButton.addSubview(priceLabel)
        priceLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            priceLabel.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: 20),
            priceLabel.topAnchor.constraint(equalTo: purchaseButton.topAnchor, constant: 10),
        ])
        
        // sub price label
        let subPriceLabel: UILabel = {
            let label = UILabel()
            label.text = "즉시 구매가"
            label.textColor = UIColor(red: 0.5412, green: 0.2588, blue: 0.2275, alpha: 1.0)
            label.font = UIFont.systemFont(ofSize: self.h4FontSize - 2, weight: .regular)
            return label
        }()
        self.purchaseButton.addSubview(subPriceLabel)
        subPriceLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            subPriceLabel.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: 20),
            subPriceLabel.topAnchor.constraint(equalTo: priceLabel.bottomAnchor, constant: 2),
        ])
        
    }
    
    private func setUpSellButton() {
        sellButton.backgroundColor = UIColor(red: 0.2588, green: 0.7216, blue: 0.4745, alpha: 1.0)
        sellButton.layer.cornerRadius = 10
        
        self.bottomBar.addSubview(sellButton)
        sellButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.sellButton.leadingAnchor.constraint(equalTo: purchaseButton.trailingAnchor, constant: 10),
            self.sellButton.trailingAnchor.constraint(equalTo: bottomBar.trailingAnchor, constant: -10),
            self.sellButton.topAnchor.constraint(equalTo: bottomBar.topAnchor, constant: 10),
            self.sellButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
        // title label
        let titleLabel: UILabel = {
            let label = UILabel()
            label.text = "판매"
            label.textColor = .white
            label.font = UIFont.systemFont(ofSize: self.h2FontSize, weight: .bold)
            return label
        }()
        self.sellButton.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.centerYAnchor.constraint(equalTo: sellButton.centerYAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: sellButton.leadingAnchor, constant: 10),
        ])
        
        // price label
        let priceLabel: UILabel = {
            let label = UILabel()
            label.text = "10,000"
            label.textColor = .white
            label.font = UIFont.systemFont(ofSize: self.h3FontSize, weight: .bold)
            return label
        }()
        self.sellButton.addSubview(priceLabel)
        priceLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            priceLabel.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: 20),
            priceLabel.topAnchor.constraint(equalTo: sellButton.topAnchor, constant: 10),
        ])
        
        // sub price label
        let subPriceLabel: UILabel = {
            let label = UILabel()
            label.text = "즉시 판매가"
            label.textColor = UIColor(red: 0.1961, green: 0.4588, blue: 0.3176, alpha: 1.0)
            label.font = UIFont.systemFont(ofSize: self.h4FontSize - 2, weight: .regular)
            return label
        }()
        self.sellButton.addSubview(subPriceLabel)
        subPriceLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            subPriceLabel.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: 20),
            subPriceLabel.topAnchor.constraint(equalTo: priceLabel.bottomAnchor, constant: 2),
        ])
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addGestures() {
        let bookmarkButtonTapGesture = UITapGestureRecognizer(target: self, action: #selector(tappedBookmarkButton))
        bookmarkButtonTapGesture.numberOfTapsRequired = 1
        bookmarkButton.addGestureRecognizer(bookmarkButtonTapGesture)
    
        let purchaseButtonTapGesture = UITapGestureRecognizer(target: self, action: #selector(tappedPurchaseButton))
        purchaseButtonTapGesture.numberOfTapsRequired = 1
        purchaseButton.addGestureRecognizer(purchaseButtonTapGesture)
        
        let sellButtonTapGesture = UITapGestureRecognizer(target: self, action: #selector(tappedSellButton))
        sellButtonTapGesture.numberOfTapsRequired = 1
        sellButton.addGestureRecognizer(sellButtonTapGesture)
    
    }
}

extension ProductDetailViewController {
    @objc func slideShowTapped() {
        let fullScreenController = slideshow.presentFullScreenController(from: self)
        fullScreenController.slideshow.activityIndicator = DefaultActivityIndicator(style: .medium, color: nil)
    }
    
    @objc func didTapSelectSize() {
        self.sizeField?.setTextfield(SelectedSize: 240)
        let productSizeSelectionVC = ProductSizeSelectionViewController(viewModel: self.viewModel)
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
    
    @objc func tappedBookmarkButton() {
        print("tapped bookmark button")
    }
    
    @objc func tappedSellButton() {
        print("tapped sell button")
    }
    
    @objc func tappedPurchaseButton() {
        print("tapped purchase button")
    }
}

extension ProductDetailViewController {
    private func requestProductSizeInfo(id: Int) {
        self.viewModel.requestProductSizeInfo(id: id)
    }
}
