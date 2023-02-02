//
//  EditAccountVIewModel.swift
//  KreamWaffleApp
//
//  Created by grace on 2023/02/02.
//

import Foundation
import UIKit
import RxSwift
import RxRelay

///used for editing login account and profile
class EditAccountViewModel {
    
    var usecase : UserUsecase
    
    //더미..
    var dummyRelay =  BehaviorRelay<Bool>(value: true)
    
    //로그인 정보 탭에서 사용하는 릴레이
    var pwTextRelay =  BehaviorRelay<String>(value: "**********")
    var shoeSizeRelay: BehaviorRelay<Int>
    
    //프로필 관리 탭에서 사용하는 릴레이
    var profileNameRelay: BehaviorRelay<String>
    var userNameRelay:  BehaviorRelay<String>
    var bioRelay: BehaviorRelay<String>
    
    init(usecase: UserUsecase){
        self.usecase = usecase
        shoeSizeRelay = BehaviorRelay<Int>(value: usecase.user?.shoeSize ?? 0)
        profileNameRelay = BehaviorRelay<String>(value: self.usecase.userProfile?.profile_name ?? "")
        userNameRelay = BehaviorRelay<String>(value: self.usecase.userProfile?.user_name ?? "")
        bioRelay = BehaviorRelay<String>(value: self.usecase.userProfile?.introduction ?? "나를 소개하세요")
    }
    
    var user : User {
        get {
            self.usecase.user!
        }
    }
    
    //로그인 정보 탭에서 사용하는 함수들
    func changePassword(){
        let password = self.pwTextRelay.value
        self.usecase.changePassword(newPasword: password)
    }
    
    func isValidPasswordRelay() -> Observable<Bool> {
        Observable.combineLatest(dummyRelay, pwTextRelay).map { dummy, password in
            return self.isValidPassword(input: password)
        }
    }
    
    public func isValidPassword(input: String)->Bool{
        let passwordRegex = "^(?=.*[a-z])(?=.*[$@$#!%*?&]).{8,}$"
        let passwordPred = NSPredicate(format: "SELF MATCHES %@", passwordRegex)
        return passwordPred.evaluate(with: input)
    }
    
    func changeShoeSize(){
        let size = self.shoeSizeRelay.value
        self.usecase.changeShoesize(newSize: size)
    }
    
    
    //=======================================
    //프로필 관리 탭에서 사용하는 함수들
    func changeProfileName(){
        let profileName = self.profileNameRelay.value
        
    }
    
    
    func logout(){
        self.usecase.logout()
    }
   
    
}
