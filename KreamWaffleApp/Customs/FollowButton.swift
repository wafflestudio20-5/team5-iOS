//
//  FollowButton.swift
//  KreamWaffleApp
//
//  Created by 최성혁 on 2023/01/20.
//

import Foundation
import UIKit

final class FollowButton: UIButton {
    enum followButtonStatus {
        case isActivated
        case isDeactivated
        case isHidden
    }
    
    var followButtonStatus: followButtonStatus = .isDeactivated
    
    func configure(following: String?) {
        if let isFollowing = following {
            self.isHidden = false
            if isFollowing == "login required" {
                self.followButtonStatus = .isDeactivated
            } else if isFollowing == "true" {
                self.isFollowing = true
                self.followButtonStatus = .isActivated
            } else { //isFollowing == "false"
                self.isFollowing = false
                self.followButtonStatus = .isActivated
            }
        } else { //자기 자신이 쓴 글일 때
            self.isHidden = true
            self.followButtonStatus = .isHidden
        }
    }
    
    private var isFollowing = false {
        didSet {
            configureFollowButton()
        }
    }
    
    init() {
        self.followButtonStatus = .isDeactivated
        super.init(frame: CGRect.zero)
        self.setTitle("팔로우", for: .normal)
        self.backgroundColor = .black
        self.setTitleColor(.white, for: .normal)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func followButtonTapped() {
        switch self.followButtonStatus {
        case .isActivated:
            isFollowing = !isFollowing
        case .isDeactivated:
            return
        case .isHidden:
            return
        }
    }
    
    private func configureFollowButton() {
        if (isFollowing) {
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
