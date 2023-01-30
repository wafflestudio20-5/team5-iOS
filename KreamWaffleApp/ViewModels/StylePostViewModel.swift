//
//  StyleTabDetailViewModel.swift
//  KreamWaffleApp
//
//  Created by 최성혁 on 2023/01/06.
//

import Foundation
import RxSwift

final class StylePostViewModel {
    private let stylePostUsecase: StylePostUsecase
    
    init(stylePostUsecase: StylePostUsecase) {
        self.stylePostUsecase = stylePostUsecase
    }
    
    var stylePostDataSource: Observable<Post?> {
        return self.stylePostUsecase.stylePostRelay.asObservable()
    }
    
    func getThumbnailImageRatio() -> Float {
        return self.stylePostUsecase.getThumbnailImageRatio()
    }
    
    func getImageSourcesCount() -> Int {
        return self.stylePostUsecase.getImageSourcesCount()
    }
    
    func getUserId() -> Int {
        return self.stylePostUsecase.getUserId()
    }
    
    func getPostId() -> Int {
        return self.stylePostUsecase.getPostId()
    }
    
    func requestPost(token: String?, onNetworkFailure: @escaping ()->()) {
        self.stylePostUsecase.requestPost(token: token, onNetworkFailure: onNetworkFailure)
    }
    
    func likeButtonTapped(token: String, onNetworkFailure: @escaping ()->()) {
        self.stylePostUsecase.likeButtonTapped(token: token, onNetworkFailure: onNetworkFailure)
    }
}
