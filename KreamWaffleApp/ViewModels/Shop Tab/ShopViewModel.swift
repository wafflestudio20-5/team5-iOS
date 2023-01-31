//
//  ViewModel.swift
//  KreamWaffleApp
//
//  Created by 이선재 on 2022/12/24.
//
import Foundation
import Alamofire
import RxSwift

final class ShopViewModel {
    private let usecase: ShopUsecase
    
    init(usecase: ShopUsecase) {
        self.usecase = usecase
        requestData()
    }
    
    var shopDataSource: Observable<[ProductData]> {
        return self.usecase.shopObservable
            .map { product in
                return product.map { ProductData(product: $0) }
            }
    }
    
    var filterDataSource: Observable<[String]> {
        return self.usecase.filterCategories
    }
    
    var filterItemDataSource: Observable<[ShopFilterItem]> {
        return self.usecase.shopFilterItems
    }
    
    var brandFilterItemListDataSource: Observable<[Brand]> {
        return self.usecase.brandFilterItemList
    }
    
    var priceFilterItemListDataSource: Observable<[String]> {
        return self.usecase.priceFilterItemList
    }
}

extension ShopViewModel {
    // request all shopPosts
    func requestData() {
        self.usecase.loadShopPosts()
    }
    
    func requestMoreData() {
        self.usecase.loadMoreShopPosts()
    }
    
    func getProductAtIndex(index: Int) -> Product {
        return self.usecase.getProductAtIndex(index: index)
    }
    
    func getFilterItemAtIndex(index: Int) -> ShopFilterItem {
        return self.usecase.getFilterItemAtIndex(index: index)
    }
    

}

extension ShopViewModel {
    // request immediate delivery shopPosts
    func requestImmediateDeliveryData() {
        self.usecase.loadImmediateDeliveryShopPosts()
    }
    
    func requestMoreImmediateDeliveryData() {
//        self.usecase.loadMoreImmediateDeliveryShopPosts()
    }
}

extension ShopViewModel {
    // request brand delivery shopPosts
    func requestBrandDeliveryData() {
        self.usecase.loadBrandDeliveryShopPosts()
    }
    
    func requestMoreBrandDeliveryData() {
//        self.usecase.loadMoreBrandDeliveryShopPosts()
    }
}

extension ShopViewModel {
    // request category shopPosts
    func requestCategoryData(selectedCategory: String) {
        self.usecase.loadCategoryShopPosts(selectedCategory: selectedCategory)
    }
    
    func requestMoreCategoryData() {
//        self.usecase.loadMoreCategoryShopPosts()
    }
}

extension ShopViewModel {
    // request brand shopPosts
    func requestBrandShopPostsData(selectedBrand: Int) {
        self.usecase.loadBrandShopPosts(selectedBrand: selectedBrand)
    }
    
    func requestMoreBrandShopPostsData() {
//        self.usecase.loadMoreBrandShopPosts()
    }
}

extension ShopViewModel {
    // request brands
    func requestBrandData() {
        self.usecase.loadBrands()
    }
}

struct ProductData {
    let id: Int
    let brand: Int
    let eng_name: String
    let kor_name: String
    let delivery_tag: String
    let productimage_set: [Int]
    let brand_name: String
    let price: Int
    let total_wishes: Int
    let total_shares: Int
    let imageSource: [ProductImage]
    
    init(product: Product) {
        self.id = product.id
        self.brand = product.brand
        self.eng_name = product.eng_name
        self.kor_name = product.kor_name
        self.delivery_tag = product.delivery_tag
        self.productimage_set = product.productimage_set
        self.brand_name = product.brand_name
        self.price = product.price
        self.total_wishes = product.total_wishes
        self.total_shares = product.total_shares
        self.imageSource = product.imageSource
    }
}

