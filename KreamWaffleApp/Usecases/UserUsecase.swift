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
    
    ///toggle when logged in
    var loggedIn : Bool {
        didSet {
            loginState.accept(loggedIn)
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
        Task {
            if let savedUserResponse = repository.getUserResponse(){
                self.userResponse = savedUserResponse
                await self.checkAccessToken()
            }else{
                print("no saved user reponse")
            }
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
    private func requestsNewAccessToken() async {
        repository.getNewToken { [weak self] (result) in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                self.replaceAccessToken(newToken: response.accessToken)
                print("[Log] Userusecase: refresh token is still valid")
                print("newtoken: \(response.accessToken)")
            case .failure(let error):
                self.error = error as LoginError
                if (error == .invalidRefreshTokenError){
                    self.logout()
                }
            }
        }
    }
    
    func checkAccessToken() async {
        print("token before checkIfValidToken: \(self.userResponse?.accessToken)")
        repository.checkIfValidToken { [weak self] (result) in
            guard let self = self else { return }
            switch result {
            case .success:
                print("[Log] UserUsecase: access token is still valid")
            case .failure(let error):
                self.error = error as LoginError
                Task {
                    await self.requestsNewAccessToken()
                }
            }
        }
    }
    
    func testCheckAccessToken() {
        print("token before checkIfValidToken: \(self.userResponse?.accessToken)")
        repository.checkIfValidToken { [weak self] (result) in
            guard let self = self else { return }
            switch result {
            case .success:
                print("[Log] UserUsecase: access token is still valid")
            case .failure(let error):
                self.error = error as LoginError
                Task {
                    await self.requestsNewAccessToken()
                }
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
    
    func requestFollow(token: String, user_id: Int, onNetworkFailure: @escaping () -> ()) {
        self.repository.requestFollow(token: token, user_id: user_id, onNetworkFailure: onNetworkFailure)
    }
}
