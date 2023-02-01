//
//  StyleUsecase.swift
//  KreamWaffleApp
//
//  Created by 최성혁 on 2022/12/29.
//

import Foundation
import RxCocoa
import RxSwift
import Kingfisher

final class StyleFeedUsecase {
    private let repository: StyleFeedRepository
    private let disposeBag = DisposeBag()
    
    let stylePostRelay: BehaviorRelay<[Post]> = .init(value: [])
    
    private let type: String
    private let user_id: Int?
    
    private var cursor: String?
    private let initialCursor: String
    
    var stylePostList = [Post]() {
        didSet {
            self.stylePostRelay.accept(self.stylePostList)
        }
    }
        
    init (repository: StyleFeedRepository, type: String, user_id: Int?) {
        self.repository = repository
        self.type = type
        self.user_id = user_id
        self.cursor = "https://kream-waffle.cf/styles/posts/?type=\(type)"
        if let user_id = user_id {
            self.cursor! += "&user_id=\(user_id)"
        }
        self.initialCursor = self.cursor!
    }
    
    func requestInitialFeed(token: String?, completion: @escaping () -> ()) {
        self.repository
            .requestPostResponseData(token: token, cursor: initialCursor, completion: completion)
            .subscribe { event in
                switch event {
                case .success(let postResponse):
                    self.cursor = postResponse.next
                    self.stylePostList = postResponse.results
                case .failure(let error):
                    self.cursor = nil
                    self.stylePostList.removeAll()
                    print(error)
                }
                
            }
            .disposed(by: disposeBag)
    }
    
    func requestNextFeed(token: String?, completion: @escaping () -> ()) {
        if let cursor = self.cursor {
            self.repository
                .requestPostResponseData(token: token, cursor: cursor, completion: completion)
                .subscribe { event in
                    switch event {
                    case .success(let postResponse):
                        self.cursor = postResponse.next
                        self.stylePostList += postResponse.results
                    case .failure(let error):
                        self.cursor = nil
                        self.stylePostList.removeAll()
                        print(error)
                    }
                    
                }
                .disposed(by: disposeBag)
        }
    }
}

