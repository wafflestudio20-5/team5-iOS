//
//  StyleTabDetailUsecase.swift
//  KreamWaffleApp
//
//  Created by 최성혁 on 2023/01/17.
//

import Foundation

final class StyleDetailUsecase {
    let repository: StyleDetailRepository
    
    init(repository: StyleDetailRepository) {
        self.repository = repository
    }
}
