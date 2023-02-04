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
        //self.userInfoVM.requestData(myShopType: .purchase)
        //self.userInfoVM.requestData(myShopType: .sale)
        //self.userInfoVM.requestWishData()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let followerBar = MyTabSharedUIStackVIew(title1: "일반 회원", subtitle1: "회원등급", title2: "0P", subtitle2: "포인트", title3: "0", subtitle3: "관심 상품", setCount: 3)
    
    
    override func viewDidLoad() {
        setUpBackButton()
        setUpBackButton()
        self.view.backgroundColor = .white
        addSubviews()
        setUpSubviews()
        setupPurchaseButton()
        setupSalesButton()
        //bind()
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
        self.salesButton.layer.masksToBounds = true
        
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
    
    //API랑 연결 끊음.
    /*
    func bind(){
        self.userInfoVM.salesProductCountObservable.subscribe { [weak self] count in
            self?.salesNumber.text = "\(count.element ?? 0)"
        }
        .disposed(by: bag)
        
        self.userInfoVM.purchasedProductsCountObservable.subscribe { [weak self] count in
            self?.purchaseNumber.text = "\(count.element ?? 0)"
        }
        .disposed(by: bag)
        
        self.userInfoVM.wishDataCountObservable.subscribe { [weak self] count in
            self?.followerBar.changeWishNumberCount(newString: "\(count.element ?? 0)")
        }
    }*/
    
    func addNumberLabels(){
        self.purchaseNumber.translatesAutoresizingMaskIntoConstraints = false
        self.purchaseNumber.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        self.purchaseNumber.text = "0"
        self.purchaseNumber.textColor = colors.errorRed
        self.purchaseButton.addSubview(purchaseNumber)
        
        let subLabel_1 = UILabel()
        subLabel_1.text = "전체"
        subLabel_1.font = UIFont.systemFont(ofSize: 13, weight: .light)
        subLabel_1.translatesAutoresizingMaskIntoConstraints = false
        self.purchaseButton.addSubview(subLabel_1)
        NSLayoutConstraint.activate([
            self.purchaseNumber.leadingAnchor.constraint(equalTo: self.purchaseButton.leadingAnchor, constant: self.view.frame.width/8),
            self.purchaseNumber.topAnchor.constraint(equalTo: self.purchaseButton.topAnchor, constant: self.view.frame.height/20),
            subLabel_1.centerXAnchor.constraint(equalTo: self.purchaseNumber.centerXAnchor),
            subLabel_1.bottomAnchor.constraint(equalTo: self.purchaseNumber.topAnchor, constant: -10)
        ])
        
        let subLabel_2 = UILabel()
        subLabel_2.text = "전체"
        subLabel_2.font = UIFont.systemFont(ofSize: 13, weight: .light)
        self.salesButton.addSubview(subLabel_2)
        subLabel_2.translatesAutoresizingMaskIntoConstraints = false
        self.salesNumber.translatesAutoresizingMaskIntoConstraints = false
        self.salesNumber.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        self.salesNumber.textColor = colors.accentGreen
        self.salesButton.addSubview(salesNumber)
        self.salesButton.setupCornerRadius(10)
        self.salesNumber.text = "0"
        NSLayoutConstraint.activate([
            self.salesNumber.leadingAnchor.constraint(equalTo: self.salesButton.leadingAnchor, constant: self.view.frame.width/8),
            self.salesNumber.topAnchor.constraint(equalTo: self.salesButton.topAnchor, constant: self.view.frame.height/20),
            subLabel_2.centerXAnchor.constraint(equalTo: self.salesNumber.centerXAnchor),
            subLabel_2.bottomAnchor.constraint(equalTo: self.salesNumber.topAnchor, constant: -10)
        ])
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.followerBar.layer.addBorder([.bottom], color: colors.lightGray, width: 1.0)
    }
    
}
