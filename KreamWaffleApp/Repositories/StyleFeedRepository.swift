//
//  StyleRepository.swift
//  KreamWaffleApp
//
//  Created by 최성혁 on 2022/12/29.
//

import Foundation
import RxSwift
import Alamofire

final class StyleFeedRepository {
    let baseUrl = "https://kream-waffle.cf/styles/posts/"
    
    func requestPostResponseData(type: String, token: String?, cursor: String?, user_id: Int?, completion: @escaping () -> ()) -> Single<PostResponse> {
        return Single.create { single in
            var urlStr = self.baseUrl + "?type=\(type)"
            if let cursor = cursor {
                urlStr += "&cursor=\(cursor)"
            }
            if let user_id = user_id {
                urlStr += "&user_id=\(user_id)"
            }
            let finalUrl = URL(string: urlStr)
            
            var headers: HTTPHeaders = [
                "accept": "application/json"
            ]
            if let token = token {
                headers.add(name: "Authorization", value: "Bearer \(token)")
            }
            
            AF.request(finalUrl!, method: .get, headers: headers)
                .validate()
                .responseDecodable(of: PostResponse.self) { response in
                    //*****
                    print("\n=================== style feed ======================\n")
                    debugPrint(response)
                    //*****
                    
                    switch response.result {
                    case .success(let result):
                        single(.success(result))
                    case .failure(let error):
                        single(.failure(error))
                    }
                    
                    completion()
                }
            
            return Disposables.create()
        }
    }
}
