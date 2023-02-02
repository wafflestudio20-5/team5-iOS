//
//  ShopModel.swift
//  KreamWaffleApp
//
//  Created by 이선재 on 2023/01/16.
//

import Foundation

struct ShopPostModel: Decodable {
    var count: Int
    var results: [Product]
}

struct ShopBrandsModel: Decodable {
    var count: Int
    var results: [Brand]
}

struct ShopBrandModel: Decodable {
    var id: Int
    var name: String
}

struct ProductImagesModel: Decodable {
    var images: [ProductImage]
}

struct ProductImage: Codable {
    let id: Int
    let url: String
    
    private enum CodingKeys: String, CodingKey {
        case id, url
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        id = try container.decodeIfPresent(Int.self, forKey: .id) ?? -1
        url = try container.decodeIfPresent(String.self, forKey: .url) ?? "-"
    }
    
    init(
        id: Int,
        url: String
    ) {
        self.id = id
        self.url = url
    }
}

// Product Size
struct ProductSizesModel: Decodable {
    var count: Int
    var results: [ProductSize]
}

struct ProductSize: Codable {
    let id: Int
    let size: String
    let sales_price: Int
    let purchase_price: Int
    
    private enum CodingKeys: String, CodingKey {
        case id, size, sales_price, purchase_price
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        id = try container.decodeIfPresent(Int.self, forKey: .id) ?? -1
        size = try container.decodeIfPresent(String.self, forKey: .size) ?? "-"
        sales_price = try container.decodeIfPresent(Int.self, forKey: .sales_price) ?? -1
        purchase_price = try container.decodeIfPresent(Int.self, forKey: .purchase_price) ?? -1
        
    }
    
    init(
        id: Int,
        size: String,
        sales_price: Int,
        purchase_price: Int
    ) {
        self.id = id
        self.size = size
        self.sales_price = sales_price
        self.purchase_price = purchase_price
    }
}
