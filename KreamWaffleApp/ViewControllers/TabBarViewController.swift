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
    
    let homeViewModel: HomeViewModel
    let shopViewModel: ShopViewModel
    let styleFeedViewModel: StyleFeedViewModel
    let userInfoViewModel : UserInfoViewModel
    let loginViewModel : LoginViewModel
    let homeTabBarItem: UITabBarItem
    let styleTabBarItem: UITabBarItem
    let shopTabBarItem: UITabBarItem
    let myTabBarItem: UITabBarItem


    init(homeViewModel: HomeViewModel, shopViewModel: ShopViewModel, styleFeedViewModel: StyleFeedViewModel, userInfoViewModel:UserInfoViewModel, loginViewModel: LoginViewModel) {
        self.homeViewModel = homeViewModel
        self.shopViewModel = shopViewModel
        self.styleFeedViewModel = styleFeedViewModel
        self.userInfoViewModel = userInfoViewModel
        self.loginViewModel = loginViewModel
        
        self.homeTabBarItem = UITabBarItem(title: "HOME", image: UIImage(systemName: "house"), selectedImage: UIImage(systemName: "house.fill"))
        self.styleTabBarItem = UITabBarItem(title: "STYLE", image: UIImage(systemName: "heart.text.square"), selectedImage: UIImage(systemName: "heart.text.square.fill"))
        self.shopTabBarItem = UITabBarItem(title: "SHOP", image: UIImage(systemName: "bag"), selectedImage: UIImage(systemName: "bag.fill"))
        self.myTabBarItem = UITabBarItem(title: "MY", image: UIImage(systemName: "person"), selectedImage: UIImage(systemName: "person.fill"))
        
        super.init(nibName: nil, bundle: nil)
        
        //토글 되면 홈탭으로 돌아가야함. 
        self.loginViewModel.loginState.asObservable().subscribe { status in
            self.loginState = status.element
            if (status.element!){
                print("[Log] Tab bar controller: change to hometab")
                self.selectedIndex = 0
                self.dismiss(animated: true)
            }
        }.disposed(by: bag)
        
        if (self.selectedIndex == 1 || self.selectedIndex == 3){
            if (!self.loginState!){
                (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeToLoginVC()
            }
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
