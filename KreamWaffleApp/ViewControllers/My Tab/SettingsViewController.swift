//
//  SettingsViewController.swift
//  KreamWaffleApp
//
//  Created by grace kim  on 2023/01/27.
//

import UIKit

class SettingsViewController: UIViewController {
    
    var viewModel : LoginViewModel?
    
    //임시 로그아웃 버튼 (테이블 뷰로 바꿀 예정)
    var logoutButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.setUpBackButton()
        self.title = "설정"
        self.view.addSubview(logoutButton)
        setupLogoutButton()
    }
    
    init(viewModel: LoginViewModel){
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupLogoutButton(){
        self.logoutButton.setTitle("로그아웃", for: .normal)
        self.logoutButton.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        self.logoutButton.backgroundColor = .white
        self.logoutButton.setTitleColor(.red, for: .normal)
        self.logoutButton.translatesAutoresizingMaskIntoConstraints = false
        self.logoutButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        self.logoutButton.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        self.logoutButton.addTarget(self, action: #selector(didTapLogout), for: .touchUpInside)
    }
    
    @objc
    func didTapLogout(){
        self.viewModel?.logout()
        self.navigationController?.popViewController(animated: false)
    }
}
