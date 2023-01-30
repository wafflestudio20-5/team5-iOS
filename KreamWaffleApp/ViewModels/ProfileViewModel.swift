//
//  ProfileViewModel.swift
//  KreamWaffleApp
//
//  Created by 최성혁 on 2023/01/21.
//

import Foundation
import RxSwift

final class ProfileViewModel {
    private let profileUsecase: ProfileUsecase
    
    init(profileUsecase: ProfileUsecase) {
        self.profileUsecase = profileUsecase
    }
    
    func getUserId() -> Int {
        return self.profileUsecase.user_id
    }
    
    var userProfileDataSource: Observable<Profile> {
        get {
            return self.profileUsecase.profileRelay.asObservable()
        }
    }
    
    func requestProfile(token: String?, onNetworkFailure: @escaping ()->()) {
        self.profileUsecase.requestProfile(token: token, onNetworkFailure: onNetworkFailure)
    }
}
