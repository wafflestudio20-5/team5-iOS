//
//  UserProduct.swift
//  KreamWaffleApp
//
//  Created by grace on 2023/02/03.
//

import Foundation
import Alamofire
import UIKit

//has the products for user list
struct UserProduct : Codable {
    
    let id: Int
    let product: Int
    let price: Int
    let date: String

    private enum CodingKeys: String, CodingKey {
        case id, price, product
        case date = "created_at"
        }
        
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decodeIfPresent(Int.self, forKey: .id) ?? -1
        product = try container.decodeIfPresent(Int.self, forKey: .product) ?? 0
        price = try container.decodeIfPresent(Int.self, forKey: .price) ?? 0
        date = try container.decodeIfPresent(String.self, forKey: .date) ?? "-"
    }
}

//이런 형식으로 옴.
struct UserProductResponse : Codable {
    let count: Int
    let next : String?
    let previous : String?
    let itemList: [UserProduct]
    
    private enum CodingKeys: String, CodingKey{
        case count
        case itemList = "results"
        case next, previous
    }
}
                                              
                                              
