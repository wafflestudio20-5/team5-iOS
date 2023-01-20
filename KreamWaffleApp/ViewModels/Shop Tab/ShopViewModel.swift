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
    
//    var productImagesDataSource: Observable
    
    var filterDataSource: Observable<[String]> {
        return self.usecase.filterCategories
    }
}

extension ShopViewModel {
    func requestData() {
        self.usecase.loadShopPosts()
        
    }
    
    func requestMoreData() {
        self.usecase.loadMoreShopPosts()
    }
    
    func getProductAtIndex(index: Int) -> Product {
        return self.usecase.getProductAtIndex(index: index)
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
//
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

