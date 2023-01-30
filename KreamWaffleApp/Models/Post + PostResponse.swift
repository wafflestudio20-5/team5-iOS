//
//  StylePost.swift
//  KreamWaffleApp
//
//  Created by 최성혁 on 2022/12/29.
//

import Foundation
import Kingfisher

class Post: Codable {
    private enum CodingKeys: String, CodingKey {
        case id, content, images, image_ratio, created_by, created_at, num_comments, num_likes, liked
    }
    
    let id: Int
    let content: String
    let images: [String]
    let image_ratio: Float
    let created_by: NestedProfile
    let created_at: String
    let num_comments: Int
    let num_likes: Int
    let liked: String?
    
    init(
        id: Int,
        content: String,
        images: [String],
        image_ratio: Float,
        created_by: NestedProfile,
        created_at: String,
        num_comments: Int,
        num_likes: Int,
        liked: String?
    ) {
        self.id = id
        self.content = content
        self.images = images
        self.image_ratio = image_ratio
        self.created_by = created_by
        self.created_at = created_at
        self.num_comments = num_likes
        self.num_likes = num_likes
        self.liked = liked
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        id = try container.decodeIfPresent(Int.self, forKey: .id) ?? -1
        content = try container.decodeIfPresent(String.self, forKey: .content) ?? ""
        images = try container.decodeIfPresent([String].self, forKey: .images) ?? []
        image_ratio = try container.decodeIfPresent(Float.self, forKey: .image_ratio) ?? 1
        created_by = try container.decodeIfPresent(NestedProfile.self, forKey: .created_by) ?? NestedProfile()
        created_at = try container.decodeIfPresent(String.self, forKey: .created_at) ?? ""
        num_comments = try container.decodeIfPresent(Int.self, forKey: .num_comments) ?? 0
        num_likes = try container.decodeIfPresent(Int.self, forKey: .num_likes) ?? 0
        do {
            let strLiked = try container.decodeIfPresent(String.self, forKey: .liked) ?? nil
            self.liked = strLiked
        } catch {
            do {
                let boolLiked: Bool = try container.decodeIfPresent(Bool.self, forKey: .liked) ?? false
                self.liked = boolLiked ? "true" : "false"
            } catch {
                self.liked = "false"
                print(error)
            }
        }
    }
}

class PostResponse: Codable {
    private enum CodingKeys: String, CodingKey {
        case next, previous, results
    }
    
    let next: String?
    let previous: String?
    let results: [Post]
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        next = try container.decodeIfPresent(String.self, forKey: .next) ?? nil
        previous = try container.decodeIfPresent(String.self, forKey: .previous) ?? nil
        results = try container.decodeIfPresent([Post].self, forKey: .results) ?? []
    }
}
