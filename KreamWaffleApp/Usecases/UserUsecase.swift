//
//  UserUsecase.swift
//  KreamWaffleApp
//
//  Created by grace kim  on 2023/01/06.
//

import Foundation
import RxSwift

final class UserUsecase {
    
    private let dataRepository : LoginRepository
    private let disposeBag = DisposeBag()
    var error : Error?
    var user : User?
    
    init(dataRepository : LoginRepository){
        self.dataRepository = dataRepository
    }
    
    func customLogin(email: String, password: String){
        dataRepository.loginAccount(email: email, password: password) { [weak self] (result) in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                self.user = response.user
            case .failure(let error):
                self.error = error as NSError
            }
        }
    }
    
    ///gets user info
    func getUserInfoWithSocialToken(with socialToken: String){
        dataRepository.loginWithNaver(naverToken: socialToken) { [weak self] (result) in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                self.user = response.user
                print("usecase sucess")
                print(response.user.email, ": signed in the usecase")
            case .failure(let error):
                self.error = error as NSError
            }
        }
    }
}

