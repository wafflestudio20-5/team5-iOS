//
//  PriceFormatter.swift
//  KreamWaffleApp
//
//  Created by 이선재 on 2023/02/02.
//

import Foundation

class PriceFormatter {
    static func formatNumberToCurrency(intToFormat: Int) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        let formattedNumber = numberFormatter.string(from: NSNumber(value: intToFormat))
        return formattedNumber!
    }
}
