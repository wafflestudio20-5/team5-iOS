//
//  StyleUsecase.swift
//  KreamWaffleApp
//
//  Created by 최성혁 on 2022/12/29.
//

import Foundation
import RxCocoa

final class StyleUsecase {
    private let repository: StyleRepository
    
    let stylePostRelay: BehaviorRelay<[StylePost]> = .init(value: [])
    
    var stylePostList = [StylePost]() {
        didSet {
            self.stylePostRelay.accept(self.stylePostList)
        }
    }
    
    init (repository: StyleRepository) {
        self.repository = repository
        setTestData()
    }
    
    func setTestData() {
        self.stylePostList = [
            StylePost(imageSources: ["https://upload.wikimedia.org/wikipedia/commons/thumb/1/15/Cat_August_2010-4.jpg/362px-Cat_August_2010-4.jpg"], id: "postId1", numLikes: 1, content: "첫번째 게시글"),
            StylePost(imageSources: ["https://upload.wikimedia.org/wikipedia/commons/thumb/9/9b/Gustav_chocolate.jpg/156px-Gustav_chocolate.jpg"], id: "postId2", numLikes: 2, content: "두번째 게시글"),
            StylePost(imageSources: ["https://upload.wikimedia.org/wikipedia/commons/thumb/b/b6/Felis_catus-cat_on_snow.jpg/358px-Felis_catus-cat_on_snow.jpg"], id: "postId3", numLikes: 3, content: "세번째 게시글"),
        ]
    }
}
