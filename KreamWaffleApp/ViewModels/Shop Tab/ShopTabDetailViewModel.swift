//
//  ShopTabDetailViewModel.swift
//  KreamWaffleApp
//
//  Created by 이선재 on 2023/01/20.
//

import Foundation
import UIKit
import RxSwift
import RxRelay

final class ShopTabDetailViewModel {
    let usecase: ShopDetailUsecase
    
    let shopPost: Product
    
    var productSizeInfoDataSource: Observable<[ProductSize]> {
        return self.usecase.productSizeInfoObservable
            
    }
    
    init(usecase : ShopDetailUsecase, shopPost: Product) {
        self.usecase = usecase
        self.shopPost = shopPost
        requestProductSizeInfo(id: shopPost.id)
    }
    
    func requestProductSizeInfo(id: Int) {
        self.usecase.loadProductSizeInfo(id: id)
    }
    
    func getBrand() -> String {
        return self.shopPost.brand_name
    }
    
    func getEngName() -> String {
        return self.shopPost.eng_name
    }
    
    func getKorName() -> String {
        return self.shopPost.kor_name
    }
    
    func getPrice() -> Int {
        return self.shopPost.price
    }
    
    func getImageSources() -> [String] {
//        return self.shopPost.imageSource
        return self.shopPost.productimage_urls
    }
    
    func getThumbnailImageRatio() -> Float {
        return self.shopPost.thumbnailImageRatio
    }
}
