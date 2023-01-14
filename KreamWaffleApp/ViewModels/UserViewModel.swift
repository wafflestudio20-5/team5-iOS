//
//  UserViewModel.swift
//  KreamWaffleApp
//
//  Created by grace kim  on 2023/01/06.
//

import Foundation


final class UserViewModel {
    
    private let UserUseCase : UserUsecase
    
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
    
    var Error : LoginError? {
        get {
            self.UserUseCase.error
        }
    }
    
    var LoggedIn : Bool {
        get {
            self.UserUseCase.loggedIn
        }
    }
    
    init (UserUseCase : UserUsecase){
        self.UserUseCase = UserUseCase
    }
    
    func getUserWithSocialToken(with token: String){
        self.UserUseCase.socialLogin(with: token)
    }
    
    func getUserWithCustomToken(token: String){
        
    }
    
    func getUserWithLogin(with email: String, password: String){
        self.UserUseCase.customLogin(email: email, password: password)
        print("User View Model: Logged In is", self.UserUseCase.loggedIn)
    }
    
    func getSavedUser(){
        self.UserUseCase.getSavedUser()
    }
    
    func logout(){
        self.UserUseCase.logout()
    }
    
}

