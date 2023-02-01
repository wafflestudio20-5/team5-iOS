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
    
    let commentRelay: BehaviorRelay<[Comment]> = .init(value: [])
    
    var commentList = [Comment]() {
        didSet {
            self.commentRelay.accept(self.commentList)
        }
    }
    
    init(commentRepository: CommentRepositoryProtocol) {
        self.commentRepository = commentRepository
        
    }
    
    
}
