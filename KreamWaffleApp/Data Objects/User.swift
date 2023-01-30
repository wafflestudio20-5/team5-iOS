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
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        shoeSize = (try? values.decode(Int.self, forKey: .shoeSize)) ?? 0 //if shoe size is 0 --> nil 값이랑 같음.
        phoneNumber = (try? values.decode(String.self, forKey: .phoneNumber)) ?? ""
        id = (try? values.decode(Int.self, forKey: .id)) ?? 0
        email = (try? values.decode(String.self, forKey: .email)) ?? ""
    }
    
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
    var accessToken : String {
        didSet {
            print("\n\n🎇🎇🎇🎇🎇🎇🎇🎇🎇🎇🎇token changed to: \(accessToken)🎇🎇🎇🎇🎇🎇🎇🎇🎇🎇🎇\n\n")
        }
    }
    var refreshToken : String
    var user: User
    let exists: Bool?
    
    private enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case refreshToken = "refresh_token"
        case user = "user"
        case exists = "exists"
    }
}

