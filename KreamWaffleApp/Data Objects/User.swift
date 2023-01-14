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

/*login user reponse 이런 형식
 {
   "access_token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoiYWNjZXNzIiwiZXhwIjoxNjczMzMzMDM2LCJpYXQiOjE2NzMzMzEyMzYsImp0aSI6IjA3NjExZjI3OGU5YTRmNDZhOGYwMzEyNTk1MTM3ZjdkIiwidXNlcl9pZCI6MTB9.21S-E-GYxyXS_2OcMlpyhSzrIs0RL2kkg7BqXmHgPQc",
   "refresh_token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTY3MzQxNzYzNiwiaWF0IjoxNjczMzMxMjM2LCJqdGkiOiJiMmExYTkzMzZjMzM0OTA0Yjg5MDk1M2EyMDk3ODZiYiIsInVzZXJfaWQiOjEwfQ.lpRibhY9Gqu90BxBpIaV2pJBAUUHULcmVhpEgYyra4w",
   "user": {
     "id": 10,
     "email": "kreamwaffle2023@gmail.com",
     "shoe_size": 240,
     "phone_number": ""
   }
 }*/
