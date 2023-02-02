//
//  CommentRepository.swift
//  KreamWaffleApp
//
//  Created by 최성혁 on 2023/02/01.
//

import Foundation
import RxSwift

protocol CommentRepositoryProtocol {
    func requestInitialCommentData(token: String, id: Int, completion: @escaping () -> ()) -> Single<CommentResponse>
    func requestNextCommentData(token: String, cursor: String, completion: @escaping () -> ()) -> Single<CommentResponse>
    
    func sendComment(token: String, content: String, id: Int, completion: @escaping ()-> (), onNetworkFailure: @escaping () -> ())
    func sendReply(token: String, content: String, replyTarget: Int, completion: @escaping ()->(), onNetworkFailure: @escaping () -> ())
}
