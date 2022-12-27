//
//  StyleTabViewController.swift
//  KreamWaffleApp
//
//  Created by 이선재 on 2022/12/24.
//

import UIKit

class StyleTabViewController: UIViewController {
    
    private var header = UIView()
    private var codeSegmented = CustomSegmentedControl(buttonTitle: ["인기", "최신", "팔로잉"])
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.navigationItem.titleView = self.header
        addSubviews()
        configureSegmentedControl()
    }
    
    func addSubviews(){
        view.addSubview(header)
        header.addSubview(codeSegmented)
       
    }
    
    
    func configureSegmentedControl(){
        self.header.backgroundColor = .white
        self.header.translatesAutoresizingMaskIntoConstraints = false
        self.header.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        self.header.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 50).isActive = true
        self.header.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        self.header.heightAnchor.constraint(equalToConstant: 40).isActive = true
                                    
        self.codeSegmented.backgroundColor = .white
        self.codeSegmented.translatesAutoresizingMaskIntoConstraints = false
        self.codeSegmented.topAnchor.constraint(equalTo: self.header.topAnchor).isActive = true
        self.codeSegmented.centerXAnchor.constraint(equalTo: self.header.centerXAnchor).isActive = true
        self.codeSegmented.widthAnchor.constraint(equalToConstant: 150).isActive = true
        self.codeSegmented.heightAnchor.constraint(equalToConstant: 30).isActive = true
      
        
    }
   
}
