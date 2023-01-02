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
    
//    var productList = [Product]() {
//        didSet {
//            self.shopSubject.accept(self.productList)
//        }
//    }
    
    var productList: [Product] = [
        Product(imageSource: "https://static.nike.com/a/images/t_default/cb1ce49e-6014-46e8-b23e-527fd5985283/air-max-270-mens-shoes-KkLcGR.png", brand: "Jordan", productNameEng: "Jordan 1 Retro High OG Chicago 2022", productNameKor: "조던 1 레트로 하이 OG 시카고 2022", price: 399000, transactionCount: 18000, bookmarkCount: 30000, relatedStyleCount: 2282),
        Product(imageSource: "https://static.nike.com/a/images/t_default/15b7a1db-3a75-4887-b22c-99f1a6468ab6/air-vapormax-2021-flyknit-shoes-T96BrP.png", brand: "Jordan", productNameEng: "Jordan 1 x Travis Scott Retro Low OG SP Black Phantom", productNameKor: "조던 1 x 트래비스 스캇 로우 OG SP 블랙 팬텀", price: 904000, transactionCount: 1489, bookmarkCount: 5515, relatedStyleCount: 128),
        Product(imageSource: "https://store.storeimages.cdn-apple.com/4982/as-images.apple.com/is/airpods-max-hero-select-202011_FMT_WHH?wid=607&hei=556&fmt=jpeg&qlt=90&.v=1633623988000", brand: "Apple", productNameEng: "Apple AirPods Max Silver (Korean Ver.)", productNameKor: "애플 에어팟 맥스 실버 (국내 정식 제품)", price: 764000, transactionCount: 30000, bookmarkCount: 19000, relatedStyleCount: 698),
        Product(imageSource: "https://store.storeimages.cdn-apple.com/4982/as-images.apple.com/is/iphone-card-40-iphone14pro-202209_FMT_WHH?wid=508&hei=472&fmt=p-jpg&qlt=95&.v=1663611329204", brand: "Apple", productNameEng: "Apple iPhone 14 Pro 128GB Space Black (Korean Ver.)", productNameKor: "에플 아이폰 14 프로 128기가 스페이스 블랙 (국내 정식 발매 제품)", price: 1546000, transactionCount: 1596, bookmarkCount: 1271, relatedStyleCount: 33)
    ]
    
    var products: Observable<[Product]> {
        self.shopSubject.accept(self.productList)
        return self.shopSubject.asObservable()
    }
    
    init(repository: ShopRepository) {
        self.repository = repository
//        NotificationCenter.default.addObserver(self,
//                                               selector: #selector(isLikedNotification(_:)),
//                                               name: NSNotification.Name("isLikedNotificationMovie"),
//                                               object: nil)
    }
    
    func requestData() {
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

