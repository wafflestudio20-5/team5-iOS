//
//  ShopTabDetailViewModel.swift
//  KreamWaffleApp
//
//  Created by 이선재 on 2023/01/20.
//

import Foundation

final class ShopTabDetailViewModel {
//    private let repository: ShopTabDetailRepository
    let shopPost: Product
    
    init(shopPost: Product) {
//        self.repository = repository
        self.shopPost = shopPost
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
    
    func getImageSources() -> [ProductImage] {
        return self.shopPost.imageSource
    }
    
    func getThumbnailImageRatio() -> Float {
        return self.shopPost.thumbnailImageRatio
    }
}
