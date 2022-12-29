//
//  TabBarViewController.swift
//  KreamWaffleApp
//
//  Created by 이선재 on 2022/12/24.
//

import UIKit

class TabBarViewController: UITabBarController {
    let shopViewModel : ShopViewModel
    let homeTabBarItem: UITabBarItem
    let styleTabBarItem: UITabBarItem
    let shopTabBarItem: UITabBarItem
    let myTabBarItem: UITabBarItem

    init(shopViewModel: ShopViewModel) {
        self.shopViewModel = shopViewModel
        
        self.homeTabBarItem = UITabBarItem(title: "HOME", image: UIImage(systemName: "house"), selectedImage: UIImage(systemName: "house.fill"))
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
        self.view.backgroundColor = .white
        setUpTabBarViewController()
    }
    
    func setUpTabBarViewController() {
        let homeTab = UINavigationController(rootViewController: HomeTabViewController())
        homeTab.modalPresentationStyle = .fullScreen
        homeTab.tabBarItem = homeTabBarItem

        let styleTab = UINavigationController(rootViewController: StyleTabViewController())
        styleTab.tabBarItem = styleTabBarItem

        let shopTab = UINavigationController(rootViewController: ShopTabViewController(viewModel: self.shopViewModel))
        shopTab.tabBarItem = shopTabBarItem
        
        let myTab = UINavigationController(rootViewController: MyTabViewController())
        myTab.tabBarItem = myTabBarItem

        self.tabBar.tintColor = .black
        self.tabBar.barTintColor = .white
        self.tabBar.unselectedItemTintColor = .black

        setViewControllers([homeTab, styleTab, shopTab, myTab], animated: true)

        }


}
