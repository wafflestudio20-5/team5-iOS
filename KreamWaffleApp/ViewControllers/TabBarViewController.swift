//
//  TabBarViewController.swift
//  KreamWaffleApp
//
//  Created by 이선재 on 2022/12/24.
//

import UIKit

class TabBarViewController: UITabBarController {
    let homeViewModel: HomeViewModel
    let shopViewModel: ShopViewModel
    let styleFeedViewModel: StyleFeedViewModel
    let userInfoViewModel : UserInfoViewModel
    let loginViewModel : LoginViewModel
    let homeTabBarItem: UITabBarItem
    let styleTabBarItem: UITabBarItem
    let shopTabBarItem: UITabBarItem
    let myTabBarItem: UITabBarItem
    

    init(homeViewModel: HomeViewModel, shopViewModel: ShopViewModel, styleFeedViewModel: StyleFeedViewModel, userViewModel:UserInfoViewModel, loginViewModel: LoginViewModel) {
        self.homeViewModel = homeViewModel
        self.shopViewModel = shopViewModel
        self.styleFeedViewModel = styleFeedViewModel
        self.userViewModel = userViewModel
        self.loginViewModel = loginViewModel
        
        self.homeTabBarItem = UITabBarItem(title: "HOME", image: UIImage(systemName: "house"), selectedImage: UIImage(systemName: "house.fill"))
        self.styleTabBarItem = UITabBarItem(title: "STYLE", image: UIImage(systemName: "heart.text.square"), selectedImage: UIImage(systemName: "heart.text.square.fill"))
        self.shopTabBarItem = UITabBarItem(title: "SHOP", image: UIImage(systemName: "bag"), selectedImage: UIImage(systemName: "bag.fill"))
        self.myTabBarItem = UITabBarItem(title: "MY", image: UIImage(systemName: "person"), selectedImage: UIImage(systemName: "person.fill"))
        
        super.init(nibName: nil, bundle: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(changeIndex), name: Notification.Name("popLoginVC"), object: nil)
    }
    
    @objc func changeIndex() {
        if let tabBarController = self.navigationController?.tabBarController  {
            tabBarController.selectedIndex = 0
        }
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
        let homeTab = UINavigationController(rootViewController: HomeTabViewController(viewModel: self.homeViewModel))
        homeTab.modalPresentationStyle = .fullScreen
        homeTab.tabBarItem = homeTabBarItem

        let styleTab = UINavigationController(rootViewController: StyleTabViewController(styleFeedViewModel: self.styleFeedViewModel, userInfoViewModel: self.userInfoViewModel))
        styleTab.tabBarItem = styleTabBarItem

        let shopTab = UINavigationController(rootViewController: ShopTabViewController(viewModel: self.shopViewModel))
        shopTab.tabBarItem = shopTabBarItem
    
        let myTab = UINavigationController(rootViewController: MyTabViewController(userInfoVM: self.userInfoViewModel, loginVM: self.loginViewModel))
        myTab.tabBarItem = myTabBarItem
        self.tabBar.tintColor = .black
        self.tabBar.barTintColor = .white
        self.tabBar.unselectedItemTintColor = .black

        setViewControllers([homeTab, styleTab, shopTab, myTab], animated: true)

    }
}
