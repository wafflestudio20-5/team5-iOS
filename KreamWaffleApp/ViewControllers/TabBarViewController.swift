//
//  TabBarViewController.swift
//  KreamWaffleApp
//
//  Created by 이선재 on 2022/12/24.
//

import UIKit
import RxSwift

//로그인 여부가 토글될때 마다 Tab bar controller 에서 홈으로 돌아가야함.
class TabBarViewController: UITabBarController {
    
    let bag = DisposeBag()
    var loginState : Bool?
    
    let shopViewModel: ShopViewModel
    let latestStyleFeedViewModel: StyleFeedViewModel
    let followingStyleFeedViewModel: StyleFeedViewModel
    let userInfoViewModel : UserInfoViewModel
    let loginViewModel : LoginViewModel
    let UserProfileViewModel: UserProfileViewModel
    let styleTabBarItem: UITabBarItem
    let shopTabBarItem: UITabBarItem
    let myTabBarItem: UITabBarItem

    init(shopViewModel: ShopViewModel, latestStyleFeedViewModel: StyleFeedViewModel, followingStyleFeedViewModel: StyleFeedViewModel, userInfoViewModel:UserInfoViewModel, loginViewModel: LoginViewModel, userProfileViewModel: UserProfileViewModel) {
        
        self.shopViewModel = shopViewModel
        self.latestStyleFeedViewModel = latestStyleFeedViewModel
        self.followingStyleFeedViewModel = followingStyleFeedViewModel
        self.userInfoViewModel = userInfoViewModel
        self.loginViewModel = loginViewModel
        self.UserProfileViewModel = userProfileViewModel
        
        self.styleTabBarItem = UITabBarItem(title: "STYLE", image: UIImage(systemName: "heart.text.square"), selectedImage: UIImage(systemName: "heart.text.square.fill"))
        self.shopTabBarItem = UITabBarItem(title: "SHOP", image: UIImage(systemName: "bag"), selectedImage: UIImage(systemName: "bag.fill"))
        self.myTabBarItem = UITabBarItem(title: "MY", image: UIImage(systemName: "person"), selectedImage: UIImage(systemName: "person.fill"))
        
        super.init(nibName: nil, bundle: nil)
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.present(OpeningViewController(), animated: true)
        self.view.backgroundColor = .white
        setUpTabBarViewController()
    }
    
    func setUpTabBarViewController() {
        let styleTab = UINavigationController(rootViewController: StyleTabViewController(latestStyleFeedViewModel: self.latestStyleFeedViewModel, followingStyleFeedViewModel: self.followingStyleFeedViewModel, userInfoViewModel: self.userInfoViewModel))
        styleTab.tabBarItem = styleTabBarItem

        let shopTab = UINavigationController(rootViewController: ShopTabViewController(viewModel: self.shopViewModel, userInfoViewModel: self.userInfoViewModel))
        shopTab.tabBarItem = shopTabBarItem
    
        let myTab = UINavigationController(rootViewController: MyTabViewController(userInfoVM: self.userInfoViewModel, loginVM: self.loginViewModel, userProfileVM: self.UserProfileViewModel))
        myTab.tabBarItem = myTabBarItem
        self.tabBar.tintColor = .black
        self.tabBar.barTintColor = .white
        self.tabBar.unselectedItemTintColor = .black

        setViewControllers([shopTab, styleTab, myTab], animated: true)

    }
}
