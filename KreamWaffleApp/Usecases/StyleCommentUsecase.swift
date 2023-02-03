//
//  CommentUsecase.swift
//  KreamWaffleApp
//
//  Created by 최성혁 on 2023/02/01.
//

import Foundation
import RxSwift
import RxCocoa

final class StyleCommentUsecase {
    private let styleCommentRepository: StyleCommentRepository
    private var cursor: String?
    private let disposeBag = DisposeBag()
    
    let commentRelay: BehaviorRelay<[Comment]> = .init(value: [])
    
    var commentList = [Comment]() {
        didSet {
            commentRelay.accept(commentList)
        }
    }
    
    init(styleCommentRepository: StyleCommentRepository) {
        self.styleCommentRepository = styleCommentRepository
    }
    
    func requestInitialData(token: String, postId: Int, completion: @escaping ()->()) {
        self.styleCommentRepository
            .requestInitialCommentData(token: token, postId: postId, completion: completion)
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
    
    func sendComment(token: String, content: String, postId: Int, completion: @escaping ()->(), onNetworkFailure: @escaping ()->()) {
        self.styleCommentRepository
            .sendComment(token: token, content: content, postId: postId, completion: completion, onNetworkFailure: onNetworkFailure)
    }
    
    func deleteComment(commentId: Int, token: String, completion: @escaping ()->(), onNetworkFailure: @escaping ()->()) {
        self.styleCommentRepository
            .deleteComment(commentId: commentId, token: token, completion: completion, onNetworkFailure: onNetworkFailure)
    }
}
