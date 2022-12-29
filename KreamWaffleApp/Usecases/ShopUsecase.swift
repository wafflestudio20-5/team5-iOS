//
//  ShopUsecase.swift
//  KreamWaffleApp
//
//  Created by 이선재 on 2022/12/29.
//

import Foundation
import Alamofire
import RxSwift
import RxCocoa

final class ShopUsecase {
    private let repository: ShopRepository
    private let shopSubject: BehaviorRelay<[Product]> = .init(value: [])
    private let disposeBag = DisposeBag()
    private var page: Int = 1
    
    var productList = [Product]() {
        didSet {
            self.shopSubject.accept(self.productList)
        }
    }
    
    var products: Observable<[Product]> {
        return self.shopSubject.asObservable()
    }
    
    init(repository: ShopRepository) {
        self.repository = repository
//        NotificationCenter.default.addObserver(self,
//                                               selector: #selector(isLikedNotification(_:)),
//                                               name: NSNotification.Name("isLikedNotificationMovie"),
//                                               object: nil)
    }
    
    func requestProducts() {
//        let parameters = ShopRequestModel(page: self.page)
        
//        self.repository
//            .requestProducts(parameters: parameters)
//            .subscribe(onSuccess: { [weak self] fetchedProducts in
//                self?.productList = fetchedProducts
//            },
//            onFailure: { _ in
//                self.productList = []
//            })
//            .disposed(by: self.disposeBag)
    }
    
//    func loadMoreProducts() {
//        self.page += 1
//        let parameters = ShopRequestModel(page: self.page)
//
//        self.repository
//            .requestProducts(parameters: parameters)
//            .subscribe(onSuccess: { [weak self] fetchedProducts in
//                var prevProducts = self?.shopSubject.value ?? []
//                prevProducts.append(contentsOf: fetchedProducts)
//                self?.productList = prevProducts
//            },
//            onFailure: { _ in
//                self.productList = []
//            })
//            .disposed(by: self.disposeBag)
//    }
    
    func getProductAtIndex(index: Int) -> Product {
        return self.productList[index]
    }
}
