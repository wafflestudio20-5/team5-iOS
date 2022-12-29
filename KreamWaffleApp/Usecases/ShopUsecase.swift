//
//  ShopUsecase.swift
//  KreamWaffleApp
//
//  Created by 이선재 on 2022/12/29.
//

import Foundation
import Alamofire
import RxSwift
import RxCocoa

final class ShopUsecase {
    private let repository: ShopRepository
    private let shopSubject: BehaviorRelay<[Product]> = .init(value: [])
    private let disposeBag = DisposeBag()
    private var page: Int = 1
    
    var productList = [Product]() {
        didSet {
            self.shopSubject.accept(self.productList)
        }
    }
    
    var products: Observable<[Product]> {
        return self.shopSubject.asObservable()
    }
    
    init(repository: ShopRepository) {
        self.repository = repository
//        NotificationCenter.default.addObserver(self,
//                                               selector: #selector(isLikedNotification(_:)),
//                                               name: NSNotification.Name("isLikedNotificationMovie"),
//                                               object: nil)
    }
    
    func requestProducts() {
//        let parameters = ShopRequestModel(page: self.page)
        
//        self.repository
//            .requestProducts(parameters: parameters)
//            .subscribe(onSuccess: { [weak self] fetchedProducts in
//                self?.productList = fetchedProducts
//            },
//            onFailure: { _ in
//                self.productList = []
//            })
//            .disposed(by: self.disposeBag)
    }
    
//    func loadMoreProducts() {
//        self.page += 1
//        let parameters = ShopRequestModel(page: self.page)
//
//        self.repository
//            .requestProducts(parameters: parameters)
//            .subscribe(onSuccess: { [weak self] fetchedProducts in
//                var prevProducts = self?.shopSubject.value ?? []
//                prevProducts.append(contentsOf: fetchedProducts)
//                self?.productList = prevProducts
//            },
//            onFailure: { _ in
//                self.productList = []
//            })
//            .disposed(by: self.disposeBag)
//    }
    
    func getProductAtIndex(index: Int) -> Product {
        return self.productList[index]
    }
}

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
