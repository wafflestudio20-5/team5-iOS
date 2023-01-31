//
//  ShopFilterViewModel.swift
//  KreamWaffleApp
//
//  Created by 이선재 on 2023/01/29.
//

import Foundation
import RxSwift
import RxCocoa

final class ShopFilterViewModel {
    private let usecase: ShopUsecase
    
    init(usecase: ShopUsecase) {
        self.usecase = usecase
        requestBrandData()
    }
    
    var filterDataSource: Observable<[ShopFilterItem]> {
        return self.usecase.shopFilterItems
    }
    
    func requestBrandData() {
        self.usecase.loadBrands()
//        self.usecase.loadShopFilterItems()
    }
    
    func getFilterItemAtIndex(index: Int) -> ShopFilterItem {
        return self.usecase.getFilterItemAtIndex(index: index)
    }
}
