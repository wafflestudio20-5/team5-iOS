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
    
    var stylePostList = [Post]() {
        didSet {
            self.stylePostRelay.accept(self.stylePostList)
        }
    }
        
    init (repository: StyleFeedRepository, type: String, user_id: Int?) {
        self.repository = repository
        self.type = type
        self.user_id = user_id
    }
    
    func requestInitialFeed(token: String?, completion: @escaping () -> ()) {
        self.stylePostList.removeAll()
        self.cursor = nil
        requestNextFeed(token: token, completion: completion)
    }
    
    func requestNextFeed(token: String?, completion: @escaping () -> ()) {
        self.repository
            .requestPostResponseData(type: self.type, token: token, cursor: nil, user_id: user_id, completion: completion)
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

