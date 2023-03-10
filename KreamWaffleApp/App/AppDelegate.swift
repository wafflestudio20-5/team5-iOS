//
//  AppDelegate.swift
//  KreamWaffleApp
//
//  Created by 이선재 on 2022/12/24.
//
import UIKit

import NaverThirdPartyLogin
import GoogleSignIn

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        sleep(1)
        let instance = NaverThirdPartyLoginConnection.getSharedInstance()
            
        // 네이버 앱으로 인증하는 방식을 활성화
        instance?.isNaverAppOauthEnable = true
            
        // SafariViewController에서 인증하는 방식을 활성화
        instance?.isInAppOauthEnable = true
            
        // 인증 화면을 iPhone의 세로 모드에서만 사용하기
        instance?.isOnlyPortraitSupportedInIphone()
            
        // 네이버 아이디로 로그인하기 설정
        // 애플리케이션을 등록할 때 입력한 URL Scheme
        instance?.serviceUrlScheme = "naverlogin"
        // 애플리케이션 등록 후 발급받은 클라이언트 아이디
        instance?.consumerKey = Bundle.main.NAVER_CONSUMER_KEY
        // 애플리케이션 등록 후 발급받은 클라이언트 시크릿
        instance?.consumerSecret = Bundle.main.NAVER_CONSUMER_SECRET
        // 애플리케이션 이름
        instance?.appName = "Kream"
        
        //google
        GIDSignIn.sharedInstance()?.clientID = Bundle.main.GOOGLE_CLIENT_ID
        return true
    }

    // MARK: UISceneSession Lifecycle
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        let naverHandled = NaverThirdPartyLoginConnection.getSharedInstance()?.application(app, open: url, options: options)
        let googlehandled = GIDSignIn.sharedInstance()?.handle(url) ?? false
        /*
        if (googlehandled || (naverHandled != nil)){
           return true
         }else {
             return false
         }*/
        return true
       
      }


}
