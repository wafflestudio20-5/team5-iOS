//
//  UserShopRepository.swift
//  KreamWaffleApp
//
//  Created by grace on 2023/02/03.
//

import Foundation
import Alamofire
import RxCocoa
import RxSwift

enum myShopDataType{
    case purchase
    case sale
}

//used for my page shop tab
class UserShopRepository {
    
    //처음에 숫자 가지고 오는 구조. 
    func requestShopPostData(parameters: ShopPostRequestParameters, token: String, myShopType: myShopDataType) -> Single<UserProductResponse> {
        return Single.create { single in
            
            var url : URL
            switch (myShopType){
            case .purchase:
                url = URL(string: "https://kream-waffle.cf/shop/purchasebids/")!
            case .sale:
                url = URL(string: "https://kream-waffle.cf/shop/salesbids/")!
            }
            
            let headers: HTTPHeaders = [
                "accept": "application/json",
                "Authorization": "Bearer \(token)"
            ]
            
            AF.request(url, method: .get, parameters: parameters, headers: headers)
                .validate()
                .responseDecodable(of: UserProductResponse.self) { [weak self] response in
                    print("=======shop========")
                    debugPrint(response)
                    switch response.result {
                    case .success(let result):
                        single(.success(result))
                        print("여기여기여기여기 \(result.count)")
                    case .failure(let _):
                        single(.success(UserProductResponse(count: 0, next: "", previous: "", itemList: [])))
                    }
                }
            return Disposables.create()
        }
    }
}
