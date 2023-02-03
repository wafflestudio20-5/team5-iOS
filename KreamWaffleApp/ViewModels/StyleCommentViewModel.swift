//
//  CommentViewModel.swift
//  KreamWaffleApp
//
//  Created by 최성혁 on 2023/02/01.
//

import Foundation
import RxSwift
import RxCocoa

final class StyleCommentViewModel {
    let postTextRelay = BehaviorRelay<String>(value: "")
    private let styleCommentUsecase: StyleCommentUsecase
    private var isAlreadyFetchingDataFromServer = false
    private let postId: Int //style탭 포스팅이든 shop탭 상품이든 그 대상 ID
    
    var currentReplyTarget: Int = 0
    
    var isWritingComment = false {
        didSet {
            isWritingCommentRelay.accept(isWritingComment)
        }
    }
    
    let isWritingCommentRelay = BehaviorRelay<Bool>(value: false)
    
    var currentReplyToProfile: ReplyToProfile?
    
    var commentDataSource: Observable<[Comment]> {
        return self.styleCommentUsecase.commentRelay.asObservable()
    }
    
    init(styleCommentUsecase: StyleCommentUsecase, postId: Int) {
        self.styleCommentUsecase = styleCommentUsecase
        self.postId = postId
    }
    
    func requestInitialData(token: String) {
        isAlreadyFetchingDataFromServer = true
        self.styleCommentUsecase.requestInitialData(token: token, postId: postId) { [weak self] in
            self?.isAlreadyFetchingDataFromServer = false
        }
    }
    
    func sendComment(token: String, content: String, completion: @escaping ()->(), onNetworkFailure: @escaping () -> ()) {
        self.styleCommentUsecase.sendComment(token: token, content: content, postId: postId, completion: completion, onNetworkFailure: onNetworkFailure)
    }
    
    func deleteComment(commentId: Int, token: String, completion: @escaping ()->(), onNetworkFailure: @escaping ()->()) {
        self.styleCommentUsecase.deleteComment(commentId: commentId, token: token, completion: completion, onNetworkFailure: onNetworkFailure)
    }
}
