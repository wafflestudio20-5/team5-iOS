//
//  StyleTabViewController.swift
//  KreamWaffleApp
//
//  Created by 이선재 on 2022/12/24.
//

import UIKit
import RxSwift
import RxCocoa
import CHTCollectionViewWaterfallLayout
import BetterSegmentedControl

class StyleTabViewController: UIViewController {
//    private let styleFeedViewModel: StyleFeedViewModel
    private let userInfoViewModel: UserInfoViewModel
    private let disposeBag = DisposeBag()
    private var latestStyleFeedCollectionViewVC: StyleFeedCollectionViewVC
    private var followingStyleFeedCollectioinViewVC: StyleFeedCollectionViewVC
    private var segmentedControl: BetterSegmentedControl?
    
    init(latestStyleFeedViewModel: StyleFeedViewModel, followingStyleFeedViewModel: StyleFeedViewModel, userInfoViewModel: UserInfoViewModel) {
        self.userInfoViewModel = userInfoViewModel
        
        self.latestStyleFeedCollectionViewVC = StyleFeedCollectionViewVC(styleFeedViewModel: latestStyleFeedViewModel, userInfoViewModel: self.userInfoViewModel)
        self.followingStyleFeedCollectioinViewVC = StyleFeedCollectionViewVC(styleFeedViewModel: followingStyleFeedViewModel, userInfoViewModel: self.userInfoViewModel)

        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpSegmentedControl()
        setUpNavigationBar()
        setUpButtons()
        setUpChildVC()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if self.segmentedControl!.index == 1 {
            if !self.userInfoViewModel.isLoggedIn() {
                (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeToLoginVC()
            } else {
                Task {
                    let isValidToken = await userInfoViewModel.checkAccessToken()
                    if !isValidToken {
                        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeToLoginVC()
                    }
                }
            }
        }
    }
    
    func setUpSegmentedControl() {
        self.segmentedControl = BetterSegmentedControl(
            frame: CGRect(x: 0, y: 0, width: view.bounds.width/2 - 32.0, height: 30),
            segments: LabelSegment.segments(withTitles: ["최신", "팔로잉"],
                                            normalFont: .boldSystemFont(ofSize: 17.0),
                                            normalTextColor: .lightGray,
                                            selectedFont: .boldSystemFont(ofSize: 17.0),
                                            selectedTextColor: .black
                                           ),
            options: [.backgroundColor(.white),
                      .indicatorViewBackgroundColor(.white),
                      .cornerRadius(3.0),
                      .animationSpringDamping(1.0)]
        )

        segmentedControl!.addTarget(
            self,
            action: #selector(navigationSegmentedControlValueChanged(_:)),
            for: .valueChanged)

        segmentedControl!.sizeToFit()
        navigationItem.titleView = segmentedControl
    }
    
    func setUpNavigationBar() {
        self.navigationItem.title = "최신"
        self.setUpBackButton()
    }
    
    func setUpButtons() {
        //configure camera button
        let cameraImage = UIImage(systemName: "camera.circle.fill")
        let tintedCameraImage = cameraImage?.withRenderingMode(.alwaysTemplate)
        let cameraButton = UIBarButtonItem(title: "", style: .plain, target: self, action: #selector(cameraButtonTapped))
        cameraButton.image = tintedCameraImage
        cameraButton.tintColor = .darkGray
        self.navigationItem.rightBarButtonItem = cameraButton
    }
    
    func setUpChildVC() {
        self.view.addSubview(latestStyleFeedCollectionViewVC.view)
        self.addChild(latestStyleFeedCollectionViewVC)
        latestStyleFeedCollectionViewVC.didMove(toParent: self)

        latestStyleFeedCollectionViewVC.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.latestStyleFeedCollectionViewVC.view.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0),
            self.latestStyleFeedCollectionViewVC.view.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0),
            self.latestStyleFeedCollectionViewVC.view.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 0),
            self.latestStyleFeedCollectionViewVC.view.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: 0),
        ])
        
        self.view.addSubview(followingStyleFeedCollectioinViewVC.view)
        self.addChild(followingStyleFeedCollectioinViewVC)
        followingStyleFeedCollectioinViewVC.didMove(toParent: self)

        followingStyleFeedCollectioinViewVC.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.followingStyleFeedCollectioinViewVC.view.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0),
            self.followingStyleFeedCollectioinViewVC.view.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0),
            self.followingStyleFeedCollectioinViewVC.view.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 0),
            self.followingStyleFeedCollectioinViewVC.view.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: 0),
        ])
        
        self.followingStyleFeedCollectioinViewVC.view.isHidden = true
    }
    
    @objc func cameraButtonTapped() {
        if (!self.userInfoViewModel.isLoggedIn()) {
            (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeToLoginVC()
        } else {
            Task {
                let isValidToken = await userInfoViewModel.checkAccessToken()
                if !isValidToken {
                    (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeToLoginVC()
                } else {
                    pushNewPostVC(userInfoViewModel: self.userInfoViewModel)
                }
            }
        }
    }
    
    @objc func navigationSegmentedControlValueChanged(_ sender: BetterSegmentedControl) {
        if sender.index == 0 {
            self.latestStyleFeedCollectionViewVC.view.isHidden = false
            self.followingStyleFeedCollectioinViewVC.view.isHidden = true
        } else {
            if !self.userInfoViewModel.isLoggedIn() {
                (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeToLoginVC()
            } else {
                Task {
                    let isValidToken = await userInfoViewModel.checkAccessToken()
                    if !isValidToken {
                        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeToLoginVC()
                    }
                }
            }
            
            self.latestStyleFeedCollectionViewVC.view.isHidden = true
            self.followingStyleFeedCollectioinViewVC.view.isHidden = false
        }
    }
}
