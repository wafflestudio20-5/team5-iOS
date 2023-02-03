//
//  CommentUsecase.swift
//  KreamWaffleApp
//
//  Created by 최성혁 on 2023/02/01.
//

import Foundation
import RxSwift
import RxCocoa

final class CommentUsecase {
    private let commentRepository: CommentRepositoryProtocol
    private var cursor: String?
    private let disposeBag = DisposeBag()
    
    let commentRelay: BehaviorRelay<[Comment]> = .init(value: [])
    
    var commentList = [Comment]() {
        didSet {
            commentRelay.accept(commentList)
        }
    }
    
    init(commentRepository: CommentRepositoryProtocol) {
        self.commentRepository = commentRepository
    }
    
    func requestInitialData(token: String, id: Int, completion: @escaping ()->()) {
        self.commentRepository
            .requestInitialCommentData(token: token, id: id, completion: completion)
            .subscribe { event in
                switch event {
                case .success(let comments):
                    self.commentList = comments
                case .failure(let error):
                    self.commentList.removeAll()
                    print(error)
                }
            }
            .disposed(by: disposeBag)
    }
    
    func sendComment(token: String, content: String, id: Int, completion: @escaping ()->(), onNetworkFailure: @escaping ()->()) {
        self.commentRepository
            .sendComment(token: token, content: content, id: id, completion: completion, onNetworkFailure: onNetworkFailure)
    }
    
    func deleteComment(commentId: Int, token: String, completion: @escaping ()->(), onNetworkFailure: @escaping ()->()) {
        self.commentRepository
            .deleteComment(commentId: commentId, token: token, completion: completion, onNetworkFailure: onNetworkFailure)
    }
}
