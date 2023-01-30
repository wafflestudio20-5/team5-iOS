//
//  Token.swift
//  KreamWaffleApp
//
//  Created by grace kim  on 2023/01/30.
//

import Foundation
import UIKit

struct TokenVerify : Codable {
    let token : String

    private enum CodingKeys: String, CodingKey {
        case token = "token"
    }
}

//TODO: 저 date 를 사용하는게 맞을까 아니면 그냥 항상 valid 한지 물어보는게 맞을까.
struct NewTokenResponse: Codable {
    let accessToken : String
    let expirationDate : String

    private enum CodingKeys: String, CodingKey {
        case accessToken = "access"
        case expirationDate = "access_token_expiration"
    }
}

