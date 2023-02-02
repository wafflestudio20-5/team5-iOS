//
//  Comment+Reply.swift
//  KreamWaffleApp
//
//  Created by 최성혁 on 2023/01/27.
//

import Foundation
//style 탭과 shop 탭의 comment, reply를 전반적으로 담당하는 모델

final class CommentResponse: Codable {
    private enum CodingKeys: String, CodingKey {
        case next, previous, results
    }
    
    let next: String?
    let previous: String?
    let results: [Comment]
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.next = try container.decodeIfPresent(String.self, forKey: .next) ?? nil
        self.previous = try container.decodeIfPresent(String.self, forKey: .previous) ?? nil
        self.results = try container.decodeIfPresent([Comment].self, forKey: .results) ?? []
    }
}

final class Comment: Codable {
    private enum CodingKeys: String, CodingKey {
        case id, content, created_by, created_at, replies
    }
    
    let id: Int
    let content: String
    let created_by: NestedProfile
    let created_at: String
    let replies: [Reply]
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.id = try container.decodeIfPresent(Int.self, forKey: .id) ?? -1
        self.content = try container.decodeIfPresent(String.self, forKey: .content) ?? "-"
        self.created_by = try container.decodeIfPresent(NestedProfile.self, forKey: .created_by) ?? NestedProfile()
        self.created_at = try container.decodeIfPresent(String.self, forKey: .created_at) ?? "-"
        self.replies = try container.decodeIfPresent([Reply].self, forKey: .replies) ?? []
    }
}

final class Reply: Codable {
    private enum CodingKeys: String, CodingKey {
        case id, content, to_profile, created_by, created_at
    }
    
    let id: Int
    let content: String
    let to_profile: ReplyToProfile
    let created_by: NestedProfile
    let created_at: String
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.id = try container.decodeIfPresent(Int.self, forKey: .id) ?? -1
        self.content = try container.decodeIfPresent(String.self, forKey: .content) ?? "-"
        self.to_profile = try container.decodeIfPresent(ReplyToProfile.self, forKey: .to_profile) ?? ReplyToProfile()
        self.created_by = try container.decodeIfPresent(NestedProfile.self, forKey: .created_by) ?? NestedProfile()
        self.created_at = try container.decodeIfPresent(String.self, forKey: .created_at) ?? "-"
    }
}

final class ReplyToProfile: Codable {
    private enum CodingKeys: String, CodingKey {
        case user_id, profile_name
    }
    
    let user_id: Int
    let profile_name: String
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.user_id = try container.decodeIfPresent(Int.self, forKey: .user_id) ?? -1
        self.profile_name = try container.decodeIfPresent(String.self, forKey: .profile_name) ?? "-"
    }
    
    init() {
        self.user_id = -1
        self.profile_name = ""
    }
}
