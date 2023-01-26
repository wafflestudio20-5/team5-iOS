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
    var addPostViewModel : AddPostViewModel?
    let imageView = UIImageView()
    let deleteButton = UIButton()
    
    override init(frame:CGRect){
        super.init(frame: .zero)
        self.contentView.addSubview(imageView)
        self.imageView.layer.masksToBounds = true
        configureDesign()
    }
    
    func setImage(image: UIImage, addPostViewModel: AddPostViewModel){
        self.imageView.image = image
        self.addPostViewModel = addPostViewModel
    }
    
    override var reuseIdentifier: String {
        return "PostPhotoCollectionViewCell"
    }
    
    func configureDesign(){
        self.imageView.layer.cornerRadius = 10
        self.imageView.translatesAutoresizingMaskIntoConstraints = false
        self.imageView.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor).isActive = true
        self.imageView.topAnchor.constraint(equalTo: self.contentView.topAnchor).isActive = true
        self.imageView.widthAnchor.constraint(equalToConstant: 60).isActive = true
        self.imageView.heightAnchor.constraint(equalToConstant: 60).isActive = true
        self.imageView.contentMode = .scaleAspectFit
        
        self.imageView.addSubview(deleteButton)
        let xImage = UIImage(systemName: "x.circle.fill")
        deleteButton.setImage(xImage, for: .normal)
        deleteButton.setImageTintColor(.lightGray)
        deleteButton.translatesAutoresizingMaskIntoConstraints = false
        deleteButton.topAnchor.constraint(equalTo: self.imageView.topAnchor, constant: 5).isActive = true
        deleteButton.trailingAnchor.constraint(equalTo: self.imageView.trailingAnchor, constant: -5).isActive = true
        deleteButton.widthAnchor.constraint(equalToConstant: 20).isActive = true
        deleteButton.heightAnchor.constraint(equalToConstant: 20).isActive = true
        deleteButton.rx.tap
            .bind{
                print("tapped delete button")
            }
    }
    
    @objc func tappedDelete(){
        self.addPostViewModel!.removePhoto(at: self.tag)
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
