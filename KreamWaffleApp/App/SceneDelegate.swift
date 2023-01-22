///
//  SceneDelegate.swift
//  KreamWaffleApp
//
//  Created by 이선재 on 2022/12/24.
//
import UIKit
import RxSwift
import NaverThirdPartyLogin
import GoogleSignIn

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    
    let bag = DisposeBag()
    
    var rootVC : TabBarViewController?
    var loginVM : LoginViewModel?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession`
        
        guard let scene = scene as? UIWindowScene else { return }
        
        self.window = UIWindow(windowScene: scene)
        
        let homeViewModel = HomeViewModel()
        let loginRepository = LoginRepository()
        let UserUsecase = UserUsecase(dataRepository: loginRepository)
        
        let shopViewModel = ShopViewModel(usecase: ShopUsecase(repository: ShopRepository()))
        
        let styleViewModel = StyleFeedViewModel(usecase: StyleFeedUsecase(repository: StyleFeedRepository(), type: "latest"))
        let userViewModel = UserInfoViewModel(UserUseCase: UserUsecase)
        let loginViewModel = LoginViewModel(UserUseCase: UserUsecase)
        loginViewModel.getSavedUser()
        self.loginVM = loginViewModel
        
        self.rootVC = TabBarViewController(homeViewModel: homeViewModel, shopViewModel: shopViewModel, styleViewModel: styleViewModel, userViewModel: userViewModel, loginViewModel: loginViewModel)
         
        //토글 되면 홈탭으로 돌아가야함.
        loginViewModel.loginState.asObservable().subscribe { status in
            
            if (self.window?.rootViewController == self.rootVC){
                if (self.rootVC?.selectedIndex == 1 || self.rootVC?.selectedIndex == 3){
                    if (!status.element!){
                        print("[Log] Scene Delegate: switching to login VC")
                        self.changeToLoginVC()
                    }else{
                    }
                }
            }
        }.disposed(by: bag)
        
        self.window?.rootViewController = rootVC
        self.window?.makeKeyAndVisible()
    }

    
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
      NaverThirdPartyLoginConnection
        .getSharedInstance()?
        .receiveAccessToken(URLContexts.first?.url)
        
        guard let scheme = URLContexts.first?.url.scheme else { return }
        if scheme.contains("com.googleusercontent.apps") {
            GIDSignIn.sharedInstance()?.handle(URLContexts.first!.url)
        }
        
    }
    
    func changeSelectedIndex(selectedIndex: Int){
        self.rootVC?.selectedIndex = selectedIndex
    }
    
    func changeToTabVC(animated: Bool = true){
        self.rootVC?.selectedIndex = 0
        self.window?.rootViewController = self.rootVC
    }
    
    func changeToLoginVC(animated: Bool = true){
        let loginVC = LoginViewController(viewModel: self.loginVM!)
        self.window?.rootViewController = loginVC
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }
}
