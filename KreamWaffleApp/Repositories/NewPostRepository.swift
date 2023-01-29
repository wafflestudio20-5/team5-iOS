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
        
    }
    
    func uploadPost(token: String, images: [UIImage], content: String, ratio: CGFloat, completion: @escaping ()->(), onNetworkFailure: @escaping ()->()) {
        let headers : HTTPHeaders = [
            "Authorization": "Bearer \(token)" ,
            "accept": "application/json",
            "Content-Type": "multipart/form-data",
        ]
        
        let parameters: [String: Any] = [
            "content": content,
            "image_ratio": Float(ratio)
        ]
        
        AF.upload(multipartFormData: { multipartFormData in
            for (key, value) in parameters {
                multipartFormData.append("\(value)".data(using: .utf8)!, withName: key)
            }
            
            let imageJpegDataList = images.map { $0.jpegData(compressionQuality: 1) }
            
            for (index, imageJpegData) in imageJpegDataList.enumerated() {
                if let imageJpegData = imageJpegData {
                    multipartFormData.append(imageJpegData, withName: "image", fileName: "\(index).jpg", mimeType: "image/jpg")
                }
             }
            
        }, to: newPostConstants.uri, method: .post, headers: headers)
        .validate()
        .responseData { response in
            switch response.result {
            case .success:
                print("포스팅 업로드 완료")
                debugPrint(response)
            case .failure:
                print("포스팅 업로드 실패")
                debugPrint(response)
                onNetworkFailure()
            }
            
            completion()
        }
        
        
    }
}
