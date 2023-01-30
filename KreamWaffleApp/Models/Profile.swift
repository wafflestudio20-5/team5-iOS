//
//  Profile.swift
//  KreamWaffleApp
//
//  Created by 최성혁 on 2023/01/21.
//

import Foundation

final class Profile: Codable {
    private enum CodingKeys: String, CodingKey {
        case user_id, user_name, profile_name, introduction, image, num_followers, num_followings, following
    }
    
    let user_id: Int
    let user_name: String
    let profile_name: String
    let introduction: String
    let image: String
    let num_followers: Int
    let num_followings: Int
    let following: String?
    
    init(
        user_id: Int,
        user_name: String,
        profile_name: String,
        introduction: String,
        image: String?,
        num_followers: Int,
        num_followings: Int,
        following: String
    ) {
        self.user_id = user_id
        self.user_name = user_name
        self.profile_name = profile_name
        self.introduction = introduction
        self.image = image ?? ""
        self.num_followers = num_followers
        self.num_followings = num_followings
        self.following = following
    }
    
    init() {
        self.user_id = 0
        self.user_name = "-"
        self.profile_name = "-"
        self.introduction = "-"
        self.image = ""
        self.num_followers = 0
        self.num_followings = 0
        self.following = nil
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        user_id = try container.decodeIfPresent(Int.self, forKey: .user_id) ?? -1
        user_name = try container.decodeIfPresent(String.self, forKey: .user_name) ?? "-"
        profile_name = try container.decodeIfPresent(String.self, forKey: .profile_name) ?? "-"
        introduction = try container.decodeIfPresent(String.self, forKey: .introduction) ?? "-"
        image = try container.decodeIfPresent(String.self, forKey: .image) ?? ""
        num_followers = try container.decodeIfPresent(Int.self, forKey: .num_followers) ?? 0
        num_followings = try container.decodeIfPresent(Int.self, forKey: .num_followings) ?? 0
        do {
            let strFollowing = try container.decodeIfPresent(String.self, forKey: .following)
            self.following = strFollowing
        } catch {
            do {
                let boolFollowing: Bool = try container.decodeIfPresent(Bool.self, forKey: .following) ?? false
                self.following = boolFollowing ? "true" : "false"
            } catch {
                self.following = "false"
                print(error)
            }
        }    }
}
