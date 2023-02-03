//
//  ShopCommentRepository.swift
//  KreamWaffleApp
//
//  Created by 최성혁 on 2023/02/01.
//

import Foundation
import RxSwift
import Alamofire

final class ShopCommentRepository: CommentRepositoryProtocol {
    private let baseUrl = "https://kream-waffle.cf/shop/"

    func requestInitialCommentData(token: String, id: Int, completion: @escaping () -> ()) -> Single<[Comment]> {
        return Single.create { single in
            let finalUrl = self.baseUrl + "productinfos/\(id)/comments/"
            
            let headers: HTTPHeaders = [
                "accept": "application/json",
                "Authorization": "Bearer \(token)"
            ]
            
            AF.request(finalUrl, method: .get, headers: headers)
                .validate()
                .responseDecodable(of: [Comment].self) { response in
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
    
    func sendComment(token: String, content: String, id: Int, completion: @escaping ()-> (), onNetworkFailure: @escaping () -> ()) {
        let finalUrl = baseUrl + "productinfos/\(id)/comments/"
        
        let headers: HTTPHeaders = [
            "Content-Type": "application/json",
            "Authorization": "Bearer \(token)"
        ]
        
        let parameters = [
            "content": content,
        ]
        
        
        AF.request(finalUrl, method: .post, parameters:parameters,encoder:JSONParameterEncoder.default, headers: headers)
            .validate()
            .responseDecodable(of: Comment.self) { response in
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
