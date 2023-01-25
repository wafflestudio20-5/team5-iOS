//
//  FollowButton.swift
//  KreamWaffleApp
//
//  Created by 최성혁 on 2023/01/20.
//

import Foundation
import UIKit

final class FollowButton: UIButton {
    var isFollowing = false

    func configureFollowButton() {
        if (self.isFollowing) {
            self.setTitle("팔로잉", for: .normal)
            self.layer.borderWidth = 1
            self.backgroundColor = .white
            self.setTitleColor(.black, for: .normal)
        } else {
            self.setTitle("팔로우", for: .normal)
            self.backgroundColor = .black
            self.setTitleColor(.white, for: .normal)
        }
    }
}
