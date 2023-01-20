//
//  LoginViewModel.swift
//  KreamWaffleApp
//
//  Created by grace kim  on 2023/01/17.
//
import Foundation
import UIKit
import RxSwift
import RxRelay

enum LoginTextfieldType{
    case Email
    case Password
}

///only used in login, signup VCs, shares usecase with user info view model
class LoginViewModel {
    
    private let UserUseCase : UserUsecase
    private let LoginUseCase : LoginUsecase
    
    let bag = DisposeBag()
    
    var Error : LoginError? {
        get {
            self.UserUseCase.error
        }
    }
    
    ///VC observes login state
    var loginState : BehaviorRelay<Bool> {
        get {
            self.UserUseCase.loginState
        }
    }
    
    //bind this value to login button.
    var isValid : Observable<Bool>{
        get {
            self.LoginUseCase.isValid()
        }
    }
    
    func bindTextfield(textfield: UITextField, LoginTextfieldType: LoginTextfieldType){
        switch(LoginTextfieldType){
        case .Email:
            textfield.rx.text
                .orEmpty
                .bind(to: LoginUseCase.emailTextRelay)
                .disposed(by: bag)
            
        case .Password:
            textfield.rx.text
                .orEmpty
                .bind(to: LoginUseCase.pwTextRelay)
                .disposed(by: bag)
        }
    }
    
    init (UserUseCase : UserUsecase, LoginUseCase : LoginUsecase){
        self.UserUseCase = UserUseCase
        self.LoginUseCase = LoginUseCase
    }
    
    func loginUserWithSocial(token: String, socialType: Social){
        self.UserUseCase.socialLogin(socialToken: token, socialType: socialType)
    }
    
    func loginUserWithCustom(email: String, password: String){
        self.UserUseCase.customLogin(email: email, password: password)
    }
    
    func getSavedUser(){
        self.UserUseCase.getSavedUser()
    }
    
    func registerAccount(email: String, password: String, shoeSize: Int){
        self.UserUseCase.signUp(email: email, password: password, shoeSize: shoeSize)
    }
    
    func logout(){
        self.UserUseCase.logout()
    }
    
}
