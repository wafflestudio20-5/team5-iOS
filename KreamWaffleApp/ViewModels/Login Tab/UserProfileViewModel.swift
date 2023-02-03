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
    var imageRelay = BehaviorRelay<UIImage>(value: UIImage(systemName: "person.crop.circle.fill")!)
    
    //저장 버튼 탭 저장하는 릴레이 (각자의 저장 버튼을 누르면 tap Relay 가 그걸 받고, Profile edit VC가 그것을 보고 알아서 맞는 값을 위 릴레이에서 할당해준다.
    var tapRelay = BehaviorRelay<editCase>(value: .none)
    
    init(usecase: UserUsecase) {
        self.usecase = usecase
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
    
    //post
    func editProfile(Profile: Profile){
        self.usecase.updateProfile(Profile: Profile)
    }
    
    //patch (for only text related fields)
    func partialEditProfile(newValue: String, editCase: editCase){
        self.usecase.updatePartialProfile(newValue: newValue, editCase: editCase)
    }
    
    //patch
    func editProfileImage(newImage: UIImage){
        self.usecase.updateProfileImage(newImage: newImage)
    }
}
