//
//  Product.swift
//  KreamWaffleApp
//
//  Created by 이선재 on 2022/12/29.
//

import Foundation

class Product: Codable {
    let id: Int
    let brand: Int
    let eng_name: String
    let kor_name: String
    let delivery_tag: String
    let productimage_set: [Int]
    var brand_name: String
    let price: Int
    let total_wishes: Int
    let total_shares: Int
    var imageSource: [ProductImage] = [ProductImage(id: -1, url: "https://i.pinimg.com/originals/10/b2/f6/10b2f6d95195994fca386842dae53bb2.png")]
//    let transactionCount: Int
//    let bookmarkCount: Int
//    let relatedStyleCount: Int
    let thumbnailImageRatio: Float // (세로/가로) 비율
    
    private enum CodingKeys: String, CodingKey {
        case id, brand, eng_name, kor_name, delivery_tag, productimage_set, brand_name, price, total_wishes, total_shares
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        id = try container.decodeIfPresent(Int.self, forKey: .id) ?? -1
        brand = try container.decodeIfPresent(Int.self, forKey: .brand) ?? -1
        eng_name = try container.decodeIfPresent(String.self, forKey: .eng_name) ?? "-"
        kor_name = try container.decodeIfPresent(String.self, forKey: .kor_name) ?? "-"
        delivery_tag = try container.decodeIfPresent(String.self, forKey: .delivery_tag) ?? "-"
        productimage_set = try container.decodeIfPresent([Int].self, forKey: .productimage_set) ?? []
        brand_name = try container.decodeIfPresent(String.self, forKey: .brand_name) ?? "-"
        price = try container.decodeIfPresent(Int.self, forKey: .price) ?? 0
        total_wishes = try container.decodeIfPresent(Int.self, forKey: .total_wishes) ?? 0
        total_shares = try container.decodeIfPresent(Int.self, forKey: .total_shares) ?? 0
        
//        imageSource = []
        thumbnailImageRatio = 1
    }
    
    init(
        id: Int,
        brand: Int,
        eng_name: String,
        kor_name: String,
        delivery_tag: String,
        productimage_set: [Int],
        brand_name: String,
        price: Int,
        total_wishes: Int,
        total_shares: Int,
        imageSource: [ProductImage],
        thumbnailImageRatio: Float
    ) {
        self.id = id
        self.brand = brand
        self.eng_name = eng_name
        self.kor_name = kor_name
        self.delivery_tag = delivery_tag
        self.productimage_set = productimage_set
        self.brand_name = brand_name
        self.price = price
        self.total_wishes = total_wishes
        self.total_shares = total_shares
        self.imageSource = imageSource
        self.thumbnailImageRatio = thumbnailImageRatio
    }

}
