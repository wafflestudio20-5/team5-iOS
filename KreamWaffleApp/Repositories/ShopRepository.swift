//
//  ShopRepository.swift
//  KreamWaffleApp
//
//  Created by 최성혁 on 2022/12/29.
//

final class ShopRepository {
//    func requestProducts(parameters: ProductRequestModel) -> Single<[Product]> {
//        return Single.create { single in
//            let url = URL(string: "https://api.themoviedb.org/3/movie/popular")
//
//            let headers: HTTPHeaders = [
//                "Authorization": "eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiIxMDMzZWEzYTRhM2RiNmM4ZmE2NDYxNDkzYzA3NGI4YiIsInN1YiI6IjYzNDI1OTY0YTI4NGViMDA3OWM0MTYxZCIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.eV0F9zBLPdjef9gth_012Q3We_jiY_bjLRyuaqS9DkI"
//            ]
//
//            AF.request(url!, method: .get, parameters: parameters, headers: headers)
//                .responseDecodable(of: ShopModel.self) { [weak self] response in
//                    switch response.result {
//                    case .success(let result):
//                        single(.success(result.results))
//                    case .failure(let _):
//                        single(.success([]))
//                    }
//                }
//
//            return Disposables.create()
//        }
//    }
}
