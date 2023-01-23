//
//  Profile.swift
//  KreamWaffleApp
//
//  Created by 최성혁 on 2023/01/21.
//

import Foundation

final class Profile {
    let user_id: Int
    let user_name: String
    let profile_name: String
    let introduction: String
    let image: String
    let num_followers: Int
    let num_followings: Int
    
    init(
        user_id: Int,
        user_name: String,
        profile_name: String,
        introduction: String,
        image: String,
        num_followers: Int,
        num_followings: Int
    ) {
        self.user_id = user_id
        self.user_name = user_name
        self.profile_name = profile_name
        self.introduction = introduction
        self.image = image
        self.num_followers = num_followers
        self.num_followings = num_followings
    }
    
    init() {
        self.user_id = 0
        self.user_name = "-"
        self.profile_name = "-"
        self.introduction = "-"
        self.image = ""
        self.num_followers = 0
        self.num_followings = 0
    }
}
