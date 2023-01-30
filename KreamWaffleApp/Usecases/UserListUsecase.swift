//
//  UserListUsercase.swift
//  KreamWaffleApp
//
//  Created by 최성혁 on 2023/01/19.
//

import Foundation
import RxSwift
import RxCocoa

final class UserListUsecase {
    var nestedProfileList: [NestedProfile]?
    let userListRepository: UserListRepositoryProtocol
    
    private let disposeBag = DisposeBag()
    let userListRelay: BehaviorRelay<[NestedProfile]> = .init(value: [])
    private var cursor: String?
    
    var userList = [NestedProfile]() {
        didSet {
            self.userListRelay.accept(self.userList)
        }
    }
    
    init(userListRepository: UserListRepositoryProtocol) {
        self.userListRepository = userListRepository
    }
    
    func requestInitialUserList(id: Int, token: String, completion: @escaping () -> ()) {
        userList.removeAll()
        self.cursor = nil
        requestNextUserList(id: id, token: token, completion: completion)
    }
    
    func requestNextUserList(id: Int, token: String, completion: @escaping () -> ()) {
        self.userListRepository
            .requestUserListData(id: id, token: token, cursor: self.cursor, completion: completion)
            .subscribe { event in
                switch event {
                case .success(let userListResponse):
                    self.cursor = userListResponse.next
                    self.userList += userListResponse.results
                case .failure(let error):
                    self.cursor = nil
                    self.userList.removeAll()
                    print(error)
                }
            }
            .disposed(by: disposeBag)
    }
}
