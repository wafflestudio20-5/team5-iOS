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
    let wishes: Int
    let shares: Int
    let productimage_urls: [String]

    let thumbnailImageRatio: Float // (세로/가로) 비율
    
    private enum CodingKeys: String, CodingKey {
        case id, brand, eng_name, kor_name, delivery_tag, productimage_set, brand_name, price, wishes, shares, productimage_urls
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
        wishes = try container.decodeIfPresent(Int.self, forKey: .wishes) ?? 0
        shares = try container.decodeIfPresent(Int.self, forKey: .shares) ?? 0
        productimage_urls = try container.decodeIfPresent([String].self, forKey: .productimage_urls) ?? []

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
        wishes: Int,
        shares: Int,
        productimage_urls: [String],
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
        self.wishes = wishes
        self.shares = shares
        self.productimage_urls = productimage_urls
        self.thumbnailImageRatio = thumbnailImageRatio
    }

}
