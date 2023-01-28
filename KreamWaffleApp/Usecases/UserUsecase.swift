//
//  UserUsecase.swift
//  KreamWaffleApp
//
//  Created by grace kim  on 2023/01/06.
//
import Foundation
import RxSwift
import RxRelay

final class UserUsecase {
    
    private let repository : LoginRepository
    private let disposeBag = DisposeBag()
    var error : LoginError
    var user : User?
    var userResponse : UserResponse?
    var userProfile : Profile?
    
    var followingSet: Set<Int> = []
    
    ///toggle when logged in
    var loggedIn : Bool {
        didSet {
            loginState.accept(loggedIn)
            
            if (loggedIn) {
                self.followingSet = self.repository.loadFollowingSet()
            } else { // 로그아웃되면 followingSet 초기화.
                followingSet.removeAll(keepingCapacity: false)
            }
            
            print("[Log] User usecase: logged in changed to", loggedIn)
        }
    }
    
    ///VC should observe login state and toggle logged in
    let loginState = BehaviorRelay<Bool>(value: false)
    
    init(dataRepository : LoginRepository){
        self.repository = dataRepository
        self.error = .noError
        self.loggedIn = false
    }
    
    //MARK: related to log in, log out, sign up
    ///signs in user with user defaults
    func getSavedUser(){
        if let savedUser = repository.getUser(){
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
    func socialLogin(socialToken: String, socialType: Social){
        repository.loginWithSocial(socialToken: socialToken, socialType: socialType) { [weak self] (result) in
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
    
    func getUserProfile(){
        
    }
    
    ///logging out deletes saved/current user and initializes parameters.
    func logout(){
        repository.logOutUser()
        self.userResponse = nil
        self.user = nil
        self.loggedIn = false
    }
    
    func isFollowing(user_id: Int) -> Bool {
        return followingSet.contains(user_id)
    }
    
    func requestFollow(user_id: Int) {
        self.repository.requestFollow(user_id: user_id)
        if (self.followingSet.contains(user_id)) {
            self.followingSet.remove(user_id)
            print(self.followingSet)
        } else {
            self.followingSet.insert(user_id)
            print(self.followingSet)
        }
    }
}
