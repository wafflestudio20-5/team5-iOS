//
//  User.swift
//  KreamWaffleApp
//
//  Created by grace kim  on 2023/01/06.
//
import Foundation
import UIKit

struct User : Codable {
    let id: Int
    var email : String
    var shoeSize: Int
    var phoneNumber: String
    
    private enum CodingKeys: String, CodingKey {
        case id = "id"
        case email = "email"
        case shoeSize = "shoe_size"
        case phoneNumber = "phone_number"
    }
    
    //email parsing 된 아이디 넣기
    var parsed_email : String {
       return email.components(separatedBy: "@")[0]
    }
}

struct UserResponse: Codable {
    let accessToken : String
    let refreshToken : String
    var user: User
    let exists: Bool?
    
    private enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case refreshToken = "refresh_token"
        case user = "user"
        case exists = "exists"
    }
}

