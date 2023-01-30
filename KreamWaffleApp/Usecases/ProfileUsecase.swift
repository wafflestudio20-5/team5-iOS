//
//  ProfileUsecase.swift
//  KreamWaffleApp
//
//  Created by 최성혁 on 2023/01/21.
//

import Foundation
import RxCocoa
import RxSwift

final class ProfileUsecase {
    private let profileRepository: ProfileRepository
    let user_id: Int
    let disposeBag = DisposeBag()
    
    private var profile: Profile? {
        didSet {
            if let profile = profile {
                profileRelay.accept(profile)
            }
        }
    }
    var profileRelay: BehaviorRelay<Profile> = .init(value: Profile())
    
    
    init(profileRepository: ProfileRepository, user_id: Int) {
        self.profileRepository = profileRepository
        self.user_id = user_id
    }
    
    func requestProfile(token: String?, onNetworkFailure: @escaping ()->()) {
        self.profileRepository
            .requestProfile(user_id: self.user_id, token: token, onNetworkFailure: onNetworkFailure)
            .subscribe(
                onSuccess: { [weak self] fetchedProfile in
                    self?.profile = fetchedProfile
                },
                onFailure: { _ in
                    self.profile = nil
                }
            )
            .disposed(by: disposeBag)
    }
}
