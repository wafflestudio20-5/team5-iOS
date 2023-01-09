//
//  UserViewModel.swift
//  KreamWaffleApp
//
//  Created by grace kim  on 2023/01/06.
//

import Foundation

final class UserViewModel {
    
    private let UserUseCase : UserUsecase
    var User : User?
    var error : Error?
    
    init (UserUseCase : UserUsecase){
        self.UserUseCase = UserUseCase
    }
    
    func getUserWithSocialToken(with token: String){
        self.UserUseCase.getUserInfoWithSocialToken(with: token)
        self.User = UserUseCase.user
        self.error = UserUseCase.error
    }
    
    func getUserWithLogin(with email: String, password: String){
        self.UserUseCase.customLogin(email: email, password: password)
        self.User = UserUseCase.user
        self.error = UserUseCase.error
    }
}

