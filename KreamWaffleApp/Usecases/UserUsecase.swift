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
    private let profileRepository : ProfileRepository
    private let disposeBag = DisposeBag()
    
    var user : User?
    var userResponse : UserResponse?
    
    var userProfile : Profile?
    
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
    
    init(dataRepository : LoginRepository, profileRepository: ProfileRepository){
        self.repository = dataRepository
        self.profileRepository = profileRepository
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
    private func requestNewAccessToken() async {
        Task {
            await repository.getNewToken { [weak self] (result) in
                guard let self = self else { return }
                switch result {
                case .success(let response):
                    print("[Log] Userusecase: refresh token is still valid")
                    print("[Log] newtoken: \(response.accessToken)")
                    self.replaceAccessToken(newToken: response.accessToken)
                case .failure(let error):
                    self.error = error as LoginError
                    //TODO: 이거 에러.
                    /*
                    if (error == .invalidRefreshTokenError){
                        self.logout()
                    }*/
                }
            }
        }
    }
    
    //현재 토큰이 유효하다면 true, 아니면 false
    func checkAccessToken() async -> Bool{
        Task {
            await repository.checkIfValidToken { [weak self] (result) in
                guard let self = self else { return }
                switch result {
                case .success:
                    print("[Log] UserUsecase: access token is still valid")
                    print("[Log] UserUsecase: that valid token is: \(self.userResponse!.accessToken)")
                case .failure(let error):
                    Task {
                        await self.requestNewAccessToken()
                        self.error = error as LoginError
                    }
                }
            }
        }
        
        //checkIfValidToken 실행 후에도 userResponse가 삭제되지 않았으면 현재 토큰이 유효하다고 할 수 있음.
        return self.userResponse != nil
    }
    
    private func replaceAccessToken(newToken: String){
        self.userResponse?.accessToken = newToken
    }
    
    
    //MARK: user profile related
    func requestProfile(onNetworkFailure: @escaping ()->()) {
            
            self.profileRepository
                .requestProfile(user_id: self.user!.id, token: self.userResponse!.accessToken, onNetworkFailure: onNetworkFailure)
                .subscribe(
                    onSuccess: { [weak self] fetchedProfile in
                        self?.userProfile = fetchedProfile
                    },
                    onFailure: { _ in
                        self.error = .signupError
                    }
                )
                .disposed(by: disposeBag)
            
            /*
            self.profileRepository.getProfile(userId: self.user!.id, token: self.userResponse!.accessToken) { [weak self] (result) in
                guard let self = self else {return}
                switch result {
                case .success(let profile):
                    self.userProfile = profile
                case .failure(let error):
                    //error 처리하기
                    print("profile fetch erro")
                }
            }*/
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
    
    func changePassword(newPasword: String){
        repository.changePassword(token: self.userResponse!.accessToken, newPassword: newPasword) { [weak self] (result) in
            guard let self = self else {return}
            switch result {
            case .success(_):
                print("[Log] UserUsecase: Password change success.")
            case .failure(let error):
                self.error = error as LoginError
            }
        }
    }
    
    func changeShoesize(newSize: Int){
        repository.changeUserInfo(token: self.userResponse!.accessToken, shoeSize: newSize) { [weak self] (result) in
            guard let self = self else {return}
            switch result {
            case .success(let user):
                self.user = user
            case .failure(let error):
                self.error = error as LoginError
            }
        }
    }
    
    //TEST 용
    func test_checkIfAccessTokenValid(){
        repository.test_CheckIfValidToken { [weak self] (result) in
            guard let self = self else {return}
            switch result {
            case .success(let bool):
                print(bool)
            case .failure(_):
                print("false")
            }
        }
    }
}
