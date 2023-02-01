//
//  File.swift
//  KreamWaffleApp
//
//  Created by 최성혁 on 2023/01/19.
//

import Foundation
import RxSwift

class UserListViewModel {
    private let userListUsecase: UserListUsecase
    private let disposeBag = DisposeBag()
    private var isAlreadyFetchingDataFromServer = false
    
    init(userListUsecase: UserListUsecase) {
        self.userListUsecase = userListUsecase
    }
    
    var userListDataSource: Observable<[NestedProfile]> {
        return userListUsecase.userListRelay.asObservable()
    }
    
    func requestInitialUserList(id: Int, token: String) {
        self.isAlreadyFetchingDataFromServer = true
        self.userListUsecase.requestInitialUserList(id: id, token: token) { [weak self] in
            self?.isAlreadyFetchingDataFromServer = false
        }
    }
    
    func requestNextUserList(id: Int, token: String) {
        if (!isAlreadyFetchingDataFromServer) {
            self.isAlreadyFetchingDataFromServer = true
            self.userListUsecase.requestNextUserList(id: id, token: token) { [weak self] in
                self?.isAlreadyFetchingDataFromServer = false
            }
        }
    }
}
