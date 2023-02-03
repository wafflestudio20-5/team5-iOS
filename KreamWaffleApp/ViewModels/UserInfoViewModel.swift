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
    
    //========마이 쇼핑탭에서 쓰이는 정보=======
    
    //설명: Count 은 총 숫자. 마이쇼핑탭에서 쓰임.
    var purchasedProductsCountObservable : Observable<Int>{
        return self.UserUseCase.purchaseProductCountObservable
    }
    
    var purchasedProductsObservable : Observable<[UserProduct]> {
        return self.UserUseCase.purchaseProductObservable
    }
    
    var salesProductObservable : Observable<[UserProduct]> {
        return self.UserUseCase.salesProductObservable
    }
    
    var salesProductCountObservable : Observable<Int>{
        return self.UserUseCase.salesProductCountObservable
    }
    //====================================
    
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
    
    //for my shop tab
    func requestData(myShopType : myShopDataType) {
        self.UserUseCase.loadMyItems(myShopType: myShopType, token: self.UserUseCase.userResponse!.accessToken)
    }
    
    /*
    func requestMoreData(myShopType: myShopDataType) {
        self.UserUseCase.loadMoreShopPosts(myShopType: myShopType, token: self.UserUseCase.userResponse!.accessToken)
    }*/
}
