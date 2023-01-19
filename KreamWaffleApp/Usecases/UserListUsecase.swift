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
    
    var userList = [NestedProfile]() {
        didSet {
            self.userListRelay.accept(self.userList)
        }
    }
    
    init(userListRepository: UserListRepositoryProtocol) {
        self.userListRepository = userListRepository
    }
    
    func requestUserListData(page: Int) {
        self.userListRepository.userListApiRequest(page: page) { [weak self] (error, result) in
            guard let self = self else { return }
            self.userList = result!
        }
    }
}
