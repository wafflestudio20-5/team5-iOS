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

    var commentDataSource: Observable<[Comment]> {
        return self.commentUsecase.commentRelay.asObservable()
    }
    
    init(commentUsecase: CommentUsecase) {
        self.commentUsecase = commentUsecase
    }
}
