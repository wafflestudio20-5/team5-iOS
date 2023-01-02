//
//  StyleUsecase.swift
//  KreamWaffleApp
//
//  Created by 최성혁 on 2022/12/29.
//

import Foundation
import RxCocoa
import RxSwift
import Kingfisher

final class StyleUsecase {
    private let repository: StyleRepository
    private let disposeBag = DisposeBag()
    
    let stylePostRelay: BehaviorRelay<[StylePost]> = .init(value: [])
    // 얘가 업데이트 되면 얘를 구독하던 애가 거기서 map으로 thumbnail image 뽑아내서 저장한다.
    // 그 다음에 collectionView를 업데이트한다.
    
    var stylePostList = [StylePost]() {
        didSet {
            self.stylePostRelay.accept(self.stylePostList)
        }
    }
    
    var styleCellModelList = [StyleCellModel]()
    
    init (repository: StyleRepository) {
        self.repository = repository
        setTestData()
        subscribeStylePostRelay()
    }
    
    func setTestData() {
        self.stylePostList = [
            StylePost(imageSources: ["https://upload.wikimedia.org/wikipedia/commons/thumb/1/15/Cat_August_2010-4.jpg/362px-Cat_August_2010-4.jpg"], id: "postId1", numLikes: 1, content: "첫번째 게시글"),
            StylePost(imageSources: ["https://upload.wikimedia.org/wikipedia/commons/thumb/9/9b/Gustav_chocolate.jpg/156px-Gustav_chocolate.jpg"], id: "postId2", numLikes: 2, content: "두번째 게시글"),
            StylePost(imageSources: ["https://upload.wikimedia.org/wikipedia/commons/thumb/b/b6/Felis_catus-cat_on_snow.jpg/358px-Felis_catus-cat_on_snow.jpg"], id: "postId3", numLikes: 3, content: "세번째 게시글"),
            StylePost(imageSources: ["https://media.npr.org/assets/img/2021/08/11/gettyimages-1279899488_wide-f3860ceb0ef19643c335cb34df3fa1de166e2761-s1600-c85.webp"], id: "postId4", numLikes: 4, content: "네번째 게시글"),
            StylePost(imageSources: ["https://images.unsplash.com/photo-1611915387288-fd8d2f5f928b?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxleHBsb3JlLWZlZWR8MXx8fGVufDB8fHx8&auto=format&fit=crop&w=800&q=60"], id: "postId5", numLikes: 5, content: "다섯번째 게시글"),
        ]
    }
    
    func subscribeStylePostRelay() {
        self.stylePostRelay
            .subscribe { event in //Event<[StylePost]>
                switch event {
                case .next:
                    var list = [StyleCellModel]()
                    event.map { stylePostList in
                        stylePostList.map {
                            list.append(StyleCellModel(stylePost: $0))
                        }
                    }
                    self.styleCellModelList = list
                case .completed:
                    break
                case .error:
                    break
                }
                
            }
            .disposed(by: disposeBag)
    }
}

