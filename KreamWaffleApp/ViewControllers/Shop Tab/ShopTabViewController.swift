//
//  ShopTabViewController.swift
//  KreamWaffleApp
//
//  Created by 이선재 on 2022/12/24.
//

import UIKit
import RxSwift
import RxCocoa

class ShopTabViewController: UIViewController {
    //서치하지 않을때 서치할때 아래 view controller 를 갈아끼우기
    
    private let bag = DisposeBag()
    private var searchVC : SearchViewController
    private var shopVC : ShopMainViewController
    
    var header = UIView()
    var searchBar = UISearchBar()
    
    init(){
        self.searchVC = SearchViewController()
        self.shopVC = ShopMainViewController()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addSubviews()
        configureSubviews()
    }
    
    func addSubviews(){
        self.view.addSubview(searchBar)
    }
    
    func configureSubviews(){
        configureSearchBar()
        configureChildVC()
    }
    
    func configureChildVC(){
        self.add(searchVC)
        self.searchVC.view.frame = CGRect(x: 0, y: self.searchBar.frame.maxY, width: self.view.frame.width, height: self.view.frame.height)
        self.add(shopVC)
        self.shopVC.view.frame = CGRect(x: 0, y: self.searchBar.frame.maxY, width: self.view.frame.width, height: self.view.frame.height)
        searchVC.view.isHidden = true
        
        
    }
    
    func configureSearchBar(){
        self.searchBar.frame = CGRect(x: 0, y: 0, width: view.frame.width - 80, height: 0)
        self.searchBar.searchTextField.addTarget(self, action: #selector(didTapSearchBar), for: .editingDidBegin)
        
        self.navigationItem.titleView = self.searchBar
        self.navigationItem.titleView?.backgroundColor = .white
        let emptyImage = UIImage()
        self.searchBar.setImage(emptyImage, for: .search, state: .normal)
        self.searchBar.searchTextField.attributedPlaceholder = NSAttributedString(string: "브랜드명, 모델명, 모델번호 등", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14, weight: .light)])
        self.searchBar.searchTextField.textColor = .black
        self.searchBar.layer.borderColor = UIColor.clear.cgColor
        self.searchBar.searchTextField.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        print(self.searchBar.frame)
    }
    
    @objc func didTapSearchBar(){
        let cancelButton = UIBarButtonItem(title: "취소", style: .plain, target: self, action: #selector(didTapCancelSearchBar))
        cancelButton.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15, weight: .medium)], for: .normal)
        self.navigationItem.rightBarButtonItem = cancelButton
        self.searchVC.view.isHidden = false
        self.shopVC.view.isHidden = true
        returnViewToInitialFrame()
    }
    
    @objc func didTapCancelSearchBar(){
        self.navigationItem.rightBarButtonItem = nil
        self.searchBar.endEditing(true)
        returnViewToInitialFrame()
        self.searchVC.view.isHidden = true
        self.shopVC.view.isHidden = false
    }
    
    func returnViewToInitialFrame(){
        var initialViewRect : CGRect
        if (self.searchBar.searchTextField.isEditing){
            initialViewRect = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 0)
        }else{
            initialViewRect = CGRect(x: 0, y: 0, width: view.frame.width-50, height: 0)
        }
        
        if (!initialViewRect.equalTo(self.searchBar.frame))
        {
            UIView.animate(withDuration: 0.3, animations: {
                self.searchBar.frame = initialViewRect
            })
        }
    }
        
    
   
}
