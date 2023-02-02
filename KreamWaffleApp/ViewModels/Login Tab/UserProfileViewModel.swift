//
//  UserProfileViewModel.swift
//  KreamWaffleApp
//
//  Created by grace on 2023/02/01.
//

import Foundation

class UserProfileViewModel {
    let usecase : UserUsecase
    
    init(usecase: UserUsecase) {
        self.usecase = usecase
    }
    
    var userProfile: Profile {
        get {
            return self.usecase.userProfile ?? Profile(user_id: 0, user_name: "", profile_name: "nil_profile", introduction: "", image: "", num_followers: 0, num_followings: 0, following: "")
        }
    }
    
    func requestUserProfile(onNetworkFailure: @escaping ()->()){
        self.usecase.requestProfile(onNetworkFailure: onNetworkFailure)
    }
    
    func editProfile(Profile: Profile){
        self.usecase.updateProfile(Profile: Profile)
    }
}
