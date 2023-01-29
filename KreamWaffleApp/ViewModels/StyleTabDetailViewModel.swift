//
//  StyleTabDetailViewModel.swift
//  KreamWaffleApp
//
//  Created by 최성혁 on 2023/01/06.
//

import Foundation

final class StyleTabDetailViewModel {
    private let styleDetailUsecase: StyleDetailUsecase
    
    init(styleDetailUsecase: StyleDetailUsecase) {
        self.styleDetailUsecase = styleDetailUsecase
    }
    
    func getUserId() -> Int {
        return self.styleDetailUsecase.getUserId()
    }
    
    func getImageSources() -> [String] {
        return self.styleDetailUsecase.getImageSources()
    }
    
    func getProfileName() -> String {
        return self.styleDetailUsecase.getProfileName()
    }
    
    func getNumLikes() -> Int {
        return self.styleDetailUsecase.getNumLikes()
    }
    
    func getContent() -> String {
        return self.styleDetailUsecase.getContent()
    }
    
    func getThumbnailImageRatio() -> Float {
        return self.styleDetailUsecase.getThumbnailImageRatio()
    }
    
    func getIsFollowing() -> String? {
        return self.styleDetailUsecase.getIsFollowing()
    }
}
