//
//  ProfileRepository.swift
//  KreamWaffleApp
//
//  Created by 최성혁 on 2023/01/21.
//

/*
 특정 유저의 프로필 접속했을 때 서버와 통신을 담당하는 repository
 예를 들어서, 특정 유저의 프로필에 표시될 팔로워 수와 목록, 팔로잉 수와 목록 받아오기
 해당 유저 팔로우 하기 기능 등
 */


import Foundation

final class UserProfileRepository {
    func requestProfile(user_id: Int) -> Profile {
        return self.testProfile
    }
    
    private let testProfile = Profile(user_id: 1,
                                      user_name: "swift_user_name",
                                      profile_name: "swift_profile_name",
                                      introduction: "아주아주 긴 상태메시지 이아러ㅣ나어리나어리ㅏㄴ어리낭러ㅣㄴ아러ㅣ낭러ㅣ낭러니아러니아러ㅣ나어리나어리나어리나어리낭러ㅣ낭러ㅣ낭러ㅣㅏㄴ어리나어리ㅏㄴ어리나어리낭러ㅣㅏ얾;ㅣㄴ아ㅓㄹ;ㅁ니ㅏ얼;ㅣㅁ나얼;니마얼;ㅣㅁ나얼;ㅣㄴㅁ어리;ㄴㅁㅇ",
                                      image: "https://cdn4.iconfinder.com/data/icons/social-media-logos-6/512/23-swift-512.png",
                                      num_followers: 100,
                                      num_followings: 1000)
}
