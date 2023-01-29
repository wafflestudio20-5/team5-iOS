//
//  StyleViewModel.swift
//  KreamWaffleApp
//
//  Created by 최성혁 on 2022/12/29.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

final class StyleFeedViewModel {
    private let styleFeedUsecase: StyleFeedUsecase
    private let disposeBag = DisposeBag()
    
    var stylePostDataSource: Observable<[Post]> {
        return styleFeedUsecase.stylePostRelay.asObservable()
    }
        
    init(styleFeedUsecase: StyleFeedUsecase) {
        self.styleFeedUsecase = styleFeedUsecase
    }
    
    func requestStylePostData(page: Int) {
        self.styleFeedUsecase.requestStylePostData(page: page)
    }
    
    func getStylePostAt(at index: Int) -> Post {
        return self.styleFeedUsecase.stylePostList[index]
    }
    
    func getStylePostListCount() -> Int {
        return self.styleFeedUsecase.stylePostList.count
    }
}

