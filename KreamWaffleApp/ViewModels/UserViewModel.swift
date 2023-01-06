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
    
    init (UserUseCase : UserUsecase){
        self.UserUseCase = UserUseCase
    }
    
    func getUserWithSocialToken(with token: String){
        self.UserUseCase.getUserInfoWithSocialToken(with: token)
        self.User = UserUseCase.user
    }
}
