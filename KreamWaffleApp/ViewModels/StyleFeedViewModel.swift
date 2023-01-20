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
    private let usecase: StyleFeedUsecase
    private let disposeBag = DisposeBag()
    
    var stylePostDataSource: Observable<[StylePost]> {
        return usecase.stylePostRelay.asObservable()
    }
        
    init(usecase: StyleFeedUsecase) {
        self.usecase = usecase
    }
    
    func requestStylePostData(page: Int) {
        self.usecase.requestStylePostData(page: page)
    }
    
    func getStylePostAt(at index: Int) -> StylePost {
        return self.usecase.stylePostList[index]
    }
    
    func getStylePostListCount() -> Int {
        return self.usecase.stylePostList.count
    }
}

