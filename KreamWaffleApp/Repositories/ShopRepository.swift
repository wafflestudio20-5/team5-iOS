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
    let categoryToUrlString: [String : String] = ["신발" : "shoes", "의류": "clothes", "패션 잡화" : "fashion", "라이프" : "life", "테크" : "tech"]
    let priceToUrlString: [String : String] = ["10만원 이하" : "-100000", "10만원 - 30만원 이하" : "100000-300000", "30만원 - 50만원 이하" : "300000-500000", "50만원 이상" : "500000-"]
    
    var filterUrl = ""
    
    func requestShopPostData(parameters: ShopPostRequestParameters) -> Single<[Product]> {
        return Single.create { single in
            let url = URL(string: "https://kream-waffle.cf/shop/productinfos/")
            let headers: HTTPHeaders = [
                "accept": "application/json",
                "X-CSRFToken": "jbFr0YqXW1gRUCkvMe5fASSCsdzPJUpHt3eo5Goh71RUMn4fsCKdcuhGSZBUakes"
            ]
            
            AF.request(url!, method: .get, parameters: parameters, headers: headers)
                .responseDecodable(of: ShopPostModel.self) { [weak self] response in
                    switch response.result {
                    case .success(let result):
                        let productInfoList = result.results
                        single(.success(productInfoList))
                    case .failure(let _):
                        single(.success([]))
                    }
                }
            return Disposables.create()
        }
    }
    
    func requestImmediateDeliveryShopPostData(parameters: ShopPostRequestParameters) -> Single<[Product]> {
        return Single.create { single in
            let url = URL(string: "https://kream-waffle.cf/shop/productinfos/?delivery_tag=immediate&page=\(parameters.page)")
            let headers: HTTPHeaders = [
                "accept": "application/json",
                "X-CSRFToken": "jbFr0YqXW1gRUCkvMe5fASSCsdzPJUpHt3eo5Goh71RUMn4fsCKdcuhGSZBUakes"
            ]
            
            AF.request(url!, method: .get, parameters: parameters, headers: headers)
                .responseDecodable(of: ShopPostModel.self) { [weak self] response in
                    switch response.result {
                    case .success(let result):
                        let productInfoList = result.results
                        single(.success(productInfoList))
                    case .failure(let _):
                        single(.success([]))
                    }
                }

            return Disposables.create()
        }
    }
    
    func requestBrandDeliveryShopPostData(parameters: ShopPostRequestParameters) -> Single<[Product]> {
        return Single.create { single in
            let url = URL(string: "https://kream-waffle.cf/shop/productinfos/?delivery_tag=brand&page=\(parameters.page)")
            let headers: HTTPHeaders = [
                "accept": "application/json",
                "X-CSRFToken": "jbFr0YqXW1gRUCkvMe5fASSCsdzPJUpHt3eo5Goh71RUMn4fsCKdcuhGSZBUakes"
            ]
            
            AF.request(url!, method: .get, parameters: parameters, headers: headers)
                .responseDecodable(of: ShopPostModel.self) { [weak self] response in
                    switch response.result {
                    case .success(let result):
                        let productInfoList = result.results
                        single(.success(productInfoList))
                    case .failure(let _):
                        single(.success([]))
                    }
                }

            return Disposables.create()
        }
    }
    
    func requestCategoryShopPostData(parameters: ShopPostRequestParameters, category: String) -> Single<[Product]> {
        return Single.create { single in
            let url = URL(string: "https://kream-waffle.cf/shop/productinfos/?category=\(category)&page=\(parameters.page)")
            let headers: HTTPHeaders = [
                "accept": "application/json",
                "X-CSRFToken": "jbFr0YqXW1gRUCkvMe5fASSCsdzPJUpHt3eo5Goh71RUMn4fsCKdcuhGSZBUakes"
            ]
            
            AF.request(url!, method: .get, parameters: parameters, headers: headers)
                .responseDecodable(of: ShopPostModel.self) { [weak self] response in
                    switch response.result {
                    case .success(let result):
                        let productInfoList = result.results
                        single(.success(productInfoList))
                    case .failure(let _):
                        single(.success([]))
                    }
                }

            return Disposables.create()
        }
    }
    
    func requestBrandShopPostData(parameters: ShopPostRequestParameters, brandId: Int) -> Single<[Product]> {
        return Single.create { single in
            let url = URL(string: "https://kream-waffle.cf/shop/productinfos/?brand_id=\(brandId)&page=\(parameters.page)")
            let headers: HTTPHeaders = [
                "accept": "application/json",
                "X-CSRFToken": "jbFr0YqXW1gRUCkvMe5fASSCsdzPJUpHt3eo5Goh71RUMn4fsCKdcuhGSZBUakes"
            ]
            
            AF.request(url!, method: .get, parameters: parameters, headers: headers)
                .responseDecodable(of: ShopPostModel.self) { [weak self] response in
                    switch response.result {
                    case .success(let result):
                        let productInfoList = result.results
                        single(.success(productInfoList))
                    case .failure(let _):
                        single(.success([]))
                    }
                }

            return Disposables.create()
        }
    }
}


extension ShopRepository {
    func requestProductSizes(id: Int, completionHandler: @escaping (Error?, [ProductSize]?) -> Void) {
        let url = URL(string: "https://kream-waffle.cf/shop/productinfos/1/products/")
        let headers: HTTPHeaders = [
            "accept": "application/json",
            "X-CSRFToken": "wAUIiwaucgMaZgb5kRFX0pfg671QBCmNGstFne8OngndR1VP0fkVC1EkwT3V22by"
        ]
        
        AF.request(url!, method: .get, headers: headers)
            .responseDecodable(of: ProductSizeModel.self) { response in
                switch response.result {
                case .success(let result):
//                    print(result)
//                    print(result.results)
                    completionHandler(nil, result.results)
                case .failure(let error):
                    print("failed to request product size")
//                    completionHandler(error, [])
                }
            }
    }
}

extension ShopRepository {
    func requestShopPostBrand(brandId: Int, completionHandler: @escaping (Error?, String?) -> Void ) {
            let url = URL(string: "https://kream-waffle.cf/shop/brands/\(brandId)/")
            let headers: HTTPHeaders = [
                "accept": "application/json",
                "X-CSRFToken": "nHKHrNlTUrEBFZIDSHToNTxps40X6UGjxzjEwvjd5rfExKsny5ympvWtSQ22xkv4"
            ]
            
            AF.request(url!, method: .get, headers: headers)
                .responseDecodable(of: ShopBrandModel.self) { response in
                    switch response.result {
                    case .success(let result):
                        completionHandler(nil, result.name)
                    case .failure(let error):
                        print("failed to request brand")
                        completionHandler(error, "N/A")
                    }
                }
    }
    
    func requestProductImages(id: Int, completionHandler: @escaping (Error?, [ProductImage]?) -> Void) {
        let url = URL(string: "https://kream-waffle.cf/shop/productinfos/\(id)/images/")
        let headers: HTTPHeaders = [
            "accept": "application/json",
            "X-CSRFToken": "nHKHrNlTUrEBFZIDSHToNTxps40X6UGjxzjEwvjd5rfExKsny5ympvWtSQ22xkv4"
        ]
        
        AF.request(url!, method: .get, headers: headers)
            .responseDecodable(of: ProductImagesModel.self) { response in
                switch response.result {
                case .success(let result):
                    
                    completionHandler(nil, result.images)
                case .failure(let error):
                    print("failed to request product images")
                    completionHandler(error, [])
                }
            }
    }
}

extension ShopRepository {
    func requestBrandsData(parameters: ShopPostRequestParameters) -> Single<[Brand]> {
        return Single.create { single in
            let url = URL(string: "https://kream-waffle.cf/shop/brands/?page=\(parameters.page)")
            let headers: HTTPHeaders = [
                "accept": "application/json",
                "X-CSRFToken": "khgrTJ6oipGptgRNvzLdttD77dOPSSksu9PoYr4Itphsl1BxbXqb552bxZQUji9d"
            ]
            
            AF.request(url!, method: .get, parameters: parameters, headers: headers)
                .responseDecodable(of: ShopBrandsModel.self) { [weak self] response in
                    switch response.result {
                    case .success(let result):
                        let brandsList = result.results
                        single(.success(brandsList))
                    case .failure(let _):
                        single(.success([]))
                    }
                }

            return Disposables.create()
        }
    }
}

extension ShopRepository {
    func requestFilteredShopPostData(parameters: ShopPostRequestParameters, category: [String]?, brands: [Brand]?, prices: [String]?, deliveryTag: Int) -> Single<[Product]> {
        return Single.create { single in
            self.filterUrl = "?page=\(parameters.page)"
            
            if (category != nil) {
                let selectedCategory = category![0]
                self.filterUrl = self.filterUrl + "&category=\(self.categoryToUrlString[selectedCategory]!)"
            }
            if (brands != nil) {
                for brand in brands! {
                    self.filterUrl = self.filterUrl + "&brand_id=\(brand.id)"
                }
            }
            if (prices != nil) {
                for price in prices! {
                    self.filterUrl = self.filterUrl + "&price=\(self.priceToUrlString[price]!)"
                }
            }
            
            if (deliveryTag == 1) {
                self.filterUrl = self.filterUrl + "&delivery_tag=immediate"
            } else if (deliveryTag == 2) {
                self.filterUrl = self.filterUrl + "&delivery_tag=brand"
            }
                
            print(self.filterUrl)
            
            let url = URL(string: "https://kream-waffle.cf/shop/productinfos/\(self.filterUrl)")
            
            let headers: HTTPHeaders = [
                "accept": "application/json",
                "X-CSRFToken": "jbFr0YqXW1gRUCkvMe5fASSCsdzPJUpHt3eo5Goh71RUMn4fsCKdcuhGSZBUakes"
            ]
            
            AF.request(url!, method: .get, parameters: parameters, headers: headers)
                .responseDecodable(of: ShopPostModel.self) { [weak self] response in
                    switch response.result {
                    case .success(let result):
                        let productInfoList = result.results
                        single(.success(productInfoList))
                    case .failure(let _):
                        single(.success([]))
                    }
                }
            return Disposables.create()
        }
    }
}
