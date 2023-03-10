//
//  StyleTabDetailUsecase.swift
//  KreamWaffleApp
//
//  Created by 최성혁 on 2023/01/17.
//

import Foundation
import RxCocoa
import RxSwift

final class StylePostUsecase {
    private let stylePostRepository: StylePostRepository
    
    private var stylePost: Post? {
        didSet {
            stylePostRelay.accept(stylePost)
        }
    }
    
    private let writerId: Int
    private let postId: Int
    private var thumbnailImageRatio: Float?
    private var imageSourcesCount: Int?
    private let disposeBag = DisposeBag()
    
    let stylePostRelay = PublishRelay<Post?>()
    
    init(stylePostRepository: StylePostRepository, postId: Int, writerId: Int) {
        self.stylePostRepository = stylePostRepository
        self.postId = postId
        self.writerId = writerId
    }
    
    func getImageSourcesCount() -> Int {
        return imageSourcesCount!
    }
    
    func getThumbnailImageRatio() -> Float {
        return self.thumbnailImageRatio!
    }
    
    func getUserId() -> Int {
        return self.stylePost!.created_by.user_id
    }
    
    func getPostId() -> Int {
        return self.postId
    }
        
    func isPostOfOneself(currentUserId: Int?) -> Bool {
        if let currentUserId = currentUserId {
            return currentUserId == self.writerId
        } else {
            return false
        }
    }
    
    func requestPost(token: String?, onNetworkFailure: @escaping () -> ()) {
        self.stylePostRepository
            .requestPost(token: token, postId: self.postId, onNetworkFailure: onNetworkFailure)
            .subscribe { [weak self] event in
                switch event {
                case .success(let post):
                    self?.thumbnailImageRatio = post.image_ratio
                    self?.imageSourcesCount = post.images.count
                    self?.stylePost = post
                case .failure(let error):
                    print(error)
                }
            }
            .disposed(by: disposeBag)
    }
    
    func likeButtonTapped(token: String, onNetworkFailure: @escaping () -> ()) {
        self.stylePostRepository
            .requestLike(token: token, postId: self.postId, onNetworkFailure: onNetworkFailure)
    }
    
    func deletePost(postId: Int, token: String, completion: @escaping ()->(), onNetworkFailure: @escaping ()->()) {
        self.stylePostRepository.deletePost(postId: postId, token: token, completion: completion, onNetworkFailure: onNetworkFailure)
    }
}
