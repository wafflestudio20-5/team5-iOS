//
//  FollowingUserListRepository.swift
//  KreamWaffleApp
//
//  Created by 최성혁 on 2023/01/19.
//

import Foundation
import RxSwift
import RxCocoa
import Alamofire

final class FollowingUserListRepository: UserListRepositoryProtocol {
    let baseUrl = "https://kream-waffle.cf/styles/profiles/"

    func requestUserListData(id: Int, token: String, cursor: String?, completion: @escaping () -> ()) -> Single<UserListResponse> {
        return Single.create { single in
            var urlStr = self.baseUrl + "\(id)/followings/"
            if let cursor = cursor {
                urlStr += "?cursor=\(cursor)"
            }
            let finalUrl = URL(string: urlStr)
            
            let headers: HTTPHeaders = [
                "accept": "application/json",
                "Authorization": "Bearer \(token)"
            ]
            
            AF.request(finalUrl!, method: .get, headers: headers)
                .validate()
                .responseDecodable(of: UserListResponseWithToAtPrefix.self) { response in
                    print("\n================following for user \(id)================\n")
                    debugPrint(response)

                    switch response.result {
                    case .success(let result):
                        single(.success(UserListResponse.init(next: result.next, previous: result.previous, results: result.results.map { $0.nestedProfile })))
                    case .failure(let error):
                        single(.failure(error))
                    }
                    
                    completion()
                }
            
            return Disposables.create()
        }
    }
}
