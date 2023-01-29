//
//  StyleTabDetailUsecase.swift
//  KreamWaffleApp
//
//  Created by 최성혁 on 2023/01/17.
//

import Foundation

final class StyleDetailUsecase {
    private let repository: StyleDetailRepository
    private let stylePost: Post
    
    init(repository: StyleDetailRepository, stylePost: Post) {
        self.repository = repository
        self.stylePost = stylePost
    }
    
    func getUserId() -> Int {
        return self.stylePost.created_by.user_id
    }
    
    func getImageSources() -> [String] {
        return self.stylePost.images
    }
    
    func getProfileName() -> String {
        return self.stylePost.created_by.profile_name
    }
    
    func getNumLikes() -> Int {
        return Int(exactly: self.stylePost.num_likes)!
    }
    
    func getContent() -> String {
        return self.stylePost.content
    }
    
    func getThumbnailImageRatio() -> Float {
        return self.stylePost.image_ratio
    }
}
