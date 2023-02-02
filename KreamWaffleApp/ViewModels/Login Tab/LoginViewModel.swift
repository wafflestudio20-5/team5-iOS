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

///only used in Login VC. Returns if the textfields are valid, and sends request / gets info.
class LoginViewModel {
    
    let UserUseCase : UserUsecase
    
    let emailTextRelay = BehaviorRelay<String>(value: "")
    let pwTextRelay = BehaviorRelay<String>(value: "")
    
    let bag = DisposeBag()
    
    var Error : LoginError? {
        get {
            self.UserUseCase.error
        }
    }
    
    var errorRelay: BehaviorRelay<LoginError> {
        get {
            self.UserUseCase.errorRelay
        }
    }
    
    var user : User? {
        get {
            self.UserUseCase.user
        }
    }
    
    ///VC observes login state
    var loginState : BehaviorRelay<Bool> {
        get {
            self.UserUseCase.loginState
        }
    }
    
    func isValid() -> Observable<Bool> {
        return Observable.combineLatest(emailTextRelay, pwTextRelay).map { email, password in
            return self.isValidEmail(input: email) && self.isValidPassword(input: password)
        }
    }
    
    func bindTextfield(textfield: UITextField, LoginTextfieldType: LoginTextfieldType){
        switch(LoginTextfieldType){
        case .Email:
            textfield.rx.text
                .orEmpty
                .bind(to: self.emailTextRelay)
                .disposed(by: bag)
            
        case .Password:
            textfield.rx.text
                .orEmpty
                .bind(to: self.pwTextRelay)
                .disposed(by: bag)
        }
    }
    
    public func isValidPassword(input: String)->Bool{
        let passwordRegex = "^(?=.*[a-z])(?=.*[$@$#!%*?&]).{8,}$"
        let passwordPred = NSPredicate(format: "SELF MATCHES %@", passwordRegex)
        return passwordPred.evaluate(with: input)
    }
    
    public func isValidEmail(input: String) -> Bool{
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: input)
    }
    
    
    
    init (UserUseCase : UserUsecase){
        self.UserUseCase = UserUseCase
    }
    
    func loginUserWithSocial(token: String, socialType: Social){
        self.UserUseCase.socialLogin(socialToken: token, socialType: socialType)
    }
    
    func loginUserWithCustom(){
        let email = self.emailTextRelay.value
        let password = self.pwTextRelay.value
        self.UserUseCase.customLogin(email: email, password: password)
    }
    
    func getSavedUser(){
        self.UserUseCase.getSavedUser()
    }
    
    func registerAccount(email: String, password: String, shoeSize: Int){
        self.UserUseCase.signUp(email: email, password: password, shoeSize: shoeSize)
    }
    
    func checkAccessToken() async -> Bool{
        return await self.UserUseCase.checkAccessToken()
    }
    
    func logout(){
        self.UserUseCase.logout()
    }
    
    func changePassword(newPassword: String){
        self.UserUseCase.changePassword(newPasword: newPassword)
    }
    
    func changeShoesize(newSize: Int){
        self.UserUseCase.changeShoesize(newSize: newSize)
    }
    
}
