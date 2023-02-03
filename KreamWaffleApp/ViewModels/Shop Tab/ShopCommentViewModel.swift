//
//  CommentViewModel.swift
//  KreamWaffleApp
//
//  Created by 최성혁 on 2023/02/01.
//

import Foundation
import RxSwift
import RxCocoa

final class ShopCommentViewModel {
    let postTextRelay = BehaviorRelay<String>(value: "")
    private let shopCommentUsecase: ShopCommentUsecase
    private var isAlreadyFetchingDataFromServer = false
    private let productId: Int
    
    var currentReplyTarget: Int = 0
    
    var isWritingComment = false {
        didSet {
            isWritingCommentRelay.accept(isWritingComment)
        }
    }
    
    let isWritingCommentRelay = BehaviorRelay<Bool>(value: false)
    
    var currentReplyToProfile: ReplyToProfile?

    var commentDidLoad: Observable<Bool> {
        return self.shopCommentUsecase.commentDidLoad.asObservable()
    }
    
    var commentDataSource: Observable<[Comment]> {
        return self.shopCommentUsecase.commentRelay.asObservable()
    }
    
    init(shopCommentUsecase: ShopCommentUsecase, productId: Int) {
        self.shopCommentUsecase = shopCommentUsecase
        self.productId = productId
    }
    
    func requestInitialData(token: String) {
        isAlreadyFetchingDataFromServer = true
        self.shopCommentUsecase.requestInitialData(token: token, productId: productId) { [weak self] in
            self?.isAlreadyFetchingDataFromServer = false
        }
    }
    
    func requestNextData(token: String) {
        if (!isAlreadyFetchingDataFromServer) {
            self.isAlreadyFetchingDataFromServer = true
            self.shopCommentUsecase.requestNextData(token: token) { [weak self] in
                self?.isAlreadyFetchingDataFromServer = false
            }
        }
    }
    
    func sendComment(token: String, content: String, completion: @escaping ()->(), onNetworkFailure: @escaping () -> ()) {
        self.shopCommentUsecase.sendComment(token: token, content: content, productId: productId, completion: completion, onNetworkFailure: onNetworkFailure)
    }
    
}
