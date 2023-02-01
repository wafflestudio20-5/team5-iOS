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
    private let id: Int


    var commentDataSource: Observable<[Comment]> {
        return self.commentUsecase.commentRelay.asObservable()
    }
    
    init(commentUsecase: CommentUsecase, id: Int) {
        self.commentUsecase = commentUsecase
        self.id = id
    }
    
    var commentCount: Int {
        get {
            self.commentUsecase.commentList.count
        }
    }
    
    func replyCountOfComment(at index: Int) -> Int {
        return self.commentUsecase.commentList[index].replies.count
    }
    
    func getComment(at index: Int) -> Comment {
        return self.commentUsecase.commentList[index]
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
}
