//
//  CommentRepository.swift
//  KreamWaffleApp
//
//  Created by 최성혁 on 2023/02/01.
//

import Foundation
import RxSwift

protocol CommentRepositoryProtocol {
    func requestInitialCommentData(token: String, id: Int, completion: @escaping () -> ()) -> Single<[Comment]>
    
    func sendComment(token: String, content: String, id: Int, completion: @escaping ()-> (), onNetworkFailure: @escaping () -> ())
    
    func deleteComment(commentId: Int, token: String, completion: @escaping ()->(), onNetworkFailure: @escaping ()->()) 
}
