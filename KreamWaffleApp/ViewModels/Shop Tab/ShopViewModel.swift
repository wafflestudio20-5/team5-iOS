//
//  ViewModel.swift
//  KreamWaffleApp
//
//  Created by 이선재 on 2022/12/24.
//
import Foundation
import Alamofire
import RxSwift

final class ShopViewModel {
    private let usecase: ShopUsecase
    
    var currentDeliveryTag: Int = 0
    var selectedCategory: [String]? = nil {
        didSet {
            // NotificationCenter (send selected fields)
            NotificationCenter.default.post(name: NSNotification.Name("categoryChanged"),
                                            object: [
                                                "category": selectedCategory,
                                            ],
                                            userInfo: nil)
        }
    }
    var selectedBrands: [Brand]? = nil
    var selectedPrices: [String]? = nil
    
    var page: Int = 1
    
    init(usecase: ShopUsecase) {
        self.usecase = usecase
        requestFilteredData(resetPage: true)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(updateDeliveryTag(_:)),
                                               name: NSNotification.Name("deliveryTagChanged"),
                                               object: nil)
    }
    
    @objc func updateDeliveryTag(_ notification: Notification) {
        guard let notification = notification.object as? [String: Any] else { return }
        guard let deliveryTag = notification["deliveryTag"] as? Int else { return }
       
        self.currentDeliveryTag = deliveryTag
    }
    
    var shopDataSource: Observable<[ProductData]> {
        return self.usecase.shopObservable
            .map { product in
                return product.map { ProductData(product: $0) }
            }
    }
     
    // filters
    var filterDataSource: Observable<[String]> {
        return self.usecase.filterCategories
    }
    
    var filterItemDataSource: Observable<[ShopFilterItem]> {
        return self.usecase.shopFilterItems
    }
    
    var categoryFilterItemListDataSource: Observable<[String]> {
        return self.usecase.categoryListObservable
    }
    
    var brandFilterItemListDataSource: Observable<[Brand]> {
        return self.usecase.brandFilterItemList
    }
    
    var priceFilterItemListDataSource: Observable<[String]> {
        return self.usecase.priceFilterItemList
    }

}

extension ShopViewModel {
    // get functions
    func getProductAtIndex(index: Int) -> Product {
        return self.usecase.getProductAtIndex(index: index)
    }
    
    func getFilterItemAtIndex(index: Int) -> ShopFilterItem {
        return self.usecase.getFilterItemAtIndex(index: index)
    }
    
    func getFilterItemRowAtIndex(filterItemIndex: Int, rowIndex: Int) -> String {
        return self.usecase.getFilterItemRowAtIndex(filterItemIndex: filterItemIndex, rowIndex: rowIndex)
    }
    
    func getBrandFilterItemRowAtIndex(filterItemIndex: Int, rowIndex: Int) -> Brand {
        return self.usecase.getBrandFilterItemRowAtIndex(filterItemIndex: filterItemIndex, rowIndex: rowIndex)
    }
}

extension ShopViewModel {
    // request all shopPosts without filtering
    func requestData() {
        self.usecase.loadShopPosts()
    }
    
    func requestMoreData() {
        self.usecase.loadMoreShopPosts()
    }
}

extension ShopViewModel {
    // request immediate delivery shopPosts
    func requestImmediateDeliveryData() {
        self.usecase.loadImmediateDeliveryShopPosts()
    }
    
    func requestMoreImmediateDeliveryData() {
        self.usecase.loadMoreImmediateDeliveryShopPosts()
    }
}

extension ShopViewModel {
    // request brand delivery shopPosts
    func requestBrandDeliveryData() {
        self.usecase.loadBrandDeliveryShopPosts()
    }
    
    func requestMoreBrandDeliveryData() {
//        self.usecase.loadMoreBrandDeliveryShopPosts()
    }
}

extension ShopViewModel {
    // request category shopPosts
    func requestCategoryData(selectedCategory: String) {
        self.usecase.loadCategoryShopPosts(selectedCategory: selectedCategory)
    }
    
    func requestMoreCategoryData() {
//        self.usecase.loadMoreCategoryShopPosts()
    }
}

extension ShopViewModel {
    // request brand shopPosts
    func requestBrandShopPostsData(selectedBrand: Int) {
        self.usecase.loadBrandShopPosts(selectedBrand: selectedBrand)
    }
    
    func requestMoreBrandShopPostsData() {
//        self.usecase.loadMoreBrandShopPosts()
    }
}

extension ShopViewModel {
    // request brands
    func requestBrandData() {
        self.usecase.loadBrands()
    }
}

extension ShopViewModel {
    func resetFilter() {
        self.selectedCategory = nil
        self.selectedBrands = nil
        self.selectedPrices = nil
    }
    
    func setSelectedCategory(category: String?) {
        if category == nil {
            self.selectedCategory = nil
        } else {
            self.selectedCategory = [category!]
        }
    }
    
    func setSelectedBrands(brands: [Brand]?) {
        self.selectedBrands = brands
    }
    
    func setSelectedPrices(prices: [String]?) {
        self.selectedPrices = prices
    }
    
    func setSelectedDelivery(deliveryTagIndex: Int) {
        self.currentDeliveryTag = deliveryTagIndex
    }
    
    
    func requestFilteredData(resetPage: Bool, category: [String]?, brands: [Brand]?, prices: [String]?, deliveryTag: Int) {
        self.usecase.loadFilteredData(resetPage: resetPage, category: category, brands: brands, prices: prices, deliveryTag: deliveryTag)
    }
    
    func requestFilteredData(resetPage: Bool) {
        let category = self.selectedCategory
        let brands = self.selectedBrands
        let prices = self.selectedPrices
        let deliveryTag = self.currentDeliveryTag
        
        if (resetPage == true) {
            self.page = 1
            self.usecase.loadFilteredData(resetPage: resetPage, category: category, brands: brands, prices: prices, deliveryTag: deliveryTag)
        } else {
            self.page += 1
            self.usecase.loadMoreFilteredData(resetPage: false, category: category, brands: brands, prices: prices, deliveryTag: deliveryTag, page: self.page)
        }
       
    }
}

struct ProductData {
    let id: Int
    let brand: Int
    let eng_name: String
    let kor_name: String
    let delivery_tag: String
    let productimage_set: [Int]
    let brand_name: String
    let price: Int
    let total_wishes: Int
    let total_shares: Int
    let  productimage_urls: [String]
//    let imageSource: [ProductImage]
    
    init(product: Product) {
        self.id = product.id
        self.brand = product.brand
        self.eng_name = product.eng_name
        self.kor_name = product.kor_name
        self.delivery_tag = product.delivery_tag
        self.productimage_set = product.productimage_set
        self.brand_name = product.brand_name
        self.price = product.price
        self.total_wishes = product.total_wishes
        self.total_shares = product.total_shares
        self.productimage_urls = product.productimage_urls
//        self.imageSource = product.imageSource
    }
}

