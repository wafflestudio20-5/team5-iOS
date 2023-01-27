//
//  NewPostRepository.swift
//  KreamWaffleApp
//
//  Created by 최성혁 on 2023/01/26.
//

import Foundation
import Alamofire
import RxSwift

final class NewPostRepository {
    private struct newPostConstants {
        static let uri = "https://kream-waffle.cf/styles/posts/"
        static let headers : HTTPHeaders = [
            "accept": "application/json",
            "Content-Type": "multipart/form-data",
            "X-CSRFToken" : "8PETTeWfYwMXkUYbfqP3qzefmUit9Byj1oRvFmki5XQT41elayc91WJsgKrJ1RBA"
        ]
    }
    
    func uploadPost(images: [UIImage], content: String, ratio: CGFloat, completion: @escaping ()->()) {
        let parameters: [String: Any] = [
            "content": content,
            "image_ratio": Float(ratio)
        ]
        
        AF.upload(multipartFormData: { multipartFormData in
            for (key, value) in parameters {
                multipartFormData.append("\(value)".data(using: .utf8)!, withName: key)
            }
            
            let imagePngDataList = images.map { $0.pngData() }
            
            for (index, imagePngData) in imagePngDataList.enumerated() {
                if let imagePngData = imagePngData {
                    multipartFormData.append(imagePngData, withName: "image", fileName: "test.jpg", mimeType: "image/jpg")
                }
             }
            
        }, to: newPostConstants.uri, method: .post, headers: newPostConstants.headers)
        .responseData { response in
            switch response.result {
            case .success:
                print("포스팅 업로드 완료")
            case .failure:
                print("포스팅 업로드 실패")
                debugPrint(response)
            }
            
            completion()
        }
        
        
    }
}
