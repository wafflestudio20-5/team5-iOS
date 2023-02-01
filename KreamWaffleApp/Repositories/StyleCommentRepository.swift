//
//  StyleCommentRepository.swift
//  KreamWaffleApp
//
//  Created by 최성혁 on 2023/02/01.
//

import Foundation
import RxSwift
import Alamofire

final class StyleCommentRepository: CommentRepositoryProtocol {
    private let baseUrl = "https://kream-waffle.cf/styles/posts/"

    func requestInitialCommentData(token: String, id: Int, completion: @escaping () -> ()) -> Single<CommentResponse> {
        return Single.create { single in
            let finalUrl = self.baseUrl + "\(id)/comments/"
            
            let headers: HTTPHeaders = [
                "accept": "application/json",
                "Authorization": "Bearer \(token)"
            ]
            
            AF.request(finalUrl, method: .get, headers: headers)
                .validate()
                .responseDecodable(of: CommentResponse.self) { response in
                    //**********
                    print("\n=============== style comment 최초 불러오기 ===============\n")
                    debugPrint(response)
                    //**********
                    
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
    
    func requestNextCommentData(token: String, cursor: String, completion: @escaping () -> ()) -> Single<CommentResponse> {
        return Single.create { single in
                
            let headers: HTTPHeaders = [
                "accept": "application/json",
                "Authorization": "Bearer \(token)"
            ]
            
            AF.request(cursor, method: .get, headers: headers)
                .validate()
                .responseDecodable(of: CommentResponse.self) { response in
                    //**********
                    print("\n=============== style comment 이어서 불러오기 ===============\n")
                    debugPrint(response)
                    //**********
                    
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
