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
    
    var error : LoginError {
        didSet {
            errorRelay.accept(error)
        }
    }
    
    ///VC should observe login state and toggle logged in
    let loginState = BehaviorRelay<Bool>(value: false)
    
    let errorRelay = BehaviorRelay<LoginError>(value: .noError)
    
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
        
        //TODO: 나중에는 only get user response
        if let savedUserResponse = repository.getUserResponse(){
            self.userResponse = savedUserResponse
            self.checksAccessToken()
        }else{
            print("no saved user reponse")
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
    
    //MARK: - checks/requests token
    private func requestsNewAccessToken(){
        repository.getNewToken { [weak self] (result) in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                self.replaceAccessToken(newToken: response.accessToken)
                print("[Log] Userusecase: refresh token is still valid")
            case .failure(let error):
                self.error = error as LoginError
                if (error == .invalidRefreshTokenError){
                    self.logout()
                }
            }
        }
    }
    
    func checksAccessToken(){
        repository.checkIfValidToken { [weak self] (result) in
            guard let self = self else { return }
            switch result {
            case .success:
                print("[Log] UserUsecase: access token is still valid")
            case .failure(let error):
                self.error = error as LoginError
                self.requestsNewAccessToken()
            }
        }
    }
    
    private func replaceAccessToken(newToken: String){
        self.userResponse?.accessToken = newToken
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
