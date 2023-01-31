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

