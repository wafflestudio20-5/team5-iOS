//
//  ProfileUsecase.swift
//  KreamWaffleApp
//
//  Created by 최성혁 on 2023/01/21.
//

import Foundation
import RxCocoa

final class UserProfileUsecase {
    private let userProfileRepository: UserProfileRepository
    let user_id: Int
    
    private var userProfile: Profile? {
        didSet {
            if let profile = userProfile {
                userProfileRelay.accept(profile)
            }
        }
    }
    var userProfileRelay: BehaviorRelay<Profile> = .init(value: Profile())
    
    
    init(userProfileRepository: UserProfileRepository, user_id: Int) {
        self.userProfileRepository = userProfileRepository
        self.user_id = user_id
    }
    
    func requestProfile() {
        self.userProfile = self.userProfileRepository.requestProfile(user_id: self.user_id)
    }
}
