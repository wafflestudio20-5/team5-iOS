//
//  UserUsecase.swift
//  KreamWaffleApp
//
//  Created by grace kim  on 2023/01/06.
//

import Foundation
import RxSwift

final class UserUsecase {
    
    private let repository : LoginRepository
    private let disposeBag = DisposeBag()
    var error : LoginError
    var user : User?
    var userResponse : UserResponse?
    var loggedIn : Bool 
    
    init(dataRepository : LoginRepository){
        self.repository = dataRepository
        self.error = .noError
        self.loggedIn = false
    }
    
    //Login fields
    func getSavedUser(){
        if let savedUser =  repository.getUser(){
            self.user = savedUser
            self.loggedIn = true
        }else{
            print("no saved user")
        }
    }
    
    ///gets user info with customLogin
    func customLogin(email: String, password: String){
        repository.loginAccount(email: email, password: password) { [weak self] (result) in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                self.userResponse = response
                self.user = response.user
                self.loggedIn = true
            case .failure(let error):
                self.error = error as LoginError
                self.loggedIn = false
            }
        }
    }

    ///gets user info with social login
    func socialLogin(with socialToken: String){
        repository.loginWithNaver(naverToken: socialToken) { [weak self] (result) in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                self.userResponse = response
                self.user = response.user
                self.loggedIn = true
            case .failure(let error):
                self.error = error as LoginError
                self.loggedIn = false
            }
        }
    }
    
    func googleLogin(with socialToken: String){
        repository.loginWithGoogle(googleToken: socialToken) { [weak self] (result) in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                self.userResponse = response
                self.user = response.user
                self.loggedIn = true
            case .failure(let error):
                self.error = error as LoginError
                self.loggedIn = false
            }
        }
    }
    
    ///registers new account
    func signUp(email: String, password: String, shoeSize: Int){
        repository.registerAccount(with: email, password: password, shoe_size: shoeSize) { [weak self] (result) in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                print("register success")
            case .failure(let error):
                self.error = error as LoginError
                self.loggedIn = false
            }
        }
    }
    
    func logout(){
        repository.logOutUser()
        self.userResponse = nil
        self.user = nil
        self.loggedIn = false
    }
}

