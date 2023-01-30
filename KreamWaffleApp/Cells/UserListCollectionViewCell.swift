//
//  UserListCollectionViewCell.swift
//  KreamWaffleApp
//
//  Created by 최성혁 on 2023/01/19.
//

import Foundation
import UIKit
import Kingfisher
import RxCocoa
import RxSwift


class UserListCollectionViewCell: UICollectionViewCell {
    let profileImageWidth: CGFloat = 90
    let h1FontSize: CGFloat = 14 // profileNameLabel
    let h2FontSize: CGFloat = 13 // userNameLabel
    let mainFontColor: UIColor = .black
    let subFontColor: UIColor = .darkGray
    
    let profileNameLabel = UILabel()
    let userNameLabel = UILabel()
    let profileImageView = UIImageView()
    let followButton = FollowButton()
    let disposeBag = DisposeBag()
    
    var user_id: Int?
        
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
        self.followButton.configure(following: nestedProfile.following)
        
        self.user_id = nestedProfile.user_id
        self.profileNameLabel.text = nestedProfile.profile_name
        self.userNameLabel.text = nestedProfile.user_name
        
        let urlString = nestedProfile.image
        guard let url = URL.init(string: urlString) else {
            self.profileImageView.image = UIImage(systemName: "person")
            return
        }
        let resource = ImageResource(downloadURL: url)

        KingfisherManager.shared.retrieveImage(with: resource, options: nil, progressBlock: nil) { result in
            switch result {
            case .success(let value):
                self.profileImageView.image = value.image
            case .failure(_):
                self.profileImageView.image = UIImage(systemName: "person")
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
        followButton.titleLabel!.font = UIFont.boldSystemFont(ofSize: self.h1FontSize)
        followButton.layer.cornerRadius = 7.5
        
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
