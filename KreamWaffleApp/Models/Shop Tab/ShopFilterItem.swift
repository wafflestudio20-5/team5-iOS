//
//  ShopFilterItem.swift
//  KreamWaffleApp
//
//  Created by 이선재 on 2023/01/29.
//

import Foundation

class ShopFilterItem {
    let header: String
    var selection: String
    var items: [String]
    
    init(header: String, selection: String, items: [String]) {
        self.header = header
        self.selection = selection
        self.items = items
    }
}
