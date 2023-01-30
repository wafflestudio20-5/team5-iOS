//
//  UIViewController+pushUserProfileVC.swift
//  KreamWaffleApp
//
//  Created by 최성혁 on 2023/01/22.
//

import Foundation
import UIKit

extension UIViewController {    
    func pushProfileVC(user_id: Int, userInfoViewModel: UserInfoViewModel) {        
        let profileUsecase = ProfileUsecase(profileRepository: ProfileRepository(), user_id: user_id)
        let profileViewModel = ProfileViewModel(profileUsecase: profileUsecase)
        
        let styleFeedUsecase = StyleFeedUsecase(repository: StyleFeedRepository(), type: "default", user_id: user_id)
        let styleFeedViewModel = StyleFeedViewModel(styleFeedUsecase: styleFeedUsecase)
        
        let profileViewController = ProfileViewController(userInfoViewModel: userInfoViewModel, profileViewModel: profileViewModel, styleFeedViewModel: styleFeedViewModel)
        
        self.navigationController?.pushViewController(profileViewController, animated: true)
    }
    
    func pushNewPostVC(userInfoViewModel: UserInfoViewModel) {
        setUpBackButton()
        let newPostRepository = NewPostRepository()
        let newPostViewModel = NewPostViewModel(newPostRepository: newPostRepository)
        let newPostVC = NewPostViewController(newPostViewModel: newPostViewModel, userInfoViewModel: userInfoViewModel)
        
        self.navigationController?.pushViewController(newPostVC, animated: true)
    }
}
