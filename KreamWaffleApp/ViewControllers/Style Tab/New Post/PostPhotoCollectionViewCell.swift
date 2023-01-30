//
//  PostPhotoCollectionViewCell.swift
//  KreamWaffleApp
//
//  Created by grace kim  on 2023/01/24.
//

import UIKit
import RxCocoa
import RxSwift

class PostPhotoCollectionViewCell: UICollectionViewCell {
    private var addPostViewModel : NewPostViewModel?
    private var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 10
        return imageView
    }()
    
    let deleteButton = UIButton()
    private let disposeBag = DisposeBag()
    
    override init(frame:CGRect){
        super.init(frame: .zero)
        self.contentView.addSubview(imageView)
        self.imageView.layer.masksToBounds = true
        configureDesign()
    }
    
    func setImage(image: UIImage, addPostViewModel: NewPostViewModel){
        self.imageView.image = image
        self.addPostViewModel = addPostViewModel
    }
    
    override var reuseIdentifier: String {
        return "PostPhotoCollectionViewCell"
    }
    
    func configureDesign(){
        self.imageView.translatesAutoresizingMaskIntoConstraints = false
        self.imageView.topAnchor.constraint(equalTo: self.contentView.topAnchor).isActive = true
        self.imageView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor).isActive = true
        self.imageView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor).isActive = true
        self.imageView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor).isActive = true

        self.contentView.addSubview(deleteButton)
        
        let xImage = UIImage(systemName: "x.circle.fill")
        deleteButton.setImage(xImage, for: .normal)
        deleteButton.setImageTintColor(.lightGray)
        deleteButton.translatesAutoresizingMaskIntoConstraints = false
        deleteButton.topAnchor.constraint(equalTo: self.imageView.topAnchor, constant: 5).isActive = true
        deleteButton.trailingAnchor.constraint(equalTo: self.imageView.trailingAnchor, constant: -5).isActive = true
        deleteButton.widthAnchor.constraint(equalToConstant: 20).isActive = true
        deleteButton.heightAnchor.constraint(equalToConstant: 20).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
