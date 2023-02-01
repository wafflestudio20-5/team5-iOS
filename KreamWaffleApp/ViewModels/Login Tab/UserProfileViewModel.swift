//
//  UserProfileViewModel.swift
//  KreamWaffleApp
//
//  Created by grace on 2023/02/01.
//

import Foundation

class UserProfileViewModel {
    private let usecase : UserUsecase
    
    init(usecase: UserUsecase) {
        self.usecase = usecase
    }
    
    var userProfile: Profile {
        get {
            return self.usecase.userProfile!
        }
    }
    
    func requestUserProfile(onNetworkFailure: @escaping ()->()){
        self.usecase.requestProfile(onNetworkFailure: onNetworkFailure)
    }
}
