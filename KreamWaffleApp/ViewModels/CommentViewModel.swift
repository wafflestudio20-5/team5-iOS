//
//  CommentViewModel.swift
//  KreamWaffleApp
//
//  Created by 최성혁 on 2023/02/01.
//

import Foundation
import RxSwift
import RxCocoa

final class CommentViewModel {
    let postTextRelay = BehaviorRelay<String>(value: "")
    private let commentUsecase: CommentUsecase
    private var isAlreadyFetchingDataFromServer = false
    private let id: Int //style탭 포스팅이든 shop탭 상품이든 그 대상 ID
    
    var currentReplyTarget: Int = 0
    
    var isWritingReply = false {
        didSet {
            isWritingReplyRelay.accept(isWritingReply)
        }
    }
    
    let isWritingReplyRelay = BehaviorRelay<Bool>(value: false)
    
    var currentReplyToProfile: ReplyToProfile?

    var commentDidLoad: Observable<Bool> {
        return self.commentUsecase.commentDidLoad.asObservable()
    }
    
    var commentDataSource: [Comment] {
        return self.commentUsecase.commentList
    }
    
    init(commentUsecase: CommentUsecase, id: Int) {
        self.commentUsecase = commentUsecase
        self.id = id
    }
    
    func requestInitialData(token: String) {
        isAlreadyFetchingDataFromServer = true
        self.commentUsecase.requestInitialData(token: token, id: id) { [weak self] in
            self?.isAlreadyFetchingDataFromServer = false
        }
    }
    
    func requestNextData(token: String) {
        if (!isAlreadyFetchingDataFromServer) {
            self.isAlreadyFetchingDataFromServer = true
            self.commentUsecase.requestNextData(token: token, id: id) { [weak self] in
                self?.isAlreadyFetchingDataFromServer = false
            }
        }
    }
    
    func sendComment(token: String, content: String, completion: @escaping ()->(), onNetworkFailure: @escaping () -> ()) {
        self.commentUsecase.sendComment(token: token, content: content, id: id, completion: completion, onNetworkFailure: onNetworkFailure)
    }
    
    func sendReply(token: String, to_profile: String, content: String, completion: @escaping ()->(), onNetworkFailure: @escaping () -> ()) {
        self.commentUsecase.sendReply(token: token, to_profile: to_profile, content: content, replyTarget: currentReplyTarget, completion: completion, onNetworkFailure: onNetworkFailure)
    }
}
