///
//  UserViewModel.swift
//  KreamWaffleApp
//
//  Created by grace kim  on 2023/01/06.
//
import Foundation
import UIKit
import RxSwift

enum Social {
    case Naver
    case Google
}

///used in all other VCs, shares use case with login view model
final class UserInfoViewModel {
    
    public let UserUseCase : UserUsecase
    
    var User : User? {
            get {
                self.UserUseCase.user
            }
        }
    
    var UserReponse: UserResponse? {
        get {
            self.UserUseCase.userResponse
        }
    }
    
    init (UserUseCase : UserUsecase){
        self.UserUseCase = UserUseCase
    }
    
    func isFollowing(user_id: Int) -> Bool {
        return self.UserUseCase.isFollowing(user_id: user_id)
    }
    
    func requestFollow(user_id: Int) {
        self.UserUseCase.requestFollow(user_id: user_id)
    }
}
