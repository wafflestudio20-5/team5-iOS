//
//  SettingsViewController.swift
//  KreamWaffleApp
//
//  Created by grace kim  on 2023/01/27.
//

import UIKit

class SettingsViewController: UIViewController {
    
    var viewModel : EditAccountViewModel?
    
    var logoutButton = UIButton()
    var divider = UILabel()
    var deleteUserButton = UIButton()
    
    //2개인데 꼭 테이블뷰가 필요할까?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.setUpBackButton()
        self.title = "설정"
        self.view.addSubview(logoutButton)
        self.view.addSubview(divider)
        self.view.addSubview(deleteUserButton)
        setupInfoButton()
        setupLogoutButton()
    }
    
    init(viewModel: EditAccountViewModel){
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupInfoButton(){
        self.logoutButton.setTitle("로그인 정보", for: .normal)
        self.logoutButton.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.left
        self.logoutButton.contentVerticalAlignment = UIControl.ContentVerticalAlignment.top
        self.logoutButton.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        self.logoutButton.backgroundColor = .white
        self.logoutButton.setTitleColor(.black, for: .normal)
        self.logoutButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.logoutButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20),
            self.logoutButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20),
            self.logoutButton.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 10)
        ])
        self.logoutButton.addTarget(self, action: #selector(didTapEdit), for: .touchUpInside)
    }
    
    func setupLogoutButton(){
        self.divider.backgroundColor = colors.lessLightGray
        self.divider.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.divider.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20),
            self.divider.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20),
            self.divider.heightAnchor.constraint(equalToConstant: 0.7),
            self.divider.topAnchor.constraint(equalTo: self.logoutButton.bottomAnchor, constant: 10)
        ])
        
        self.deleteUserButton.setTitle("로그아웃", for: .normal)
        self.deleteUserButton.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.left
        self.deleteUserButton.contentVerticalAlignment = UIControl.ContentVerticalAlignment.top
        self.deleteUserButton.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        self.deleteUserButton.backgroundColor = .white
        self.deleteUserButton.setTitleColor(colors.errorRed, for: .normal)
        self.deleteUserButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.deleteUserButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20),
            self.deleteUserButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20),
            self.deleteUserButton.topAnchor.constraint(equalTo: self.divider.bottomAnchor, constant: 10)
        ])
        self.deleteUserButton.addTarget(self, action: #selector(didTapLogout), for: .touchUpInside)
    }
    
    @objc
    func didTapLogout(){
        self.viewModel?.logout()
        self.navigationController?.popViewController(animated: false)
    }
    
    @objc
    func didTapEdit(){
        let editVC = LoginSettingsEditViewController(viewModel: self.viewModel!)
        self.navigationController?.pushViewController(editVC, animated: true)
    }
}
