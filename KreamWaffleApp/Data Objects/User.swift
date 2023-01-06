//
//  User.swift
//  KreamWaffleApp
//
//  Created by grace kim  on 2023/01/06.
//

import Foundation
import UIKit

struct User : Decodable {
    let id: Int
    var email : String
    var shoe_size: Int?
    var phone_number: String?
    
    /*
     TODO: not decodable error?
    private enum CodingKeys: String, CodingKey {
        case shoeSize = "shoe_size"
        case phoneNumber = "phone_number"
    }*/
}

struct UserReponse: Decodable {
    let access_token : String
    let refresh_token : String
    var user: User
    var exists : Bool
    
    /*
    private enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case refreshToken = "refresh_token"
    }*/
}


