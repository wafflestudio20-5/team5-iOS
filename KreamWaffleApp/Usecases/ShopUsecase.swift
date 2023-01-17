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
    private let disposeBag = DisposeBag()
    private var page: Int = 1
    
    var shopRelay = BehaviorRelay<[Product]>(value: [])
    var shopObservable: Observable<[Product]> {
        return self.shopRelay.asObservable()
    }
    
    var productList = [Product]() {
        didSet {
            self.getObserver()
        }
    }

    func getObserver() {
        self.shopRelay.accept(productList)
    }
    
    private let filterCategoriesSubject: BehaviorRelay<[String]> = .init(value: ["신발", "의류", "패션 잡화", "라이프", "테크"])
    
    var filterCategories: Observable<[String]> {
        return self.filterCategoriesSubject.asObservable()
    }
    
    init(repository: ShopRepository) {
        self.repository = repository
//        NotificationCenter.default.addObserver(self,
//                                               selector: #selector(isLikedNotification(_:)),
//                                               name: NSNotification.Name("isLikedNotificationMovie"),
//                                               object: nil)
    }
    
    func loadShopPosts() {
        self.repository.requestShopPostData(page: 1) { [weak self] (error, result) in
            guard let self = self else { return }
            self.productList = result!
        }
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
