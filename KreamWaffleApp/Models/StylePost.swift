//
//  StylePost.swift
//  KreamWaffleApp
//
//  Created by 최성혁 on 2022/12/29.
//

import Foundation
import Kingfisher

class StylePost: Codable {
    let id: Int
    let content: String
    let images: [String]
    let image_ratio: Float
    let created_by: NestedProfile
    let created_at: String
    let num_comments: Int
    let num_likes: Int
    
    init(
        id: Int,
        content: String,
        images: [String],
        image_ratio: Float,
        created_by: NestedProfile,
        created_at: String,
        num_comments: Int,
        num_likes: Int
    ) {
        self.id = id
        self.content = content
        self.images = images
        self.image_ratio = image_ratio
        self.created_by = created_by
        self.created_at = created_at
        self.num_comments = num_comments
        self.num_likes = num_likes
    }
    
    
}
