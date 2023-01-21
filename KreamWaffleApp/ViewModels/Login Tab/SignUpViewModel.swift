//
//  SignUpViewModel.swift
//  KreamWaffleApp
//
//  Created by grace kim  on 2023/01/21.
//

import Foundation
import UIKit
import RxSwift
import RxRelay

///checks if sign up
class SignUpViewModel{
    let emailTextRelay = BehaviorRelay<String>(value: "")
    let pwTextRelay = BehaviorRelay<String>(value: "")
    let shoeSizeRelay = BehaviorRelay<Int>(value: 0)
    
    let usecase : UserUsecase
    
    init(usecase : UserUsecase){
        self.usecase = usecase
    }
    
    func isValidSignUp() -> Observable<Bool> {
        return Observable.combineLatest(emailTextRelay, pwTextRelay, shoeSizeRelay).map { email, password, size in
            return self.isValidEmail(input: email) && self.isValidPassword(input: password) && (size != 0)
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
    
    public func didTapSignup(){
        Observable.combineLatest(emailTextRelay, pwTextRelay, shoeSizeRelay).map { email, password, size in
            self.usecase.signUp(email: email, password: password, shoeSize: size)
        }
    }
}




   
