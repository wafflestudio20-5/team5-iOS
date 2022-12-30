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
    
    var styleCellModelList = [StyleCellModel]()
    
    init(usecase: StyleUsecase) {
        self.usecase = usecase
        subscribeStylePostRelay()
    }
    
    func subscribeStylePostRelay() {
        self.usecase.stylePostRelay
            .subscribe { event in //Event<[StylePost]>
                switch event {
                case .next:
                    var list = [StyleCellModel]()
                    event.map { stylePostList in
                        stylePostList.map {
                            list.append(StyleCellModel(stylePost: $0))
                        }
                    }
                    self.styleCellModelList = list
                case .completed:
                    break
                case .error:
                    break
                }
                
            }
            .disposed(by: disposeBag)
    }
}
