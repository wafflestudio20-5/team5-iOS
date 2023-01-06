//
//  StyleTabDetailViewModel.swift
//  KreamWaffleApp
//
//  Created by 최성혁 on 2023/01/06.
//

import Foundation

final class StyleTabDetailViewModel {
    private let repository: StyleTabDetailRepository
    private let stylePost: StylePost
    
    init(repository: StyleTabDetailRepository, stylePost: StylePost) {
        self.repository = repository
        self.stylePost = stylePost
    }
    
    func getImageSources() -> [String] {
        return self.stylePost.imageSources
    }
    
    func getUserId() -> String {
        return self.stylePost.userId
    }
    
    func getNumLikes() -> Int {
        return self.stylePost.numLikes
    }
    
    func getContent() -> String {
        return self.stylePost.content
    }
    
    func getThumbnailImageRatio() -> Float {
        return self.stylePost.thumbnailImageRatio
    }
}
