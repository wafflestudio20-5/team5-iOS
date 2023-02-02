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
                .responseDecodable(of: ProductSizesModel.self) { response in
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

}
