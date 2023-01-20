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
    private var paginating = false
    
    
    // productinfo
    var shopRelay = BehaviorRelay<[Product]>(value: [])
    var shopObservable: Observable<[Product]> {
        return self.shopRelay.asObservable()
    }
    
    var productInfoList = [Product]() {
        didSet {
//            for product in productInfoList {
//                self.loadProductImages(shopPost: product)
//            }
            
            self.getProductInfoObserver()
        }
    }
    func getProductInfoObserver() {
        self.shopRelay.accept(productInfoList)
    }
    
    // productimages
    var productImagesRelay = BehaviorRelay<[String]>(value: [])
    var productImagesObservable: Observable<[String]> {
        return self.productImagesRelay.asObservable()
    }
    
    var productImagesList = [String]() {
        didSet {
            self.getProductImagesObserver()
        }
    }
    func getProductImagesObserver() {
        self.productImagesRelay.accept(productImagesList)
    }
    
    // filters
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
    
    
}

extension ShopUsecase {
    // productinfo
    func loadShopPosts() {
        let parameters = ShopPostRequestParameters(page: 1)
        self.repository
            .requestShopPostData(parameters: parameters)
            .subscribe(onSuccess: { [self] fetchedProductInfos in
                self.productInfoList = fetchedProductInfos
            },
            onFailure: { _ in
                self.productInfoList = []
            })
            .disposed(by: self.disposeBag)
    }
    
    func requestShopPostBrand(product: Product) {
//        self.repository.requestShopPostBrand(brandId: product.brand) { (error, brandName) in
//            product.brand_name = brandName!
////            product.setBrandName(brandName: brandName!)
//        }
            
    }
    
    
    
    func loadMoreShopPosts() {
        if paginating == true {
            return
        }
        paginating = true
        
        self.page += 1
        print("requested productinfo page \(self.page)")
        
        let parameters = ShopPostRequestParameters(page: self.page)
        self.repository
            .requestShopPostData(parameters: parameters)
            .subscribe(onSuccess: { [self] fetchedProductInfos in
                var prevProductInfos = self.shopRelay.value
                prevProductInfos.append(contentsOf: fetchedProductInfos)
                self.productInfoList = prevProductInfos
//                for product in self.productInfoList {
//                    requestShopPostBrand(product: &product)
//                }
            },
            onFailure: { _ in
                self.productInfoList = []
            })
            .disposed(by: self.disposeBag)
        
        paginating = false
    }
}

extension ShopUsecase {
    // get functions
    
    func getProductAtIndex(index: Int) -> Product {
        return self.productInfoList[index]
    }
    
    func getProductImageUrlAt(id: Int) -> String {
        return self.productImagesList[id]
    }
}
