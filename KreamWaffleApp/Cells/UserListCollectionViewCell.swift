//
//  UserListCollectionViewCell.swift
//  KreamWaffleApp
//
//  Created by 최성혁 on 2023/01/19.
//

import Foundation
import UIKit
import Kingfisher


class UserListCollectionViewCell: UICollectionViewCell {
    let profileImageWidth: CGFloat = 90
    let h1FontSize: CGFloat = 14 // profileNameLabel
    let h2FontSize: CGFloat = 13 // userNameLabel
    let mainFontColor: UIColor = .black
    let subFontColor: UIColor = .darkGray
    
    let profileNameLabel = UILabel()
    let userNameLabel = UILabel()
    let profileImageView = UIImageView()
    let followButton = UIButton()
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setUpLayout()
    }
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setUpLayout()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.profileImageView.image = nil
    }
    
    func configure(with nestedProfile: NestedProfile) {
        self.profileNameLabel.text = nestedProfile.profile_name
        self.userNameLabel.text = nestedProfile.user_name
        
        let urlString = nestedProfile.image
        guard let url = URL.init(string: urlString) else {
                return
            }
        let resource = ImageResource(downloadURL: url)

        KingfisherManager.shared.retrieveImage(with: resource, options: nil, progressBlock: nil) { result in
            switch result {
            case .success(let value):
                self.profileImageView.image = value.image
            case .failure(let error):
                print("Error: \(error)")
                //나중에는 여기 뭔가 이미지를 가져오는 과정에서 에러가 발생했다는 표시가 되는 이미지 넣자.
            }
        }
    }
    
    func setUpLayout() {
        setUpProfileImageView()
        setUpProfileNameLabel()
        setUpUserNameLabel()
        setUpFollowButton()
    }
    
    func setUpProfileImageView() {
        self.contentView.addSubview(profileImageView)
        
        let imageHeight = UIScreen.main.bounds.height/16
        
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.profileImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 7.5),
            self.profileImageView.widthAnchor.constraint(equalToConstant: imageHeight),
            self.profileImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            self.profileImageView.heightAnchor.constraint(equalToConstant: imageHeight),
        ])
        profileImageView.contentMode = .scaleAspectFit
        profileImageView.layer.cornerRadius = imageHeight/2
        profileImageView.clipsToBounds = true
    }
    
    func setUpProfileNameLabel() {
        self.profileNameLabel.font = UIFont.boldSystemFont(ofSize: self.h1FontSize)
        self.profileNameLabel.textColor = self.subFontColor
        self.profileNameLabel.lineBreakMode = .byTruncatingTail
        self.profileNameLabel.numberOfLines = 1
        self.profileNameLabel.textAlignment = .left
        self.profileNameLabel.adjustsFontSizeToFitWidth = false
        
        contentView.addSubview(profileNameLabel)
        profileNameLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.profileNameLabel.leadingAnchor.constraint(equalTo: self.profileImageView.trailingAnchor, constant: 7),
            self.profileNameLabel.widthAnchor.constraint(equalTo: self.contentView.widthAnchor, multiplier: 0.5),
            self.profileNameLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 5),
            self.profileNameLabel.heightAnchor.constraint(equalTo: self.contentView.heightAnchor, multiplier: 0.3),
        ])
    }
    
    func setUpUserNameLabel() {
        self.userNameLabel.font = UIFont.boldSystemFont(ofSize: self.h2FontSize)
        self.userNameLabel.textColor = self.subFontColor
        self.userNameLabel.lineBreakMode = .byTruncatingTail
        self.userNameLabel.numberOfLines = 1
        self.userNameLabel.textAlignment = .left
        self.userNameLabel.adjustsFontSizeToFitWidth = false
        
        contentView.addSubview(userNameLabel)
        userNameLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.userNameLabel.leadingAnchor.constraint(equalTo: self.profileNameLabel.leadingAnchor),
            self.userNameLabel.widthAnchor.constraint(equalTo: self.contentView.widthAnchor, multiplier: 0.5),
            self.userNameLabel.topAnchor.constraint(equalTo: self.profileNameLabel.bottomAnchor, constant: 3),
            self.userNameLabel.heightAnchor.constraint(equalTo: self.contentView.heightAnchor, multiplier: 0.3),
        ])
    }
    
    func setUpFollowButton() {
        // **팔로우 상태에 따라 다르게. 나중에 수정해야함.
        followButton.setTitle("팔로우", for: .normal)
        // **************************************
        followButton.backgroundColor = .black
        followButton.titleLabel!.font = UIFont.boldSystemFont(ofSize: self.h1FontSize)
        followButton.setTitleColor(.white, for: .normal)
        followButton.layer.cornerRadius = 7.5
        followButton.addTarget(self, action: #selector(followButtonTapped), for: .touchUpInside)
        
        contentView.addSubview(followButton)
        followButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            followButton.widthAnchor.constraint(equalToConstant: 60),
            followButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            followButton.heightAnchor.constraint(equalToConstant: 30),
            followButton.topAnchor.constraint(equalTo: profileNameLabel.topAnchor),
        ])
    }
}

extension UserListCollectionViewCell {
    @objc func followButtonTapped() {
        print("follow button tapped")
    }
}
