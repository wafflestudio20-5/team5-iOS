//
//  StyleUsecase.swift
//  KreamWaffleApp
//
//  Created by 최성혁 on 2022/12/29.
//

import Foundation

final class StyleUsecase {
    private let repository: StyleRepository
    
    init (repository: StyleRepository) {
        self.repository = repository
    }
}
