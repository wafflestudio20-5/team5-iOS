//
//  ShopRepository.swift
//  KreamWaffleApp
//
//  Created by 최성혁 on 2022/12/29.
//

import Foundation
import Alamofire
import RxCocoa
import RxSwift

final class ShopRepository {
    func requestShopPostData(page: Int, completionHandler: @escaping (Error?, [Product]?) -> Void) {
        let url = URL(string: "https://kream-waffle.cf/shop/productinfos/")

        let headers: HTTPHeaders = [
            "accept": "application/json",
            "X-CSRFToken": "jbFr0YqXW1gRUCkvMe5fASSCsdzPJUpHt3eo5Goh71RUMn4fsCKdcuhGSZBUakes"
        ]
        
        URLSession.shared.dataTask(with: url!, completionHandler: { data, response, error in
                guard let data = data, error == nil else {
                    print("something went wrong.")
                    return
                }
                var result: [Product]?
                do {
                    result = try JSONDecoder().decode([Product].self, from: data)
                    completionHandler(nil, result)
                }
                catch {
                    print(error)
                    completionHandler(error, [])
                }

            }).resume()
    }
    
  
//    func requestShopPostData(page: Int) -> Single<[Product]> {
//
//        return Single.create { single in
//
//            let url = URL(string: "https://kream-waffle.cf/shop/productinfos/")
//
//            let headers: HTTPHeaders = [
//                "accept": "application/json",
//                "X-CSRFToken": "jbFr0YqXW1gRUCkvMe5fASSCsdzPJUpHt3eo5Goh71RUMn4fsCKdcuhGSZBUakes"
//            ]
//
////            AF.request(url!, method: .get, headers: headers)
////                .responseDecodable(of: ShopModel.self) { [weak self] response in
////                    switch response.result {
////                    case .success(let result):
////                        print(result)
////                        single(.success(result))
////                    case .failure(let _):
////                        print("failure")
////                        single(.success([]))
////                    }
////                }
//
//            return Disposables.create()
//        }
//    }
    

}
