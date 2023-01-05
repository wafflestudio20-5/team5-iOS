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

final class StyleViewModel {
    private let usecase: StyleUsecase
    private let disposeBag = DisposeBag()
    
    var stylePostDataSource: Observable<[StylePost]> {
        return usecase.stylePostRelay.asObservable()
    }
        
    init(usecase: StyleUsecase) {
        self.usecase = usecase
    }
    
    func getStylePostListAt(at index: Int) -> StylePost {
        return self.usecase.stylePostList[index]
    }
    
    func getStylePostListCount() -> Int {
        return self.usecase.stylePostList.count
    }
    
    func requestStylePostData(page: Int) {
        self.usecase.requestStylePostData(page: page)
    }
}

