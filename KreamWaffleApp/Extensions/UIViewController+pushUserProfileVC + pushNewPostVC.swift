//
//  UIViewController+pushUserProfileVC.swift
//  KreamWaffleApp
//
//  Created by 최성혁 on 2023/01/22.
//

import Foundation
import UIKit

extension UIViewController {
    func pushUserProfileVC(user_id: Int, userInfoViewModel: UserInfoViewModel) {        
        let userProfileUsecase = UserProfileUsecase(userProfileRepository: UserProfileRepository(), user_id: user_id)
        let userProfileViewModel = UserProfileViewModel(userProfileUsecase: userProfileUsecase)
        
        let styleFeedUsecase = StyleFeedUsecase(repository: StyleFeedRepository(), type: "default", user_id: user_id)
        let styleFeedViewModel = StyleFeedViewModel(styleFeedUsecase: styleFeedUsecase)
        
        let userProfileViewController = UserProfileViewController(userInfoViewModel: userInfoViewModel, userProfileViewModel: userProfileViewModel, styleFeedViewModel: styleFeedViewModel)
        
        self.navigationController?.pushViewController(userProfileViewController, animated: true)
    }
    
    func pushNewPostVC(userInfoViewModel: UserInfoViewModel) {
        setUpBackButton()
        let newPostRepository = NewPostRepository()
        let newPostViewModel = NewPostViewModel(newPostRepository: newPostRepository)
        let newPostVC = NewPostViewController(newPostViewModel: newPostViewModel, userInfoViewModel: userInfoViewModel)
        
        self.navigationController?.pushViewController(newPostVC, animated: true)
    }
}
