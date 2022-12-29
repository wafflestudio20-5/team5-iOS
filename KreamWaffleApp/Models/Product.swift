//
//  Product.swift
//  KreamWaffleApp
//
//  Created by 이선재 on 2022/12/29.
//

import Foundation

struct Product: Codable {
    let imageSource: String
    let brand: String
    let productNameEng: String
    let productNameKor: String
    let price: Int
    let transactionCount: Int
    let bookmarkCount: Int
    let relatedStyleCount: Int
    
    private enum CodingKeys: String, CodingKey {
        case imageSource, brand, productNameEng, productNameKor, price, transactionCount, bookmarkCount, relatedStyleCount
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        imageSource = try container.decodeIfPresent(String.self, forKey: .imageSource) ?? "-"
        brand = try container.decodeIfPresent(String.self, forKey: .brand) ?? "-"
        productNameEng = try container.decodeIfPresent(String.self, forKey: .productNameEng) ?? "-"
        productNameKor = try container.decodeIfPresent(String.self, forKey: .productNameKor) ?? "-"
        price = try container.decodeIfPresent(Int.self, forKey: .price) ?? 0
        transactionCount = try container.decodeIfPresent(Int.self, forKey: .transactionCount) ?? 0
        bookmarkCount = try container.decodeIfPresent(Int.self, forKey: .bookmarkCount) ?? 0
        relatedStyleCount = try container.decodeIfPresent(Int.self, forKey: .relatedStyleCount) ?? 0
    }
    
    init(
        imageSource: String,
        brand: String,
        productNameEng: String,
        productNameKor: String,
        price: Int,
        transactionCount: Int,
        bookmarkCount: Int,
        relatedStyleCount: Int
    ) {
        self.imageSource = imageSource
        self.brand = brand
        self.productNameEng = productNameEng
        self.productNameKor = productNameKor
        self.price = price
        self.transactionCount = transactionCount
        self.bookmarkCount = bookmarkCount
        self.relatedStyleCount = relatedStyleCount
    }
    
    
}
