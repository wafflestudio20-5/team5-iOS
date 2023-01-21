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
    private let disposeBag = DisposeBag()
    
    init(userListViewModel: UserListViewModel, userInfoViewModel: UserInfoViewModel) {
        self.userListViewModel = userListViewModel
        self.userInfoViewModel = userInfoViewModel
        
        collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UserListCollectionViewLayout())
        super.init(nibName: nil, bundle: nil)
        collectionView.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        setUpCollectionView()
        bindCollectionView()
        requestInitialData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        refreshDataSource()
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
                cell.configure(with: item, isFollowing: self.userInfoViewModel.isFollowing(user_id: item.user_id))
                cell.followButton.tag = item.user_id
                cell.followButton.addTarget(self, action: #selector(self.requestFollow(sender:)), for: .touchUpInside)

            }
            .disposed(by: disposeBag)
    }
    
    func requestInitialData() {
        userListViewModel.requestUserListData(page: 1)
    }
    
    func refreshDataSource() {
        self.userListViewModel.requestUserListData(page: 1)
    }
}

extension UserListCollectionViewVC : UIScrollViewDelegate, UICollectionViewDelegate  {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let cell = collectionView.cellForItem(at: indexPath) as! MovieCollectionViewCell
//
//        if let image = cell.posterImage.image {
//            let newViewModel = DetailVM(movieUsecase: viewModel.movieUsecase, favoriteMovieUsecase: viewModel.favoriteMovieUsecase)
//            newViewModel.selectPopularMovieByIndex(index: indexPath.row)
//
//            let movieInfoVC = MovieInfoVC(vm: newViewModel, image: image)
//            self.navigationController?.pushViewController(movieInfoVC, animated: true)
    }
    
    @objc func requestFollow(sender: FollowButton) {
        if (!self.userInfoViewModel.isLoggedIn()) {
            let loginRepository = LoginRepository()
            let LoginUsecase = LoginUsecase(repository: loginRepository)
            let loginViewModel = LoginViewModel(UserUseCase: self.userInfoViewModel.UserUseCase, LoginUseCase: LoginUsecase)

            let loginScreen = LoginViewController(viewModel: loginViewModel)
            loginScreen.modalPresentationStyle = .fullScreen
            self.present(loginScreen, animated: false)
        } else {
            self.userInfoViewModel.requestFollow(user_id: sender.tag)
            sender.isFollowing = !sender.isFollowing
            sender.configureFollowButton()
        }
    }
    
}

