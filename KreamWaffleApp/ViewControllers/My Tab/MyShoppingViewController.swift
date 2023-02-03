//
//  ProfileViewController.swift
//  KreamWaffleApp
//
//  Created by grace kim  on 2023/01/02.
//
import UIKit
import RxSwift

class MyShoppingViewController: UIViewController {
    private let userInfoVM: UserInfoViewModel
    let bag = DisposeBag()
    
    var purchaseTitle = UILabel()
    var purchaseButton = UIButton()
    var purchaseLabel = UILabel()
    var purchaseNumber = UILabel()
    var divider = UILabel()
    
    var salesTitle = UILabel()
    var salesButton = UILabel()
    var salesNumber = UILabel()
    
    
    init(userInfoVM: UserInfoViewModel) {
        self.userInfoVM = userInfoVM
        super.init(nibName: nil, bundle: nil)
        self.userInfoVM.requestData(myShopType: .purchase)
        self.userInfoVM.requestData(myShopType: .sale)
        self.userInfoVM.requestWishData()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let followerBar = MyTabSharedUIStackVIew(title1: "일반 회원", subtitle1: "회원등급", title2: "0P", subtitle2: "포인트", title3: "14", subtitle3: "관심 상품", setCount: 3)
    
    
    override func viewDidLoad() {
        setUpBackButton()
        setUpBackButton()
        self.view.backgroundColor = .white
        addSubviews()
        setUpSubviews()
        setupPurchaseButton()
        setupSalesButton()
        bind()
        addNumberLabels()
    }
    
    func addSubviews(){
        self.view.addSubview(followerBar)
        self.view.addSubview(purchaseTitle)
        self.view.addSubview(purchaseButton)
        self.view.addSubview(salesTitle)
        self.view.addSubview(salesButton)
    }
    
    func setUpSubviews(){
        self.followerBar.translatesAutoresizingMaskIntoConstraints = false
        self.followerBar.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0).isActive = true
        self.followerBar.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0).isActive = true
        self.followerBar.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        self.followerBar.heightAnchor.constraint(equalToConstant: self.view.frame.height/16).isActive = true
    }
    
    func setupPurchaseButton(){
        self.purchaseTitle.text = "구매내역"
        self.purchaseTitle.textColor = .black
        self.purchaseTitle.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        
        self.purchaseButton.backgroundColor = colors.lessLightGray
        self.purchaseButton.layer.cornerRadius = 10
        
        self.purchaseTitle.translatesAutoresizingMaskIntoConstraints = false
        self.purchaseButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.purchaseTitle.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 10),
            self.purchaseTitle.topAnchor.constraint(equalTo: self.followerBar.bottomAnchor, constant: 20),
            
            self.purchaseButton.leadingAnchor.constraint(equalTo: self.purchaseTitle.leadingAnchor),
            self.purchaseButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -10),
            self.purchaseButton.heightAnchor.constraint(equalToConstant: self.view.frame.height/10),
            self.purchaseButton.topAnchor.constraint(equalTo: purchaseTitle.bottomAnchor, constant: 10)
        ])
    }
    
    func setupSalesButton(){
        self.salesTitle.text = "판매내역"
        self.salesTitle.textColor = .black
        self.salesTitle.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        
        self.salesButton.backgroundColor = colors.lessLightGray
        self.salesButton.layer.cornerRadius = 10
        
        self.salesTitle.translatesAutoresizingMaskIntoConstraints = false
        self.salesButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.salesTitle.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 10),
            self.salesTitle.topAnchor.constraint(equalTo: self.purchaseButton.bottomAnchor, constant: 30),
            
            self.salesButton.leadingAnchor.constraint(equalTo: self.salesTitle.leadingAnchor),
            self.salesButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -10),
            self.salesButton.heightAnchor.constraint(equalToConstant: self.view.frame.height/10),
            self.salesButton.topAnchor.constraint(equalTo: salesTitle.bottomAnchor, constant: 10)
        ])
    }
    
    func bind(){
        self.userInfoVM.salesProductCountObservable.subscribe { [weak self] count in
            self?.salesNumber.text = "\(count.element ?? 0), (디자인 수정 예정)"
        }
        .disposed(by: bag)
        
        self.userInfoVM.purchasedProductsCountObservable.subscribe { [weak self] count in
            self?.purchaseNumber.text = "\(count.element ?? 0), (디자인 수정 예정)"
        }
        .disposed(by: bag)
        
        self.userInfoVM.wishDataCountObservable.subscribe { [weak self] count in
            self?.followerBar.title3 = "\(count.element ?? 0)"
        }
    }
    
    func addNumberLabels(){
        self.purchaseNumber.translatesAutoresizingMaskIntoConstraints = false
        self.purchaseButton.addSubview(purchaseNumber)
        NSLayoutConstraint.activate([
            self.purchaseNumber.centerXAnchor.constraint(equalTo: self.purchaseButton.centerXAnchor),
            self.purchaseNumber.centerYAnchor.constraint(equalTo: self.purchaseButton.centerYAnchor)
        ])
        
        self.salesNumber.translatesAutoresizingMaskIntoConstraints = false
        self.salesButton.addSubview(salesNumber)
        NSLayoutConstraint.activate([
            self.salesNumber.centerXAnchor.constraint(equalTo: self.salesButton.centerXAnchor),
            self.salesNumber.centerYAnchor.constraint(equalTo: self.salesButton.centerYAnchor)
        ])
    }
    
    func titleLabel(title: String) -> UILabel{
        let label = UILabel()
        label.text = title
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        return label
    }
    
    func subtitleLabel(title: String) -> UILabel{
        let label = UILabel()
        label.text = title
        label.textColor = .darkGray
        label.font = UIFont.systemFont(ofSize: 13, weight: .medium)
        return label
    }
    
    func miniStackView(subviews: [UILabel]) -> UIStackView{
        let view = UIStackView()
        view.addArrangedSubviews(subviews)
        view.axis = .vertical
        view.alignment = .center
        view.spacing = 5
        return view
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.followerBar.layer.addBorder([.bottom], color: colors.lightGray, width: 1.0)
    }
    
}
