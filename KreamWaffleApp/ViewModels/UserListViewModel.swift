//
//  File.swift
//  KreamWaffleApp
//
//  Created by 최성혁 on 2023/01/19.
//

import Foundation
import RxSwift

class UserListViewModel {
    let userListUsecase: UserListUsecase
    private let disposeBag = DisposeBag()
    
    init(userListUsecase: UserListUsecase) {
        self.userListUsecase = userListUsecase
    }
    
    var userListDataSource: Observable<[NestedProfile]> {
        return userListUsecase.userListRelay.asObservable()
    }
    
    func requestUserListData(page: Int) {
        self.userListUsecase.requestUserListData(page: page)
    }
}
