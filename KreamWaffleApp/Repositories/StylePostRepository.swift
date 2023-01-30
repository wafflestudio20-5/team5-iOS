//
//  StyleTabRepository.swift
//  KreamWaffleApp
//
//  Created by 최성혁 on 2023/01/06.
//

import Foundation
import Alamofire
import RxSwift

final class StylePostRepository {
    let baseUrl = "https://kream-waffle.cf/styles/posts/"

    func requestPost(token: String?, postId: Int, onNetworkFailure: @escaping () -> ()) -> Single<Post> {
        return Single.create { single in
            let urlStr = self.baseUrl + "\(postId)/"
            
            var headers: HTTPHeaders = [
                "accept": "application/json"
            ]
            if let token = token {
                headers.add(name: "Authorization", value: "Bearer \(token)")
            }
            
            AF.request(urlStr, method: .get, headers: headers)
                .validate()
                .responseDecodable(of: Post.self) { response in
                    switch response.result {
                    case .success(let result):
                        debugPrint(response)
                        single(.success(result))
                    case .failure(let error):
                        debugPrint(response)
                        onNetworkFailure()
                        single(.failure(error))
                    }
                }
            return Disposables.create()
        }
    }
    
    func requestLike(token: String, postId: Int, onNetworkFailure: @escaping () -> ()) {
        let urlStr = self.baseUrl + "\(postId)/like/"
        
        let headers: HTTPHeaders = [
            "accept": "application/json",
            "Authorization": "Bearer \(token)"
        ]
        
        AF.request(urlStr, method: .patch, headers: headers)
            .validate()
            .responseString { response in
                switch response.result {
                case .success:
                    debugPrint(response)
                    return
                case .failure:
                    debugPrint(response)
                    onNetworkFailure()
                }
            }
    }
}
