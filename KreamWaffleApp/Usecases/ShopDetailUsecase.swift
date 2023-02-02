//
//  ShopDetailUsecase.swift
//  KreamWaffleApp
//
//  Created by 이선재 on 2023/02/02.
//

import Foundation
import Alamofire
import RxSwift
import RxCocoa

final class ShopDetailUsecase {
    private let repository: ShopDetailRepository
    private let disposeBag = DisposeBag()
    
    var productSizeInfoList = [ProductSize]() {
        didSet {
            self.getProductSizeInfoObserver()
        }
    }
    func getProductSizeInfoObserver() {
        self.sizeRelay.accept(productSizeInfoList)
    }
    var sizeRelay = BehaviorRelay<[ProductSize]>(value: [])
    var productSizeInfoObservable: Observable<[ProductSize]> {
        return self.sizeRelay.asObservable()
    }
    
    init(repository : ShopDetailRepository){
        self.repository = repository

    }
    
    func loadProductSizeInfo(id: Int) {
//        let parameters = ShopPostRequestParameters(page: 1)
        self.repository
            .requestProductSizeInfo(id: id)
            .subscribe(onSuccess: { [self] fetchedProductSizeInfos in
                self.productSizeInfoList = fetchedProductSizeInfos
            },
            onFailure: { _ in
                self.productSizeInfoList = []
            })
            .disposed(by: self.disposeBag)
    }
}
