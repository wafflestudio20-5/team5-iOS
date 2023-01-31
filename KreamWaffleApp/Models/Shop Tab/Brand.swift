//
//  Brand.swift
//  KreamWaffleApp
//
//  Created by 이선재 on 2023/01/29.
//

import Foundation

class Brand: Codable {
    let id: Int
    let name: String
    
    private enum CodingKeys: String, CodingKey {
        case id, name
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        id = try container.decodeIfPresent(Int.self, forKey: .id) ?? -1
        name = try container.decodeIfPresent(String.self, forKey: .name) ?? "N/A"
    }
    
    init(
        id: Int,
        name: String
    ) {
        self.id = id
        self.name = name
    }
}
