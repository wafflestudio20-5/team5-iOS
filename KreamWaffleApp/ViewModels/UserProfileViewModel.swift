//
//  ProfileViewModel.swift
//  KreamWaffleApp
//
//  Created by 최성혁 on 2023/01/21.
//

import Foundation
import RxSwift

final class UserProfileViewModel {
    private let userProfileUsecase: UserProfileUsecase
    
    init(userProfileUsecase: UserProfileUsecase) {
        self.userProfileUsecase = userProfileUsecase
    }
    
    func getUserId() -> Int {
        return self.userProfileUsecase.user_id
    }
    
    var userProfileDataSource: Observable<Profile?> {
        get {
            return self.userProfileUsecase.userProfileRelay.asObservable()
        }
    }
    
    func requestProfile(onNetworkFailure: @escaping ()->()) {
        self.userProfileUsecase.requestProfile(onNetworkFailure: onNetworkFailure)
    }
}
