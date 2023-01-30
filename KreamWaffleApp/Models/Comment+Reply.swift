//
//  Comment+Reply.swift
//  KreamWaffleApp
//
//  Created by 최성혁 on 2023/01/27.
//

import Foundation

final class Comment : Codable {
    let comment_id: String
    let content: String
    let created_by: NestedProfile
    let created_at: String
    let replies: [Reply]
    
    init(comment_id: String, content: String, created_by: NestedProfile, created_at: String, replies: [Reply]) {
        self.comment_id = comment_id
        self.content = content
        self.created_by = created_by
        self.created_at = created_at
        self.replies = replies
    }
}

final class Reply : Codable {
    let reply_id: String
    let content: String
    let created_by: NestedProfile
    let created_at: String
    
    init(reply_id: String, content: String, created_by: NestedProfile, created_at: String) {
        self.reply_id = reply_id
        self.content = content
        self.created_by = created_by
        self.created_at = created_at
    }
}
