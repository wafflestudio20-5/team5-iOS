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
    }
    
    var shopDataSource: Observable<[ProductData]> {
        return self.usecase.products
            .map { product in
                return product.map { ProductData(product: $0) }
            }
    }
    
    var filterDataSource: Observable<[String]> {
        return self.usecase.filterCategories
    }
}

extension ShopViewModel {
    func requestData() {
        self.usecase.requestData()
    }
    
    func getProductAtIndex(index: Int) -> Product {
        return self.usecase.getProductAtIndex(index: index)
    }
}

struct ProductData {
    let imageSource: String
    let brand: String
    let productNameEng: String
    let productNameKor: String
    let price: Int
    let transactionCount: Int
    let bookmarkCount: Int
    let relatedStyleCount: Int
    
    init(product: Product) {
        self.imageSource = product.imageSource
        self.brand = product.brand
        self.productNameEng = product.productNameEng
        self.productNameKor = product.productNameKor
        self.price = product.price
        self.transactionCount = product.transactionCount
        self.bookmarkCount = product.bookmarkCount
        self.relatedStyleCount = product.relatedStyleCount
    }
}

