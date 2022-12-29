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
    let id: String
    let numLikes: Int
    let content: String
    
    init(imageSources: [String], id: String, numLikes: Int, content: String) {
        self.imageSources = imageSources
        self.id = id
        self.numLikes = numLikes
        self.content = content
    }
    
    
}
