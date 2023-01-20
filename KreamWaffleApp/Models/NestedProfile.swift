//
//  NestedProfile.swift
//  KreamWaffleApp
//
//  Created by 최성혁 on 2023/01/19.
//

import Foundation

class NestedProfile : Codable {
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
}
