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
                        
                        let group = DispatchGroup()
                        for (var product) in productInfoList {
                            // request brand_name
                            group.enter()
                            self?.requestShopPostBrand(brandId: product.brand) { (error, brandName) in
                                product.brand_name = brandName!
                                group.leave()
                            }
                            
                            // request productimages
                            group.enter()
                            self?.requestProductImages(id: product.id) { (error, productImages) in
                                product.imageSource = productImages!
                                group.leave()
                            }
                        }
                        
                        group.notify(queue: .main) {
                            single(.success(productInfoList))
                        }
                        
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
                    
                        let group = DispatchGroup()
                        for (var product) in productInfoList {
                            // request brand_name
                            group.enter()
                            self?.requestShopPostBrand(brandId: product.brand) { (error, brandName) in
                                product.brand_name = brandName!
                                group.leave()
                            }
                            
                            // request productimages
                            group.enter()
                            self?.requestProductImages(id: product.id) { (error, productImages) in
                                product.imageSource = productImages!
                                group.leave()
                            }
                            
                        }
                    
                        group.notify(queue: .main) {
                            single(.success(productInfoList))
                        }
                        
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
                        
                        let group = DispatchGroup()
                        for (var product) in productInfoList {
                            // request brand_name
                            group.enter()
                            self?.requestShopPostBrand(brandId: product.brand) { (error, brandName) in
                                product.brand_name = brandName!
                                group.leave()
                            }
                            
                            // request productimages
                            group.enter()
                            self?.requestProductImages(id: product.id) { (error, productImages) in
                                product.imageSource = productImages!
                                group.leave()
                            }
                            
                        }
                        
                        group.notify(queue: .main) {
                            single(.success(productInfoList))
                        }
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
                        
                        let group = DispatchGroup()
                        for (var product) in productInfoList {
                            // request brand_name
                            group.enter()
                            self?.requestShopPostBrand(brandId: product.brand) { (error, brandName) in
                                product.brand_name = brandName!
                                group.leave()
                            }
                            
                            // request productimages
                            group.enter()
                            self?.requestProductImages(id: product.id) { (error, productImages) in
                                product.imageSource = productImages!
                                group.leave()
                            }
                            
                        }
                        
                        group.notify(queue: .main) {
                            single(.success(productInfoList))
                        }
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
                        
                        let group = DispatchGroup()
                        for (var product) in productInfoList {
                            // request brand_name
                            group.enter()
                            self?.requestShopPostBrand(brandId: product.brand) { (error, brandName) in
                                product.brand_name = brandName!
                                group.leave()
                            }
                            
                            // request productimages
                            group.enter()
                            self?.requestProductImages(id: product.id) { (error, productImages) in
                                product.imageSource = productImages!
                                group.leave()
                            }
                            
                        }
                        
                        group.notify(queue: .main) {
                            single(.success(productInfoList))
                        }
                    case .failure(let _):
                        single(.success([]))
                    }
                }

            return Disposables.create()
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
