//
//  MyProfileViewController.swift
//  KreamWaffleApp
//
//  Created by grace kim  on 2023/01/10.
//

import UIKit
import AVFoundation
import AVKit
import Photos
import YPImagePicker

class MyProfileViewController: UIViewController, YPImagePickerDelegate {
    
    
    func imagePickerHasNoItemsInLibrary(_ picker: YPImagePicker) {
        //
    }
    
    func shouldAddToSelection(indexPath: IndexPath, numSelections: Int) -> Bool {
        return true
    }
    var selectedItems = [YPMediaItem]()
    
    let followerBar = MyTabSharedUIStackVIew(title1: "0", subtitle1: "게시물", title2: "2", subtitle2: "팔로워", title3: "0", subtitle3: "팔로잉", setCount: 3)
    let noPostView = UIStackView()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        addSubviews()
        setUpSubviews()
}
    
    func addSubviews(){
        self.view.addSubview(followerBar)
        self.view.addSubview(noPostView)
    }
    
    func setUpSubviews(){
        self.followerBar.translatesAutoresizingMaskIntoConstraints = false
        self.followerBar.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0).isActive = true
        self.followerBar.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0).isActive = true
        self.followerBar.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        self.followerBar.heightAnchor.constraint(equalToConstant: self.view.frame.height/16).isActive = true
       
        setupNoPostView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //adding bottom border to follower bar
        self.followerBar.layer.addBorder([.bottom], color: colors.lightGray, width: 1.0)
    }
    
    
    func setupNoPostView(){
        let cameraImage = UIImage(named: "camera")
        cameraImage?.withTintColor(colors.lightGray)
        let resizedImage = cameraImage?.resize(targetSize: CGSize(width: 50, height: 50))
        let cameraImageView = UIImageView(image: resizedImage)
        
        let profileLabel = UILabel()
        profileLabel.text = "프로필"
        profileLabel.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        profileLabel.textColor = .black
        
        let detailLabel = UILabel()
        detailLabel.text = "사진을 공유하면 내 프로필에 표시됩니다."
        detailLabel.font = UIFont.systemFont(ofSize: 13, weight: .medium)
        detailLabel.textColor = .systemGray
        
        let addPhotoButton = AutoAddPaddingButtton()
        addPhotoButton.setTitle("첫 사진 공유", for: .normal)
        addPhotoButton.setTitleColor(.darkGray, for: .normal)
        addPhotoButton.titleLabel?.font = UIFont.systemFont(ofSize: 13, weight: .medium)
        addPhotoButton.layer.borderColor = UIColor.darkGray.cgColor
        addPhotoButton.layer.borderWidth = 1
        addPhotoButton.layer.cornerRadius = 10
        addPhotoButton.addTarget(self, action: #selector(cameraButtonTapped), for: .touchUpInside)
        
        self.noPostView.addArrangedSubviews([cameraImageView, profileLabel, detailLabel, addPhotoButton])
        noPostView.axis = .vertical
        noPostView.distribution = .equalSpacing
        noPostView.spacing = 10
        noPostView.alignment = .center
        noPostView.translatesAutoresizingMaskIntoConstraints = false
        noPostView.topAnchor.constraint(equalTo: self.followerBar.bottomAnchor, constant: 50).isActive = true
        noPostView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
    }
    
    lazy var selectedImageV : UIImageView = {
        let imageView = UIImageView(frame: CGRect(x: 0,
                                                  y: 0,
                                                  width: UIScreen.main.bounds.width,
                                                  height: UIScreen.main.bounds.height * 0.45))
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    @objc func cameraButtonTapped(){
        print("camera button tapped")
    }
}
