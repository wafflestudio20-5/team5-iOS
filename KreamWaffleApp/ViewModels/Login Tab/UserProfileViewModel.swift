//
//  UserProfileViewModel.swift
//  KreamWaffleApp
//
//  Created by grace on 2023/02/01.
//

import Foundation
import RxRelay
import UIKit
import RxSwift

class UserProfileViewModel {
    let usecase : UserUsecase
    
    //var imageRelay : BehaviorRelay<UIImage>
    var profileNameRelay: BehaviorRelay<String>
    var userNameRelay:  BehaviorRelay<String>
    var bioRelay: BehaviorRelay<String>
    
    init(usecase: UserUsecase) {
        self.usecase = usecase
        //imageRelay = BehaviorRelay<UIImage>(value: <#T##UIImage#>)
        profileNameRelay = BehaviorRelay<String>(value: self.usecase.userProfile?.profile_name ?? "")
        userNameRelay = BehaviorRelay<String>(value: self.usecase.userProfile?.user_name ?? "")
        bioRelay = BehaviorRelay<String>(value: self.usecase.userProfile?.introduction ?? "나를 소개하세요")
    }
    
    
    var userProfile: Profile {
        get {
            return self.usecase.userProfile ?? Profile(user_id: 0, user_name: "", profile_name: "nil_profile", introduction: "", image: "", num_followers: 0, num_followings: 0, following: "")
        }
    }
    
    var userProfileDataSource: Observable<Profile> {
        get {
            return self.usecase.profileRelay.asObservable()
        }
    }
    
    func requestUserProfile(onNetworkFailure: @escaping ()->()){
        self.usecase.requestProfile(onNetworkFailure: onNetworkFailure)
    }
    
    func editProfile(Profile: Profile){
        self.usecase.updateProfile(Profile: Profile)
    }
}
