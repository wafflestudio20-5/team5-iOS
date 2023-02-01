//
//  UserListCollectionViewVC.swift
//  KreamWaffleApp
//
//  Created by 최성혁 on 2023/01/19.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

final class UserListCollectionViewVC: UIViewController {
    let userListViewModel: UserListViewModel
    let userInfoViewModel: UserInfoViewModel
    
    let collectionView: UICollectionView
    private let id: Int
    private let disposeBag = DisposeBag()
    
    private let collectionViewRefreshControl = UIRefreshControl()
    
    init(id: Int, userListViewModel: UserListViewModel, userInfoViewModel: UserInfoViewModel) {
        self.userListViewModel = userListViewModel
        self.userInfoViewModel = userInfoViewModel
        self.id = id
        
        collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UserListCollectionViewLayout())
        collectionView.backgroundColor = .white
        super.init(nibName: nil, bundle: nil)
        collectionView.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        self.view.backgroundColor = .white
        setUpCollectionView()
        bindCollectionView()
        setUpRefreshControl()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        requestInitialData()
    }
    
    func setUpCollectionView() {
        self.view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.collectionView.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor, constant: 0),
            self.collectionView.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor, constant: 0),
            self.collectionView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 0),
            self.collectionView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: 0),
        ])

    }
    
    func bindCollectionView() {
        collectionView.register(UserListCollectionViewCell.self, forCellWithReuseIdentifier: "UserListCollectionViewCell")

        userListViewModel.userListDataSource
            .bind(to: collectionView.rx.items(cellIdentifier: "UserListCollectionViewCell", cellType: UserListCollectionViewCell.self)) { index, item, cell in
                cell.configure(with: item)
                cell.followButton.tag = item.user_id
                cell.followButton.addTarget(self, action: #selector(self.requestFollow(sender:)), for: .touchUpInside)

            }
            .disposed(by: disposeBag)
    }
    
    private func setUpRefreshControl() {
        self.collectionViewRefreshControl.addTarget(self, action: #selector(refreshFunction), for: .valueChanged)
        self.collectionView.refreshControl = self.collectionViewRefreshControl
    }
    
    func requestInitialData() {
        Task {
            let isValidToken = await self.userInfoViewModel.checkAccessToken()
            if isValidToken {
                if let token = self.userInfoViewModel.UserResponse?.accessToken {
                    self.userListViewModel.requestInitialUserList(id: self.id, token: token)
                } else {
                    (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeToLoginVC()
                }
            } else {
                (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeToLoginVC()
            }
        }
        
    }
    
    func requestNextData() {
        Task {
            let isValidToken = await self.userInfoViewModel.checkAccessToken()
            if isValidToken {
                if let token = self.userInfoViewModel.UserResponse?.accessToken {
                    self.userListViewModel.requestNextUserList(id: self.id, token: token)
                } else {
                    (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeToLoginVC()
                }
            } else {
                (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeToLoginVC()
            }
        }
    }
}

extension UserListCollectionViewVC : UIScrollViewDelegate, UICollectionViewDelegate  {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! UserListCollectionViewCell
        
        let user_id = cell.user_id!
        self.pushProfileVC(user_id: user_id, userInfoViewModel: self.userInfoViewModel)
    }
    
    @objc func requestFollow(sender: FollowButton) {
        if (!self.userInfoViewModel.isLoggedIn()) {
            (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeToLoginVC()
        } else {
            Task {
                let isValidToken = await self.userInfoViewModel.checkAccessToken()
                if isValidToken {
                    if let token = self.userInfoViewModel.UserResponse?.accessToken {
                        self.userInfoViewModel.requestFollow(token: token, user_id: sender.tag) { [weak self] in
                            let alert = UIAlertController(title: "실패", message: "네트워크 연결을 확인해주세요", preferredStyle: UIAlertController.Style.alert)
                            let okAction = UIAlertAction(title: "OK", style: .default) { _ in
                                self?.navigationController?.popViewController(animated: true)
                            }
                            alert.addAction(okAction)
                            self?.present(alert, animated: false, completion: nil)
                        }
                        
                        sender.followButtonTapped()
                    } else {
                        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeToLoginVC()
                    }
                } else {
                    (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeToLoginVC()
                }
            }
        }
    }
    
    @objc func refreshFunction() {
        requestInitialData()
        self.collectionViewRefreshControl.endRefreshing()
    }
    
}

