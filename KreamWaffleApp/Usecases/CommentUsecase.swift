//
//  CommentUsecase.swift
//  KreamWaffleApp
//
//  Created by 최성혁 on 2023/02/01.
//

import Foundation

enum CommentUsecaseType {
    case postComment
    case productComment
}

final class CommentUsecase {
    private let commentRepository: CommentRepositoryProtocol
    private var cursor: String?
    
    init(commentRepository: CommentRepositoryProtocol, type: CommentUsecaseType) {
        self.commentRepository = commentRepository
    }
}
