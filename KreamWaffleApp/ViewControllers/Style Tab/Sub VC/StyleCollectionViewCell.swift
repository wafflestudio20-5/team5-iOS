//
//  File.swift
//  KreamWaffleApp
//
//  Created by 최성혁 on 2022/12/29.
//

import Foundation
import UIKit
import Kingfisher

final class StyleCollectionViewCell: UICollectionViewCell {
    static let identifier = "StyleCollectionViewCell"
    private let idLabel = UILabel()
    private let contentLabel = UILabel()
    private var thumbnailImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        return imageView
    }()
    private var thumbnailImageSource: String?
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setUpLayout()
    }
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setUpLayout()
    }
    
    private func setUpLayout() {
        contentView.addSubview(thumbnailImageView)
        thumbnailImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.thumbnailImageView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 0),
            self.thumbnailImageView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: 0),
            self.thumbnailImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0),
            self.thumbnailImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -100),
        ])
        
        contentView.addSubview(idLabel)
        idLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.idLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 0),
            self.idLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: 0),
            self.idLabel.topAnchor.constraint(equalTo: thumbnailImageView.bottomAnchor, constant: 0),
            self.idLabel.heightAnchor.constraint(equalToConstant: 50),
        ])
        
        contentView.addSubview(contentLabel)
        contentLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.contentLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 0),
            self.contentLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: 0),
            self.contentLabel.topAnchor.constraint(equalTo: idLabel.bottomAnchor, constant: 0),
            self.contentLabel.heightAnchor.constraint(equalToConstant: 50),
        ])
    }
    
    func configure(with stylePost: StylePost) {
        self.idLabel.text = stylePost.id
        self.contentLabel.text = stylePost.content
        self.thumbnailImageSource = stylePost.imageSources[0]
        
        let roundProcessor = RoundCornerImageProcessor(cornerRadius: 10)
        thumbnailImageView.kf.setImage(with: URL(string: self.thumbnailImageSource!), placeholder: nil, options: [.processor(roundProcessor)])
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        thumbnailImageView.image = nil
    }
}
