//
//  FollowerUserListRepository.swift
//  KreamWaffleApp
//
//  Created by 최성혁 on 2023/01/19.
//

import Foundation

final class FollowerUserListRepository: UserListRepositoryProtocol {
    let testData = [
        NestedProfile(user_id: 1,
                      user_name: "first_follower",
                      profile_name: "first_follower_profile_name",
                      image: "https://developer.apple.com/swift/images/swift-og.png"
        ),
        NestedProfile(user_id: 2,
                      user_name: "second_follower",
                      profile_name: "second_follower_profile_name",
                      image: "https://logos-world.net/wp-content/uploads/2021/10/Python-Symbol.png"
        )
    ]
    
    
    func userListApiRequest(page: Int, completion: (Error?, [NestedProfile]?) -> Void) {
        completion(nil, testData)
    }
    
    func followRequest(user_id: String) {
        return
    }
}
