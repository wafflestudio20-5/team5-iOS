//
//  NestedProfile.swift
//  KreamWaffleApp
//
//  Created by 최성혁 on 2023/01/19.
//

import Foundation

class NestedProfile : Codable {
    private enum CodingKeys: String, CodingKey {
        case user_id, user_name, profile_name, image, following
    }
    
    let user_id: Int
    let user_name: String
    let profile_name: String
    let image: String
    let following: String?
    
    init(
        user_id: Int,
        user_name: String,
        profile_name: String,
        image: String,
        following: String?
    ) {
        self.user_id = user_id
        self.user_name = user_name
        self.profile_name = profile_name
        self.image = image
        self.following = following
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        user_id = try container.decodeIfPresent(Int.self, forKey: .user_id) ?? -1
        user_name = try container.decodeIfPresent(String.self, forKey: .user_name) ?? ""
        profile_name = try container.decodeIfPresent(String.self, forKey: .profile_name) ?? ""
        image = try container.decodeIfPresent(String.self, forKey: .image) ?? ""
        do {
            self.following = try container.decodeIfPresent(String.self, forKey: .following) ?? nil
        } catch {
            do {
                let boolFollowing: Bool = try container.decodeIfPresent(Bool.self, forKey: .following) ?? false
                self.following = boolFollowing ? "true" : "false"
            } catch {
                self.following = "false"
                print(error)
            }
        }
    }
    
    init() {
        self.user_id = 0
        self.user_name = ""
        self.profile_name = ""
        self.image = ""
        self.following = "false"
    }
}
