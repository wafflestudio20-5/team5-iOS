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

final class StyleFeedUsecase {
    private let repository: StyleFeedRepository
    private let disposeBag = DisposeBag()
    
    let stylePostRelay: BehaviorRelay<[Post]> = .init(value: [])
    
    private let type: String
    private let user_id: Int?
    
    var stylePostList = [Post]() {
        didSet {
            self.stylePostRelay.accept(self.stylePostList)
        }
    }
        
    init (repository: StyleFeedRepository, type: String, user_id: Int?) {
        self.repository = repository
        self.type = type
        self.user_id = user_id
//        requestStylePostData(page: 1)
    }
    
    func requestStylePostData(page: Int) {
        // ******* For Testing *********
        if (page == 1) {
            setTestData()
        } else {
            setTestData(page: page)
        }
        // ******* For Testing *********
    }
    
    // ******* For Testing *********
    // API 세팅 후에는 얘가 API call로 데이터 load 하는 함수가 될 것. StyleFeedRepository에서 데이터 받아오는.
    func setTestData() {
        self.stylePostList = [
            Post(id: 1, content: "아더에러 ✨", images: [
                "https://kream-phinf.pstatic.net/MjAyMjEyMTJfMTQ2/MDAxNjcwODIwODk1NjEw.nf2jbxLWZCgGzECgQeMPHE7ezHjcuSIUu2q9PeMOAiIg.WVRRPpwBA7VVfWmfdMlpqOORYPUm91ORfmjjSk3AIc0g.JPEG/p_ff64de1147824dec9712c634e93cf993.jpeg?type=l", "https://kream-phinf.pstatic.net/MjAyMjEyMTJfMjQ0/MDAxNjcwODIwODk2MjQz.scgGqUEmzUIAUxe9xy6qMpbiMnZcva325JUohoIsIa0g.Aztf7mK85JfAJT1UZg8S-BhTjJzAJhM8MNz72TnAoM0g.JPEG/p_fa2aedd66c6b4f77b48f9939540879d0.jpeg?type=l_webp"
            ], image_ratio: 4/3, created_by: NestedProfile(user_id: 1, user_name: "Hi", profile_name: "mangocheezz", image:" https://i.pinimg.com/originals/8f/50/63/8f50630ae0e1775196e4c270c573ce67.png", following: "true"), created_at: "20230120", num_comments: "5", num_likes: "5"),
        ]
    }
    
    func setTestData(page: Int) {
        let newData = [
            Post(id: 1, content: "아더에러 ✨", images: [
                "https://kream-phinf.pstatic.net/MjAyMjEyMTJfMTQ2/MDAxNjcwODIwODk1NjEw.nf2jbxLWZCgGzECgQeMPHE7ezHjcuSIUu2q9PeMOAiIg.WVRRPpwBA7VVfWmfdMlpqOORYPUm91ORfmjjSk3AIc0g.JPEG/p_ff64de1147824dec9712c634e93cf993.jpeg?type=l", "https://kream-phinf.pstatic.net/MjAyMjEyMTJfMjQ0/MDAxNjcwODIwODk2MjQz.scgGqUEmzUIAUxe9xy6qMpbiMnZcva325JUohoIsIa0g.Aztf7mK85JfAJT1UZg8S-BhTjJzAJhM8MNz72TnAoM0g.JPEG/p_fa2aedd66c6b4f77b48f9939540879d0.jpeg?type=l_webp"
            ], image_ratio: 4/3, created_by: NestedProfile(user_id: 1, user_name: "Hi", profile_name: "mangocheezz", image:" https://i.pinimg.com/originals/8f/50/63/8f50630ae0e1775196e4c270c573ce67.png", following: "true"), created_at: "20230120", num_comments: "5", num_likes: "5")
        ]
        
        self.stylePostList.append(contentsOf: newData)
    }
    // ******* For Testing *********

}

