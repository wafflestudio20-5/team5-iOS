//
//  StyleCell.swift
//  KreamWaffleApp
//
//  Created by 최성혁 on 2022/12/31.
//

import Foundation
import UIKit
import Kingfisher

class StyleCellModel {
    var thumbnailImage: UIImage?
    let userId: String
    let numLikes: Int
    let content: String
    
    init(thumbnailImage: UIImage, id: String, numLikes: Int, content: String) {
        self.thumbnailImage = thumbnailImage
        self.userId = id
        self.numLikes = numLikes
        self.content = content
    }
    
    init(stylePost: StylePost) {
        self.userId = stylePost.userId
        self.numLikes = stylePost.numLikes
        self.content = stylePost.content
        
        
        guard let url = URL.init(string: stylePost.imageSources[0]) else {
                return
            }
        let resource = ImageResource(downloadURL: url)

        KingfisherManager.shared.retrieveImage(with: resource, options: nil, progressBlock: nil) { result in
                switch result {
                case .success(let value):
                    self.thumbnailImage = value.image
                    print("Image: \(value.image). Got from: \(value.cacheType)")
                case .failure(let error):
                    print("Error: \(error)")
                }
            }
    }
}
