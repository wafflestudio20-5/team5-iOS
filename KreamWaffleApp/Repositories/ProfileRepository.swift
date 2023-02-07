//
//  ProfileRepository.swift
//  KreamWaffleApp
//
//  Created by 최성혁 on 2023/01/21.
//

/*
 특정 유저의 프로필 접속했을 때 서버와 통신을 담당하는 repository
 예를 들어서, 특정 유저의 프로필에 표시될 팔로워 수와 목록, 팔로잉 수와 목록 받아오기
 해당 유저 팔로우 하기 기능 등
 */


import Foundation
import RxSwift
import Alamofire
import Kingfisher
import ImageSlideshow

final class ProfileRepository {
    private struct fetchUserConstants {
        static let uri = "https://kream-waffle.cf/styles/profiles/"
    }
    
    
    func requestProfile(user_id: Int, token: String?, onNetworkFailure: @escaping ()->()) -> Single<Profile> {
        var headers : HTTPHeaders = [
            "accept": "application/json",
        ]
        if let token = token {
            headers.add(name: "Authorization", value: "Bearer \(token)")
        }
        
        return Single.create { single in
            AF.request(fetchUserConstants.uri + "\(user_id)/", method: .get, headers: headers)
                .validate()
                .responseDecodable(of: Profile.self) {response in
                    switch response.result {
                    case .success(let result):
                        debugPrint(response)
                        
                        single(.success(result))
                    case .failure:
                        debugPrint(response)
                        onNetworkFailure()
                    }
                }
            
            return Disposables.create()
        }
    }
    
    //PUT: entire update (maybe change to patch?)
    func updateUserProfile(profile: Profile, userId: Int, accessToken: String, completion: @escaping (Result<Bool, Error>) -> ()){
        
        let headers : HTTPHeaders = [
            "Authorization": "Bearer \(accessToken)" ,
            "accept": "application/json",
            "Content-Type": "multipart/form-data",
        ]
        
        let parameters = [
            "user_name": profile.user_name,
            "profile_name": profile.profile_name,
            "introduction": profile.introduction,
            "image": profile.image
        ]
        
        AF.upload(multipartFormData: { multipartFormData in
            for (key, value) in parameters {
                multipartFormData.append("\(value)".data(using: .utf8)!, withName: key)
            }
            let imageJpegData = profile.updatedImage?.jpegData(compressionQuality: 1)
            let sample = UIImage(named: "Kream")!.jpegData(compressionQuality: 1)
            multipartFormData.append(((imageJpegData ?? sample)!), withName: "image", fileName: "\(index).jpg", mimeType: "image/jpg")
                }, to: fetchUserConstants.uri + "\(userId)/", method: .put, headers: headers)
            .validate()
            .response() {response in
                switch response.result {
                case .success(_):
                    debugPrint(response)
                    completion(.success(true))
                case .failure(let error):
                    debugPrint(response)
                    completion(.failure(error))
                }
            }
    }
    
    //PATCH: updates partial fields of the profile, only for one edit case
    func updatePartialUserProfile(newValue: String, editCase: editCase, userId: Int, accessToken: String, completion: @escaping (Result<Bool, Error>) -> ()){
        
        let headers : HTTPHeaders = [
            "Authorization": "Bearer \(accessToken)" ,
            "accept": "application/json",
            "Content-Type": "multipart/form-data",
        ]
        
        var key : String
        switch (editCase){
        case .profileName:
            key = "profile_name"
        case .userName:
            key = "user_name"
        case .introduction:
            key = "introduction"
        default: //errror
             key = "user_name"
        }
        
        let parameters = [
            key : newValue,
        ]
        
        AF.upload(multipartFormData: { multipartFormData in
            for (key, value) in parameters {
                multipartFormData.append("\(value)".data(using: .utf8)!, withName: key)
            }}, to: fetchUserConstants.uri + "\(userId)/", method: .patch, headers: headers)
            .validate()
            .response() {response in
                print("=======-partial update profile=========")
                debugPrint(response)
                switch response.result {
                case .success(_):
                    debugPrint(response)
                    completion(.success(true))
                case .failure(let error):
                    debugPrint(response)
                    completion(.failure(error))
                }
            }
    }
    
    //PATCH: change Profile Image
    func updateUserProfileImage(newImage: UIImage, userId: Int, accessToken: String, completion: @escaping (Result<Bool, Error>) -> ()){
        
        let headers : HTTPHeaders = [
            "Authorization": "Bearer \(accessToken)" ,
            "accept": "application/json",
            "Content-Type": "multipart/form-data",
        ]
        
        let parameters = [
            "image": newImage
        ]
        
        AF.upload(multipartFormData: { multipartFormData in
            for (key, value) in parameters {
                multipartFormData.append("\(value)".data(using: .utf8)!, withName: key)
            }
            let imageJpegData = newImage.jpegData(compressionQuality: 1)
            let sample = UIImage(systemName: "person.crop.circle.fill")!.jpegData(compressionQuality: 1)
            multipartFormData.append(((imageJpegData ?? sample)!), withName: "image", fileName: "\(index).jpg", mimeType: "image/jpg")
                }, to: fetchUserConstants.uri + "\(userId)/", method: .patch, headers: headers)
            .validate()
            .response() {response in
                print("=======update profile image=========")
                switch response.result {
                case .success(_):
                    debugPrint(response)
                    completion(.success(true))
                case .failure(let error):
                    debugPrint(response)
                    completion(.failure(error))
                }
            }
    }
}


