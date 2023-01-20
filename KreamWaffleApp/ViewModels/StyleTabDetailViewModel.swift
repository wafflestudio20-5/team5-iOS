//
//  StyleTabDetailViewModel.swift
//  KreamWaffleApp
//
//  Created by 최성혁 on 2023/01/06.
//

import Foundation

final class StyleTabDetailViewModel {
    private let usecase: StyleDetailUsecase
    private let stylePost: StylePost
    
    init(usecase: StyleDetailUsecase, stylePost: StylePost) {
        self.usecase = usecase
        self.stylePost = stylePost
    }
    
    func getImageSources() -> [String] {
        return self.stylePost.images
    }
    
    func getProfileName() -> String {
        return self.stylePost.created_by.profile_name
    }
    
    func getNumLikes() -> Int {
        return self.stylePost.num_likes
    }
    
    func getContent() -> String {
        return self.stylePost.content
    }
    
    func getThumbnailImageRatio() -> Float {
        return self.stylePost.image_ratio
    }
}
