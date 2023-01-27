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

final class UserProfileRepository {
    private struct fetchUserConstants {
        static let uri = "https://kream-waffle.cf/styles/profiles/"
        static let headers : HTTPHeaders = [
            "accept": "application/json",
            "X-CSRFToken" : "X-CSRFToken: JcSG5AkuWdO396362gJih3LlQdl0pFy6CL5iRIIx3ESZTdjgXo6oSqgyK3ughVBn"
        ]
    }
    
    func requestProfile(user_id: Int, onNetworkFailure: @escaping ()->()) -> Single<Profile?> {
        return Single.create { single in
            AF.request(fetchUserConstants.uri + "\(user_id)/", method: .get, headers: fetchUserConstants.headers)
                .validate()
                .responseDecodable(of: Profile.self) {response in
                    switch response.result {
                    case .success(let result):
                        debugPrint(response)
                        single(.success(result))
                    case .failure:
                        debugPrint(response)
                        single(.success(nil))
                        onNetworkFailure()
                    }
                }
            
            return Disposables.create()
        }
    }
}
