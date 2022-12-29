//
//  StyleViewModel.swift
//  KreamWaffleApp
//
//  Created by 최성혁 on 2022/12/29.
//

import Foundation
import UIKit
import RxSwift

final class StyleViewModel {
    private let usecase: StyleUsecase
    
    var styleDataSource: Observable<[StylePost]> {
        // for testing *****************************************
        let stylePost1 = StylePost(imageSources: ["https://upload.wikimedia.org/wikipedia/commons/thumb/1/15/Cat_August_2010-4.jpg/362px-Cat_August_2010-4.jpg"], id: "postId1", numLikes: 1, content: "첫번째 게시글")
        let stylePost2 = StylePost(imageSources: ["https://upload.wikimedia.org/wikipedia/commons/thumb/9/9b/Gustav_chocolate.jpg/156px-Gustav_chocolate.jpg"], id: "postId2", numLikes: 2, content: "두번째 게시글")
        let stylePost3 = StylePost(imageSources: ["https://upload.wikimedia.org/wikipedia/commons/thumb/b/b6/Felis_catus-cat_on_snow.jpg/358px-Felis_catus-cat_on_snow.jpg"], id: "postId3", numLikes: 3, content: "세번째 게시글")
        return Observable.of([stylePost1, stylePost2, stylePost3])
        // for testing *****************************************
    }
    
    init(usecase: StyleUsecase) {
        self.usecase = usecase
    }
    
//    func getImageByIndex(index: Int) -> UIImage {
//        // for testing *****************************************
//        // 나중에는 Rx써서 바꿔야함.
//        return images[index]
//    }
}
