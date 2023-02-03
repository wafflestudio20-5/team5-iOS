//
//  ShopCommentRepository.swift
//  KreamWaffleApp
//
//  Created by 최성혁 on 2023/02/01.
//

import Foundation
import RxSwift
import Alamofire

final class ShopCommentRepository {
    private let baseUrl = "https://kream-waffle.cf/shop/"

    func requestInitialCommentData(token: String, productId: Int, completion: @escaping () -> ()) -> Single<CommentResponse> {
        return Single.create { single in
            let finalUrl = self.baseUrl + "productinfos/\(productId)/comments/"
            
            let headers: HTTPHeaders = [
                "accept": "application/json",
                "Authorization": "Bearer \(token)"
            ]
            
            AF.request(finalUrl, method: .get, headers: headers)
                .validate()
                .responseDecodable(of: CommentResponse.self) { response in
                    //**********
                    print("\n=============== shop comment 최초 불러오기 ===============\n")
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
                    print("\n=============== shop comment 이어서 불러오기 ===============\n")
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
    
    func sendComment(token: String, content: String, productId: Int, completion: @escaping ()-> (), onNetworkFailure: @escaping () -> ()) {
        let finalUrl = baseUrl + "productinfos/\(productId)/comments/"
        
        let headers: HTTPHeaders = [
            "Content-Type": "application/json",
            "Authorization": "Bearer \(token)"
        ]
        
        let parameters = [
            "content": content,
        ]
        
        
        AF.request(finalUrl, method: .post, parameters:parameters,encoder:JSONParameterEncoder.default, headers: headers)
            .validate()
            .responseDecodable(of: CommentResponse.self) { response in
                //**********
                print("\n=============== comment 등록 ===============\n")
                debugPrint(response)
                //**********
                
                switch response.result {
                case .success(_):
                    completion()
                case .failure(_):
                    onNetworkFailure()
                }
            }
    }
    
    func deleteComment(commentId: Int, token: String, completion: @escaping ()->(), onNetworkFailure: @escaping ()->()) {
        let urlStr = self.baseUrl + "comments/\(commentId)/"

        let headers: HTTPHeaders = [
            "accept": "application/json",
            "Authorization": "Bearer \(token)"
        ]
        
        AF.request(urlStr, method: .delete, headers: headers)
            .validate()
            .responseString { response in
                debugPrint(response)

                switch response.result {
                case .success:
                    completion()
                case .failure:
                    onNetworkFailure()
                }
            }
    }
}
