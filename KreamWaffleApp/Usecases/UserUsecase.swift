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
    private let userShopRepository : UserShopRepository
    private let disposeBag = DisposeBag()
    
    var user : User?
    var userResponse : UserResponse?
    
    var userProfile : Profile? {
        didSet {
            if let userProfile = userProfile {
                profileRelay.accept(userProfile)
            }
        }
    }
    
    var profileRelay: BehaviorRelay<Profile> = .init(value: Profile())
    
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
    var loginState = BehaviorRelay<Bool>(value: false)
    
    var errorRelay = BehaviorRelay<LoginError>(value: .noError)
    
    // MARK: For my tab========
    
    // productinfo
    var purchaseProductRelay = BehaviorRelay<[UserProduct]>(value:[])
    var purchaseProductObservable: Observable<[UserProduct]> {
        return self.purchaseProductRelay.asObservable()
    }
    var purchaseProductList = [UserProduct](){
        didSet {
            self.getPurchaseProductObserver()
        }
    }
    func getPurchaseProductObserver(){
        self.purchaseProductRelay.accept(purchaseProductList)
    }
    
    var purchasedProductCountRelay = BehaviorRelay<Int>(value: 0)
    var purchaseProductCountObservable: Observable<Int> {
        return self.purchasedProductCountRelay.asObservable()
    }

    
    var salesProductRelay = BehaviorRelay<[UserProduct]>(value: [])
    var salesProductObservable : Observable<[UserProduct]> {
        return self.salesProductRelay.asObservable()
    }
    var salesProductList = [UserProduct](){
        didSet {
            self.getSalesProductObserver()
        }
    }
    func getSalesProductObserver(){
        self.salesProductRelay.accept(salesProductList)
    }
    var salesProductCountRelay = BehaviorRelay<Int>(value: 0)
    var salesProductCountObservable: Observable<Int> {
        return self.salesProductCountRelay.asObservable()
    }
    
    private var page: Int = 1
    private var paginating = false
    
    //================
    
    init(dataRepository : LoginRepository, profileRepository: ProfileRepository, UserShopRepository: UserShopRepository){
        self.repository = dataRepository
        self.profileRepository = profileRepository
        self.userShopRepository = UserShopRepository
        self.error = .noError
        self.loggedIn = false
    }
    
    //MARK: related to log in, log out, sign up
    //TODO: 여기 좀 걱정됨. checkAccessToken 도 안하고 Login 해도 되나?
    ///signs in user with user defaults
    func getSavedUser(){
        Task {
        if let savedUserResponse = repository.getUserResponse(){
       self.userResponse = savedUserResponse
        await self.checkAccessToken()
       self.loggedIn = true
     self.user = savedUserResponse.user
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
                    if (error == .invalidRefreshTokenError){
                        self.logout()
                    }
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
        }
    
    
    ///logging out deletes saved/current user and initializes parameters.
    func logout(){
        repository.logOutUser()
        self.userResponse = nil
        self.user = nil
        self.loggedIn = false
        self.errorRelay = BehaviorRelay<LoginError>.init(value: .noError)
        self.profileRelay = BehaviorRelay<Profile>.init(value: Profile())
        self.userProfile = nil
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
    
    func updateProfile(Profile: Profile){
        profileRepository.updateUserProfile(profile: Profile, userId: self.user!.id , accessToken: self.userResponse!.accessToken){ [weak self] (result) in
            guard let self = self else { return }
            switch result {
            case .success(let bool):
                print("update 완료")
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func updatePartialProfile(newValue: String, editCase: editCase){
        profileRepository.updatePartialUserProfile(newValue: newValue, editCase: editCase, userId: self.user!.id, accessToken: self.userResponse!.accessToken) { [weak self] (result) in
            guard let self = self else { return }
            switch result {
            case .success(let bool):
                print("update 완료")
            case .failure(let error):
                print(error)
            }
        }
    }
    
    //delete save user
    func deleteUser(){
        repository.deleteUser(token: self.userResponse!.accessToken) { [weak self] (result) in
            guard let self = self else {return}
            self.error = result as LoginError
        }
    }
}

//related to my tab products
extension UserUsecase {
    func loadMyItems(myShopType: myShopDataType, token: String) {
        let parameters = ShopPostRequestParameters(page: 1)
        self.userShopRepository
            .requestShopPostData(parameters: parameters, token: token, myShopType: myShopType)
            .subscribe(onSuccess: { [self] fetchedProductInfos in
                switch(myShopType){
                case .purchase:
                    self.purchasedProductCountRelay.accept(fetchedProductInfos.count)
                    self.purchaseProductList = fetchedProductInfos.itemList
                case .sale:
                    self.salesProductCountRelay.accept(fetchedProductInfos.count)
                    self.salesProductList = fetchedProductInfos.itemList
                }
            },
            onFailure: { _ in
                self.purchaseProductList = []
                self.salesProductList = []
            })
            .disposed(by: self.disposeBag)
    }
    
    /* --> 만약 pagination 한다면 사용. 
    func loadMoreShopPosts(myShopType: myShopDataType, token: String) {
        self.page += 1
        print("requested page \(self.page)")
        let parameters = ShopPostRequestParameters(page: self.page)
        self.userShopRepository
            .requestShopPostData(parameters:parameters, token: token, myShopType: myShopType)
            .subscribe(onSuccess: { [self] fetchedProductInfos in
                //TODO: pagination?
                //self.productRelay.append(contentsOf: fetchedProductInfos.itemList)
                //self.productInfoList = prevProductInfos
            },
            onFailure: { _ in
                self.productInfoList = []
            })
            .disposed(by: self.disposeBag)
        
    }*/
}
