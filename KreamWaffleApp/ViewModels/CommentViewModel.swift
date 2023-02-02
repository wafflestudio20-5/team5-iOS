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
    
    var isWritingComment = false {
        didSet {
            isWritingCommentRelay.accept(isWritingComment)
        }
    }
    
    let isWritingCommentRelay = BehaviorRelay<Bool>(value: false)
    
    var currentReplyToProfile: ReplyToProfile?

    var commentDidLoad: Observable<Bool> {
        return self.commentUsecase.commentDidLoad.asObservable()
    }
    
    var commentDataSource: Observable<[Comment]> {
        return self.commentUsecase.commentRelay.asObservable()
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
    
}
