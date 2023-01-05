//
//  StylePost.swift
//  KreamWaffleApp
//
//  Created by 최성혁 on 2022/12/29.
//

import Foundation
import Kingfisher

class StylePost: Codable {
    let imageSources: [String]
    let userId: String
    let numLikes: Int
    let content: String
    let thumbnailImageRatio: Float // (세로/가로) 비율
    
    init(imageSources: [String], id: String, numLikes: Int, content: String, thumbnailImageRatio: Float) {
        self.imageSources = imageSources
        self.userId = id
        self.numLikes = numLikes
        self.content = content
        self.thumbnailImageRatio = thumbnailImageRatio
    }
    
    
}
