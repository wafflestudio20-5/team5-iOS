//
//  CommentUsecase.swift
//  KreamWaffleApp
//
//  Created by 최성혁 on 2023/02/01.
//

import Foundation
import RxSwift
import RxCocoa

final class ShopCommentUsecase {
    private let shopCommentRepository: ShopCommentRepository
    private var cursor: String?
    private let disposeBag = DisposeBag()
    
    let commentRelay: BehaviorRelay<[Comment]> = .init(value: [])
    let commentDidLoad: BehaviorRelay<Bool> = .init(value: false)
    
    var commentList = [Comment]() {
        didSet {
            commentDidLoad.accept(true)
            commentRelay.accept(commentList)
        }
    }
    
    init(shopCommentRepository: ShopCommentRepository) {
        self.shopCommentRepository = shopCommentRepository
    }
    
    func requestInitialData(token: String, productId: Int, completion: @escaping ()->()) {
        self.shopCommentRepository
            .requestInitialCommentData(token: token, productId: productId, completion: completion)
            .subscribe { event in
                switch event {
                case .success(let commentResponse):
                    self.cursor = commentResponse.next
                    self.commentList = commentResponse.results
                case .failure(let error):
                    self.cursor = nil
                    self.commentList.removeAll()
                    print(error)
                }
            }
            .disposed(by: disposeBag)
    }
    
    func requestNextData(token: String, completion: @escaping ()->()) {
        if let cursor = self.cursor {
            self.shopCommentRepository
                .requestNextCommentData(token: token, cursor: cursor, completion: completion)
                .subscribe { event in
                    switch event {
                    case .success(let commentResponse):
                        self.cursor = commentResponse.next
                        self.commentList += commentResponse.results
                    case .failure(let error):
                        self.cursor = nil
                        self.commentList.removeAll()
                        print(error)
                    }
                }
                .disposed(by: disposeBag)
        }
        
    }
    
    func sendComment(token: String, content: String, productId: Int, completion: @escaping ()->(), onNetworkFailure: @escaping ()->()) {
        self.shopCommentRepository
            .sendComment(token: token, content: content, productId: productId, completion: completion, onNetworkFailure: onNetworkFailure)
    }
    
    func deleteComment(commentId: Int, token: String, completion: @escaping ()->(), onNetworkFailure: @escaping ()->()) {
        self.shopCommentRepository
            .deleteComment(commentId: commentId, token: token, completion: completion, onNetworkFailure: onNetworkFailure)
    }
}
