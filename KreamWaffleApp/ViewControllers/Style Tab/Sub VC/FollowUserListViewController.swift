//
//  FollowingAndFollowerViewController.swift
//  KreamWaffleApp
//
//  Created by 최성혁 on 2023/01/23.
//

import Foundation
import UIKit
import BetterSegmentedControl

class FollowUserListViewController:UIViewController {
    private let followerUserListCollectionViewVC: UserListCollectionViewVC
    private let followingUserListCollectionViewVC: UserListCollectionViewVC
    private let userInfoViewModel: UserInfoViewModel
    private var segmentedControl: BetterSegmentedControl?
    
    private let selectedSegmentIdx: Int
    
    init(id: Int, userInfoViewModel: UserInfoViewModel, selectedSegmentIdx: Int) {
        self.selectedSegmentIdx = selectedSegmentIdx
        
        self.userInfoViewModel = userInfoViewModel
        
        let followerUserListRepository = FollowerUserListRepository()
        let followingUserListRepository = FollowingUserListRepository()
        let followerUserListUsecase = UserListUsecase(userListRepository: followerUserListRepository)
        let followingUserListUsecase = UserListUsecase(userListRepository: followingUserListRepository)
        self.followerUserListCollectionViewVC = UserListCollectionViewVC(id: id, userListViewModel: UserListViewModel(userListUsecase: followerUserListUsecase), userInfoViewModel: self.userInfoViewModel)
        self.followingUserListCollectionViewVC = UserListCollectionViewVC(id: id, userListViewModel: UserListViewModel(userListUsecase: followingUserListUsecase), userInfoViewModel: self.userInfoViewModel)
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        self.view.backgroundColor = .white
        setUpSegmentedControl()
        setUpChildVCs()
    }
    
    func setUpSegmentedControl() {
        self.segmentedControl = BetterSegmentedControl(
            frame: CGRect(x: 0, y: 0, width: view.bounds.width/2, height: 50),
            segments: LabelSegment.segments(withTitles: ["팔로워", "팔로잉"],
                                            normalFont: .systemFont(ofSize: 17.0),
                                            normalTextColor: .lightGray,
                                            selectedFont: .boldSystemFont(ofSize: 17.0),
                                            selectedTextColor: .black
                                           ),
            index: selectedSegmentIdx,
            options: [.backgroundColor(.white),
                      .indicatorViewBackgroundColor(.white),
                      .cornerRadius(3.0),
                      .animationDuration(0),
                      .animationSpringDamping(0)]
        )
        
        self.segmentedControl!.addTarget(
            self,
            action: #selector(navigationSegmentedControlValueChanged(_:)),
            for: .valueChanged)
        
        self.view.addSubview(self.segmentedControl!)
        self.segmentedControl!.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.segmentedControl!.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            self.segmentedControl!.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
            self.segmentedControl!.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
        ])
    }
    
    func setUpChildVCs() {
        self.view.addSubview(followerUserListCollectionViewVC.view)
        self.addChild(followerUserListCollectionViewVC)
        followerUserListCollectionViewVC.didMove(toParent: self)
        
        followerUserListCollectionViewVC.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.followerUserListCollectionViewVC.view.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 0),
            self.followerUserListCollectionViewVC.view.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: 0),
            self.followerUserListCollectionViewVC.view.topAnchor.constraint(equalTo: self.segmentedControl!.bottomAnchor, constant: 10),
            self.followerUserListCollectionViewVC.view.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: 0),
        ])
        
        self.view.addSubview(followingUserListCollectionViewVC.view)
        self.addChild(followingUserListCollectionViewVC)
        followingUserListCollectionViewVC.didMove(toParent: self)
        
        followingUserListCollectionViewVC.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.followingUserListCollectionViewVC.view.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 0),
            self.followingUserListCollectionViewVC.view.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: 0),
            self.followingUserListCollectionViewVC.view.topAnchor.constraint(equalTo: self.followerUserListCollectionViewVC.view.topAnchor),
            self.followingUserListCollectionViewVC.view.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: 0),
        ])
        
        if (selectedSegmentIdx == 0) {
            self.followingUserListCollectionViewVC.view.isHidden = true
        } else {
            self.followerUserListCollectionViewVC.view.isHidden = true
        }
    }
}

extension FollowUserListViewController {
    @objc func navigationSegmentedControlValueChanged(_ sender: BetterSegmentedControl) {
        if sender.index == 0 {
            self.followerUserListCollectionViewVC.view.isHidden = false
            self.followingUserListCollectionViewVC.view.isHidden = true
        } else {
            self.followerUserListCollectionViewVC.view.isHidden = true
            self.followingUserListCollectionViewVC.view.isHidden = false
        }
    }
}
