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
    func requestPostResponseData(token: String?, cursor: String, completion: @escaping () -> ()) -> Single<PostResponse> {
        return Single.create { single in
            let finalUrl = URL(string: cursor)
            
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
