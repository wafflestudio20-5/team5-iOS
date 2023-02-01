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
}
