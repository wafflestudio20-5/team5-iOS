//
//  MyProfileViewController.swift
//  KreamWaffleApp
//
//  Created by grace kim  on 2023/01/10.
//

import UIKit

class MyProfileViewController: UIViewController {
    
    let followerBar = MyTabSharedUIStackVIew(title1: "1", subtitle1: "게시물", title2: nil, subtitle2: nil, title3: nil, subtitle3: nil, setCount: 1)
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        addSubviews()
        setUpSubviews()
}
    
    func addSubviews(){
        self.view.addSubview(followerBar)
    }
    
    func setUpSubviews(){
        self.followerBar.translatesAutoresizingMaskIntoConstraints = false
        self.followerBar.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        self.followerBar.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        self.followerBar.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        self.followerBar.heightAnchor.constraint(equalToConstant: 100).isActive = true
    }
    
    func setupNoPostView(){
        
    }
}
