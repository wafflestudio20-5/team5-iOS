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
        
    init(usecase: StyleUsecase) {
        self.usecase = usecase
    }
    
    func getStyleCellModelListAt(index: Int) -> StyleCellModel {
        return self.usecase.styleCellModelList[index]
    }
    
    func getStyleCellModelListNum() -> Int {
        return self.usecase.styleCellModelList.count
    }
    
    func requestStylePostData(page: Int) {
        self.usecase.requestStylePostData(page: page)
    }
}

