//
//  StyleViewModel.swift
//  KreamWaffleApp
//
//  Created by 최성혁 on 2022/12/29.
//

import Foundation
import UIKit
import RxSwift

final class StyleViewModel {
    private let usecase: StyleUsecase
    
    var styleDataSource: Observable<[StylePost]> {
        return self.usecase.stylePostRelay.asObservable()
    }
    
    init(usecase: StyleUsecase) {
        self.usecase = usecase
    }
}
