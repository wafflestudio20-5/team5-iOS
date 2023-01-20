//
//  ProductRequestModel.swift
//  KreamWaffleApp
//
//  Created by 이선재 on 2022/12/29.
//

import Foundation

struct ShopPostRequestParameters: Codable {
    var page: Int
    
    init(page: Int) {
        self.page = page
    }
}
