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
    
    private let UserUseCase : UserUsecase
    
    var User : User? {
            get {
                self.UserUseCase.user
            }
        }
    
    var UserResponse: UserResponse? {
        get {
            self.UserUseCase.userResponse
        }
    }
    
    init (UserUseCase : UserUsecase){
        self.UserUseCase = UserUseCase
    }
    
    func isLoggedIn() -> Bool {
        return self.UserUseCase.loggedIn
    }
    
    func requestFollow(token: String, user_id: Int, onNetworkFailure: @escaping () -> ()) {
        self.UserUseCase.requestFollow(token: token, user_id: user_id, onNetworkFailure: onNetworkFailure)
    }
    
    func checkAccessToken() async -> Bool{
        return await self.UserUseCase.checkAccessToken()
    }
    
    func getUserId() -> Int? {
        return User?.id
    }
}
