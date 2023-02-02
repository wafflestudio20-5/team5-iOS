//
//  ReplyCell.swift
//  KreamWaffleApp
//
//  Created by 최성혁 on 2023/02/01.
//

import Foundation
import UIKit
import Kingfisher

final class ReplyCell: UICollectionViewCell {
    private let font1: CGFloat = 14;
    private let font2: CGFloat = 13;
    
    private let profileImageView = UIImageView()
    private let profileNameLabel = UILabel()
    private let contentLabel = UILabel()
    let replyButton = ReplyButton()
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setUpLayout()
    }
    
    override func prepareForReuse() {
        self.profileImageView.image = nil
        self.replyButton.replyToProfile = nil
        super.prepareForReuse()
    }
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        addSubviews()
        setUpLayout()
    }
    
    func configure(with reply: Reply) {
        self.profileNameLabel.text = reply.created_by.profile_name
        
        let fullText = "@\(reply.to_profile.profile_name) \(reply.content)"
        let attribtuedString = NSMutableAttributedString(string: fullText)
        let range = (fullText as NSString).range(of: "@\(reply.to_profile.profile_name)")
        attribtuedString.addAttribute(.foregroundColor, value: UIColor.blue, range: range)
        self.contentLabel.attributedText = attribtuedString
        
        contentLabel.sizeToFit()
        self.sizeToFit()
        
        let urlString = reply.created_by.image
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
    
    private func addSubviews() {
        self.addSubview(profileImageView)
        self.addSubview(profileNameLabel)
        self.addSubview(contentLabel)
        self.addSubview(replyButton)
    }
    
    private func setUpLayout() {
        setUpProfileImageView()
        setUpProfileNameLabel()
        setUpContentLabel()
        setUpReplyButton()
    }
    
    private func setUpProfileImageView() {
        
        let imageHeight = UIScreen.main.bounds.height/16
        
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.profileImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 5),
            self.profileImageView.widthAnchor.constraint(equalToConstant: imageHeight),
            self.profileImageView.topAnchor.constraint(equalTo: self.topAnchor),
            self.profileImageView.heightAnchor.constraint(equalToConstant: imageHeight),
        ])
        profileImageView.contentMode = .scaleAspectFit
        profileImageView.layer.cornerRadius = imageHeight/2
        profileImageView.clipsToBounds = true
    }
    
    private func setUpProfileNameLabel() {
        self.profileNameLabel.font = UIFont.boldSystemFont(ofSize: self.font1)
        self.profileNameLabel.textColor = .black
        self.profileNameLabel.numberOfLines = 1
        self.profileNameLabel.textAlignment = .left
        self.profileNameLabel.adjustsFontSizeToFitWidth = false
        
        self.profileNameLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.profileNameLabel.leadingAnchor.constraint(equalTo: self.profileImageView.trailingAnchor, constant: 7),
            self.profileNameLabel.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.5),
            self.profileNameLabel.topAnchor.constraint(equalTo: self.profileImageView.topAnchor),
            self.profileNameLabel.heightAnchor.constraint(equalToConstant: 20),
        ])
    }
    
    private func setUpContentLabel() {
        contentLabel.font = UIFont.systemFont(ofSize: self.font1)
        contentLabel.textColor = .darkGray
        contentLabel.lineBreakStrategy = .hangulWordPriority
        contentLabel.textAlignment = .left
        contentLabel.adjustsFontSizeToFitWidth = false
        contentLabel.numberOfLines = 0
        
        contentLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            contentLabel.leadingAnchor.constraint(equalTo: self.profileImageView.trailingAnchor, constant: 7),
            contentLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -5),
            contentLabel.topAnchor.constraint(equalTo: self.profileNameLabel.bottomAnchor),
            contentLabel.bottomAnchor.constraint(equalTo: self.replyButton.topAnchor)
        ])
    }
    
    private func setUpReplyButton() {
        replyButton.titleLabel!.font = UIFont.systemFont(ofSize: self.font2)
        replyButton.titleLabel!.text = "답글 쓰기"
        replyButton.backgroundColor = .clear
        
        replyButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            replyButton.widthAnchor.constraint(equalToConstant: 30),
            replyButton.leadingAnchor.constraint(equalTo: self.contentLabel.leadingAnchor),
            replyButton.heightAnchor.constraint(equalToConstant: 20),
            replyButton.bottomAnchor.constraint(equalTo: self.bottomAnchor),
        ])
    }
}
