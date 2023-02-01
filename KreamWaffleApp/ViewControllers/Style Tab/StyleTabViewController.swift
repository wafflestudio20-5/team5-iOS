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

class StyleTabViewController: UIViewController {
    private let styleFeedViewModel: StyleFeedViewModel
    private let userInfoViewModel: UserInfoViewModel
    private let disposeBag = DisposeBag()
    private var styleFeedCollectionViewVC: StyleFeedCollectionViewVC
    
    init(styleFeedViewModel: StyleFeedViewModel, userInfoViewModel: UserInfoViewModel) {
        self.styleFeedViewModel = styleFeedViewModel
        self.userInfoViewModel = userInfoViewModel
        styleFeedCollectionViewVC = StyleFeedCollectionViewVC(styleFeedViewModel: self.styleFeedViewModel, userInfoViewModel: self.userInfoViewModel)

        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigationBar()
        setUpButtons()
        setUpChildVC()
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
        self.view.addSubview(styleFeedCollectionViewVC.view)
        self.addChild(styleFeedCollectionViewVC)
        styleFeedCollectionViewVC.didMove(toParent: self)
        
        styleFeedCollectionViewVC.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.styleFeedCollectionViewVC.view.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0),
            self.styleFeedCollectionViewVC.view.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0),
            self.styleFeedCollectionViewVC.view.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 0),
            self.styleFeedCollectionViewVC.view.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: 0),
        ])
    }
    
    @objc func cameraButtonTapped() {
        if (self.userInfoViewModel.isLoggedIn()) {
            pushNewPostVC(userInfoViewModel: self.userInfoViewModel)
        } else {
            let loginScreen: LoginViewController! = (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.loginVC

            loginScreen.modalPresentationStyle = .fullScreen
            self.present(loginScreen, animated: false)
        }
        
    }
}
