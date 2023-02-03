//
//  ShopDetailRepository.swift
//  KreamWaffleApp
//
//  Created by 이선재 on 2023/02/01.
//

import Foundation
import Alamofire
import RxCocoa
import RxSwift

final class ShopDetailRepository {
    func requestProductSizeInfo(id: Int) -> Single<[ProductSize]> {
        return Single.create { single in
            let url = URL(string: "https://kream-waffle.cf/shop/productinfos/\(id)/products/")
            let headers: HTTPHeaders = [
                "accept": "application/json",
                "X-CSRFToken": "wAUIiwaucgMaZgb5kRFX0pfg671QBCmNGstFne8OngndR1VP0fkVC1EkwT3V22by"
            ]
            
            AF.request(url!, method: .get, headers: headers)
                .responseDecodable(of: ProductSizeModel.self) { response in
                    switch response.result {
                    case .success(let result):
                        let productSizeInfoList = result.results
//                        print(productSizeInfoList)
                        single(.success(productSizeInfoList))
                    case .failure(let _):
                        single(.success([]))
                    }
                }
            return Disposables.create()
        }
    }
    
    func requestProductSizes(token: String, id: Int, completionHandler: @escaping (Error?, [ProductSize]?) -> Void) {
            let url = URL(string: "https://kream-waffle.cf/shop/productsinfos/\(id)/sizes/")
            let headers: HTTPHeaders = [
                "accept": "application/json",
                "X-CSRFToken": "wAUIiwaucgMaZgb5kRFX0pfg671QBCmNGstFne8OngndR1VP0fkVC1EkwT3V22by",
                "Authorization": "Bearer \(token)"
            ]
            
            print("Bearer \(token)")
            
            URLSession.shared.dataTask(with: url!, completionHandler: { data, response, error in
                           guard let data = data, error == nil else {
                               print("something went wrong.")
                               return
                           }
                           var result: [ProductSize]?
                           do {
                               result = try JSONDecoder().decode([ProductSize].self, from: data)
                               print(result)
                               completionHandler(nil, result)
                           }
                           catch {
                               print(error)
                               completionHandler(error, [])
                           }

                       }).resume()
            
//            AF.request(url!, method: .get, headers: headers)
//                .validate()
//                .responseDecodable(of: ProductSizeModel.self) { response in
//                    switch response.result {
//                    case .success(let result):
//                        print(result)
//                        let productSizeInfoList = result.results
////                        print(productSizeInfoList)
//                        single(.success(productSizeInfoList))
//                    case .failure(let _):
//                        print(response.error)
//                        print("failed to request sizes")
//                        single(.success([]))
//                    }
//                }
         
    }
    

}
