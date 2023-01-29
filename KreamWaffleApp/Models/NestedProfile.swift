//
//  NestedProfile.swift
//  KreamWaffleApp
//
//  Created by 최성혁 on 2023/01/19.
//

import Foundation

class NestedProfile : Codable {
    private enum CodingKeys: String, CodingKey {
        case user_id, user_name, profile_name, image
    }
    
    let user_id: Int
    let user_name: String
    let profile_name: String
    let image: String
    
    init(
        user_id: Int,
        user_name: String,
        profile_name: String,
        image: String
    ) {
        self.user_id = user_id
        self.user_name = user_name
        self.profile_name = profile_name
        self.image = image
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        user_id = try container.decodeIfPresent(Int.self, forKey: .user_id) ?? -1
        user_name = try container.decodeIfPresent(String.self, forKey: .user_name) ?? ""
        profile_name = try container.decodeIfPresent(String.self, forKey: .profile_name) ?? ""
        image = try container.decodeIfPresent(String.self, forKey: .image) ?? ""
    }
    
    init() {
        self.user_id = 0
        self.user_name = ""
        self.profile_name = ""
        self.image = ""
    }
}
