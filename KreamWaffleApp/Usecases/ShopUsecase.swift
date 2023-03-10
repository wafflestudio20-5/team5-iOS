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
    let filterCategoriesList = ["shoes", "clothes", "fashion", "life", "tech"]
    let filterCategoriesListKor = ["신발", "의류", "패션 잡화", "라이프", "테크"]
    private let filterCategoriesSubject: BehaviorRelay<[String]> = .init(value: ["shoes", "clothes", "fashion", "life", "tech"])
    
    var filterCategories: Observable<[String]> {
        return self.filterCategoriesSubject.asObservable()
    }
    
    // filter items
    let filterItemCategory = ShopFilterItem(header: "카테고리", selection: "모든 카테고리", items: [])
    let priceList = ["10만원 이하", "10만원 - 30만원 이하", "30만원 - 50만원 이하", "50만원 이상"]
    let filterItemBrand = ShopFilterItem(header: "브랜드", selection: "모든 브랜드", items: [])
    let filterItemPrice = ShopFilterItem(header: "가격", selection: "모든 가격", items: [])
    
    private let shopFilterItemsSubject: BehaviorRelay<[ShopFilterItem]> = .init(value: [
        ShopFilterItem(header: "카테고리", selection: "모든 카테고리", items: []),
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
    
    // category
    var categoryRelay = BehaviorRelay<[String]>(value: ["신발", "의류", "패션 잡화", "라이프", "테크"])
    var categoryListObservable: Observable<[String]> {
        return self.categoryRelay.asObservable()
    }
    
    init(repository: ShopRepository) {
        self.repository = repository
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
        self.page += 1
        print("requested page \(self.page)")
        
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
        
    }
}

extension ShopUsecase {
    // immediate delivery tag
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
        self.page += 1
        
        let parameters = ShopPostRequestParameters(page: 1)
        self.repository
            .requestImmediateDeliveryShopPostData(parameters: parameters)
            .subscribe(onSuccess: { [self] fetchedProductInfos in
                var prevProductInfos = self.shopRelay.value
                prevProductInfos.append(contentsOf: fetchedProductInfos)
                self.productInfoList = prevProductInfos
            },
            onFailure: { _ in
                self.productInfoList = []
            })
            .disposed(by: self.disposeBag)
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
        self.page += 1
        
        let parameters = ShopPostRequestParameters(page: 1)
        self.repository
            .requestBrandDeliveryShopPostData(parameters: parameters)
            .subscribe(onSuccess: { [self] fetchedProductInfos in
                var prevProductInfos = self.shopRelay.value
                prevProductInfos.append(contentsOf: fetchedProductInfos)
                self.productInfoList = prevProductInfos
            },
            onFailure: { _ in
                self.productInfoList = []
            })
            .disposed(by: self.disposeBag)
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
    
    func loadMoreCategoryShopPosts(selectedCategory: String) {
        self.page += 1
        
        let parameters = ShopPostRequestParameters(page: 1)
        self.repository
            .requestCategoryShopPostData(parameters: parameters, category: selectedCategory)
            .subscribe(onSuccess: { [self] fetchedProductInfos in
                var prevProductInfos = self.shopRelay.value
                prevProductInfos.append(contentsOf: fetchedProductInfos)
                self.productInfoList = prevProductInfos
            },
            onFailure: { _ in
                self.productInfoList = []
            })
            .disposed(by: self.disposeBag)
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
    
    func loadMoreBrandShopPosts(selectedBrand: Int) {
        self.page += 1
        
        let parameters = ShopPostRequestParameters(page: 1)
        self.repository
            .requestBrandShopPostData(parameters: parameters, brandId: selectedBrand)
            .subscribe(onSuccess: { [self] fetchedProductInfos in
                var prevProductInfos = self.shopRelay.value
                prevProductInfos.append(contentsOf: fetchedProductInfos)
                self.productInfoList = prevProductInfos
            },
            onFailure: { _ in
                self.productInfoList = []
            })
            .disposed(by: self.disposeBag)
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
    
    func loadMoreBrands(page: Int) {
        
        let parameters = ShopPostRequestParameters(page: page)
        self.repository
            .requestBrandsData(parameters: parameters)
            .subscribe(onSuccess: { [self] fetchedBrands in
                var prevBrands = self.brandsRelay.value
                prevBrands.append(contentsOf: fetchedBrands)
                self.brandsList = prevBrands
            },
            onFailure: { _ in
                self.brandsList = []
            })
            .disposed(by: self.disposeBag)
    }
}


extension ShopUsecase {
    // filtered data
    func loadFilteredData(resetPage: Bool, category: [String]?, brands: [Brand]?, prices: [String]?, deliveryTag: Int) {
        if resetPage == true {
            self.productInfoList = []
            let parameters = ShopPostRequestParameters(page: 1)
            self.repository
                .requestFilteredShopPostData(parameters: parameters, category: category, brands: brands, prices: prices, deliveryTag: deliveryTag)
                .subscribe(onSuccess: { [self] fetchedProductInfos in
                    self.productInfoList = fetchedProductInfos
                },
                onFailure: { _ in
                    self.productInfoList = []
                })
                .disposed(by: self.disposeBag)
        }
    }
    
    func loadMoreFilteredData(resetPage: Bool, category: [String]?, brands: [Brand]?, prices: [String]?, deliveryTag: Int, page: Int) {
        if resetPage == false {
            let parameters = ShopPostRequestParameters(page: page)
            self.repository
                .requestFilteredShopPostData(parameters: parameters, category: category, brands: brands, prices: prices, deliveryTag: deliveryTag)
                .subscribe(onSuccess: { [self] fetchedProductInfos in
                    var prevProductInfos = self.shopRelay.value
                    prevProductInfos.append(contentsOf: fetchedProductInfos)
                    self.productInfoList = prevProductInfos
                },
                onFailure: { _ in
                    self.productInfoList = []
                })
                .disposed(by: self.disposeBag)
        }
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
//        print(self.shopFilterItemsSubject.value[index])
        return self.shopFilterItemsSubject.value[index]
//        return self.filterItemPrice
    }
    
    func getFilterItemRowAtIndex(filterItemIndex: Int, rowIndex: Int) -> String {
        if filterItemIndex == 0 {
            return self.filterCategoriesListKor[rowIndex]
        } else if filterItemIndex == 1 {
            return self.brandsList[rowIndex].name
        } else {
            return self.priceList[rowIndex]
        }
    }
    
    func getBrandFilterItemRowAtIndex(filterItemIndex: Int, rowIndex: Int) -> Brand {
        return self.brandsList[rowIndex]
    }
}
