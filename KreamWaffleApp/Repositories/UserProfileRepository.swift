//
//  UserProfileRepository.swift
//  KreamWaffleApp
//
//  Created by grace on 2023/02/01.
//

import Foundation
import Alamofire
import UIKit
import RxSwift

class UserProfileRepository {
    private let baseAPIURL = "https://kream-waffle.cf/styles/profiles"
    
    init(){}
    
    func getProfile(userId: Int, token: String, completion: @escaping (Result<Profile, Error>) -> ()){
    
        let URLString = "\(baseAPIURL)/\(userId)/"
        guard let url = URL(string: URLString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!) else {
            print("url error")
            return
        }
        
        var headers : HTTPHeaders = [
            .contentType("application/json")
        ]
        headers.add(name: "Authorization", value: "Bearer \(token)")
        
        AF.request("https://kream-waffle.cf/styles/profiles/" + "\(userId)/", method: .get, headers: headers)
            .validate()
            .response{ response in
                print("=======UserProfileRepo==============")
                print(url)
                print(token)
            switch response.result {
                
            case .success(let data):
                do{
                    let results : Profile = try JSONDecoder().decode(Profile.self, from: data!)
                    print("[Log] User Profile Repo: Profile successfully fetched")
                    completion(.success(results))
                }catch{
                    print(error)
                    completion(.failure(error))
                }
                
            case .failure(let error):
                let json = String(data: response.data!, encoding: String.Encoding.utf8)
                print("=======UserProfileRepo==============")
                print(error)
                print(json as Any)
                completion(.failure(error))
            }
        }
    }
    
    func requestProfile(user_id: Int, token: String?, onNetworkFailure: @escaping ()->()) -> Single<Profile> {
        
        let uri = "https://kream-waffle.cf/styles/profiles/"
        
        var headers : HTTPHeaders = [
            "accept": "application/json",
        ]
        if let token = token {
            headers.add(name: "Authorization", value: "Bearer \(token)")
        }
        
        return Single.create { single in
            AF.request(uri + "\(user_id)/", method: .get, headers: headers)
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
