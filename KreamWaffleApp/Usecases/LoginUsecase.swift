//
//  LoginUsecase.swift
//  KreamWaffleApp
//
//  Created by grace kim  on 2023/01/17.
//
import UIKit
import RxSwift
import RxCocoa
import RxRelay

final class LoginUsecase{
    private let repository : LoginRepository
    private let disposeBag = DisposeBag()
    
    let emailTextRelay = BehaviorRelay<String>(value: "")
    let pwTextRelay = BehaviorRelay<String>(value: "")
    
    init(repository: LoginRepository){
        self.repository = repository
    }
    
    func isValid() -> Observable<Bool> {
        return Observable.combineLatest(emailTextRelay, pwTextRelay).map { email, password in
            return self.isValidEmail(input: email) && self.isValidPassword(input: password)
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
}
