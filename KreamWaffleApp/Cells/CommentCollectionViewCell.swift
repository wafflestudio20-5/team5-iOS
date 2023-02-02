//
//  CommentHeader.swift
//  KreamWaffleApp
//
//  Created by 최성혁 on 2023/02/01.
//

import Foundation
import UIKit
import Kingfisher

final class CommentCollectionViewCell: UICollectionViewCell {
    private let font1: CGFloat = 14;
    private let font2: CGFloat = 13;
    
    private let profileImageView = UIImageView()
    private let profileNameLabel = UILabel()
    private let contentLabel = UILabel()
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setUpLayout()
    }
    
    override func prepareForReuse() {
        self.profileImageView.image = nil
        super.prepareForReuse()
    }
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        addSubviews()
        setUpLayout()
    }
    
    func configure(with comment: Comment) {
        self.profileNameLabel.text = comment.created_by.user_name
        self.contentLabel.text = comment.content
        
        contentLabel.sizeToFit()
        self.sizeToFit()
        
        let urlString = comment.created_by.image
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
    }
    
    private func setUpLayout() {
        setUpProfileImageView()
        setUpProfileNameLabel()
        setUpContentLabel()
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
            contentLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
    
}
