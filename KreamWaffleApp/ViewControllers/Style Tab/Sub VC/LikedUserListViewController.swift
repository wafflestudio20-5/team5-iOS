//
//  LikedUsersViewController.swift
//  KreamWaffleApp
//
//  Created by 최성혁 on 2023/01/19.
//

import Foundation
import UIKit

final class LikedUserListViewController: UIViewController {
    private let userListCollectionViewVC: UserListCollectionViewVC
    private let userInfoViewModel: UserInfoViewModel
    
    init(id: Int, userInfoViewModel: UserInfoViewModel) {
        self.userInfoViewModel = userInfoViewModel
        
        let repository = LikedUserListRepository()
        let usecase = UserListUsecase(userListRepository: repository)
        self.userListCollectionViewVC = UserListCollectionViewVC(id: id, userListViewModel: UserListViewModel(userListUsecase: usecase), userInfoViewModel: self.userInfoViewModel)
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        self.view.backgroundColor = .white
        setUpNavigationBar()
        setUpChildVC()
    }
    
    func setUpNavigationBar() {
        self.navigationItem.title = "공감"
        self.setUpBackButton()
    }
    
    func setUpChildVC() {
        self.view.addSubview(userListCollectionViewVC.view)
        self.addChild(userListCollectionViewVC)
        userListCollectionViewVC.didMove(toParent: self)
        
        userListCollectionViewVC.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.userListCollectionViewVC.view.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 0),
            self.userListCollectionViewVC.view.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: 0),
            self.userListCollectionViewVC.view.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 0),
            self.userListCollectionViewVC.view.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: 0),
        ])
    }
}
