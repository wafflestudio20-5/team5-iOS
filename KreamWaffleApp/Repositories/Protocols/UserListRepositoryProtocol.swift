//
//  UserListRepository.swift
//  KreamWaffleApp
//
//  Created by 최성혁 on 2023/01/19.
//

import Foundation
import RxSwift
/*
 userListApiRequest: 유저 리스트를 pagination 따라 불러오는 함수.
 */


protocol UserListRepositoryProtocol {
    func requestUserListData(id: Int, token: String, cursor: String?, completion: @escaping ()->()) -> Single<UserListResponse>
}
