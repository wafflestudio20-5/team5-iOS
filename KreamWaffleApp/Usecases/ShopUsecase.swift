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
    
    // filter categories
    private let filterCategoriesSubject: BehaviorRelay<[String]> = .init(value: ["shoes", "clothes", "fashion", "life", "tech"])
    
    var filterCategories: Observable<[String]> {
        return self.filterCategoriesSubject.asObservable()
    }
    
    // filter items
    let priceList = ["10만원 이하", "10만원 - 30만원 이하", "30만원 - 50만원 이하", "50만원 이상"]
    let filterItemBrand = ShopFilterItem(header: "브랜드", selection: "모든 브랜드", items: [])
    let filterItemPrice = ShopFilterItem(header: "가격", selection: "모든 가격", items: [])
    private let shopFilterItemsSubject: BehaviorRelay<[ShopFilterItem]> = .init(value: [
        ShopFilterItem(header: "브랜드", selection: "모든 브랜드", items: []),
        ShopFilterItem(header: "가격", selection: "모든 가격", items: [])
    ])
    var shopFilterItems: Observable<[ShopFilterItem]> {
        return self.shopFilterItemsSubject.asObservable()
    }
    
    var shopFilterItemList: Observable<[String]> {
        return self.pricesRelay.asObservable()
    } // edit
    
    // brands
    var brandsRelay = BehaviorRelay<[Brand]>(value: [])
    var brandFilterItemList: Observable<[Brand]> {
        return self.brandsRelay.asObservable()
    }
//    var brandsObservable: Observable<[Brand]> {
//        return self.brandsRelay.asObservable()
//    }
    
    var brandsList = [Brand]() {
        didSet {
            self.getBrandsObserver()
        }
    }
    func getBrandsObserver() {
        self.brandsRelay.accept(brandsList)
    }
    
    // prices
    var pricesRelay = BehaviorRelay<[String]>(value: ["10만원 이하", "10만원 - 30만원 이하", "30만원 - 50만원 이하", "50만원 이상"])
    var priceFilterItemList: Observable<[String]> {
        return self.pricesRelay.asObservable()
    }
//    var pricesObservable: Observable<[String]> {
//        return self.pricesRelay.asObservable()
//    }
    
    init(repository: ShopRepository) {
        self.repository = repository
//        NotificationCenter.default.addObserver(self,
//                                               selector: #selector(isLikedNotification(_:)),
//                                               name: NSNotification.Name("isLikedNotificationMovie"),
//                                               object: nil)
    }
    
    
}

extension ShopUsecase {
    // request all productinfo
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
    
    func loadMoreShopPosts() {
        if paginating == true {
            return
        }
        paginating = true
        
        self.page += 1
        
        let parameters = ShopPostRequestParameters(page: self.page)
        self.repository
            .requestShopPostData(parameters: parameters)
            .subscribe(onSuccess: { [self] fetchedProductInfos in
                var prevProductInfos = self.shopRelay.value
                prevProductInfos.append(contentsOf: fetchedProductInfos)
                self.productInfoList = prevProductInfos
            },
            onFailure: { _ in
                self.productInfoList = []
            })
            .disposed(by: self.disposeBag)
        
        paginating = false
    }
}

extension ShopUsecase {
    func loadImmediateDeliveryShopPosts() {
        let parameters = ShopPostRequestParameters(page: 1)
        self.repository
            .requestImmediateDeliveryShopPostData(parameters: parameters)
            .subscribe(onSuccess: { [self] fetchedProductInfos in
                self.productInfoList = fetchedProductInfos
            },
            onFailure: { _ in
                self.productInfoList = []
            })
            .disposed(by: self.disposeBag)
    }
    
    func loadMoreImmediateDeliveryShopPosts() {
        
    }
}

extension ShopUsecase {
    func loadBrandDeliveryShopPosts() {
        let parameters = ShopPostRequestParameters(page: 1)
        self.repository
            .requestBrandDeliveryShopPostData(parameters: parameters)
            .subscribe(onSuccess: { [self] fetchedProductInfos in
                self.productInfoList = fetchedProductInfos
            },
            onFailure: { _ in
                self.productInfoList = []
            })
            .disposed(by: self.disposeBag)
    }
    
    func loadMoreBrandDeliveryShopPosts() {
        
    }
}

extension ShopUsecase {
    func loadCategoryShopPosts(selectedCategory: String) {
        let parameters = ShopPostRequestParameters(page: 1)
        self.repository
            .requestCategoryShopPostData(parameters: parameters, category: selectedCategory)
            .subscribe(onSuccess: { [self] fetchedProductInfos in
                self.productInfoList = fetchedProductInfos
            },
            onFailure: { _ in
                self.productInfoList = []
            })
            .disposed(by: self.disposeBag)
    }
    
    func loadMoreCategoryShopPosts() {
        
    }
}

extension ShopUsecase {
    func loadBrandShopPosts(selectedBrand: Int) {
        let parameters = ShopPostRequestParameters(page: 1)
        self.repository
            .requestBrandShopPostData(parameters: parameters, brandId: selectedBrand)
            .subscribe(onSuccess: { [self] fetchedProductInfos in
                self.productInfoList = fetchedProductInfos
            },
            onFailure: { _ in
                self.productInfoList = []
            })
            .disposed(by: self.disposeBag)
    }
    
    func loadMoreBrandShopPosts() {
        
    }
}

extension ShopUsecase {
    func loadBrands() {
        let parameters = ShopPostRequestParameters(page: 1)
        self.repository
            .requestBrandsData(parameters: parameters)
            .subscribe(onSuccess: { [self] fetchedBrands in
                self.brandsList = fetchedBrands
            },
            onFailure: { _ in
                self.brandsList = []
            })
            .disposed(by: self.disposeBag)
    }
    
    func loadMoreBrands() {
        
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
    
    func getFilterItemAtIndex(index: Int) -> ShopFilterItem {
        return self.filterItemPrice
    }
    
//    func getFilterItemListDataSource(index: Int) -> Observable<[String]> {
//        if index == 0 {
//            return self.brandsObservable
//        } else if index == 1 {
//            return self.pricesObservable
//        }
//    }
}
