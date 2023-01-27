//
//  ProfileUsecase.swift
//  KreamWaffleApp
//
//  Created by 최성혁 on 2023/01/21.
//

import Foundation
import RxCocoa
import RxSwift

final class UserProfileUsecase {
    private let userProfileRepository: UserProfileRepository
    let user_id: Int
    let disposeBag = DisposeBag()
    
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
        self.userProfileRepository
            .requestProfile(user_id: self.user_id)
            .subscribe(
                onSuccess: { [weak self] fetchedProfile in
                    if let fetchedProfile = fetchedProfile {
                        self?.userProfile = fetchedProfile
                    } else {
                        self?.userProfile = Profile()
                    }
                },
                onFailure: { _ in
                    self.userProfile = Profile()
                }
            )
            .disposed(by: disposeBag)
    }
}
