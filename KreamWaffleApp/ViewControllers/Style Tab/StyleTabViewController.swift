//
//  StyleTabViewController.swift
//  KreamWaffleApp
//
//  Created by 이선재 on 2022/12/24.
//

import UIKit

class StyleTabViewController: UIViewController {
    
    private var header = UIView()
    private var codeSegmented = CustomSegmentedControl(buttonTitle: ["최신"])
    private var searchButton = UIButton()
    private var cameraButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.navigationItem.titleView = self.header
        addSubviews()
        configureHeader()
    }
    
    func addSubviews(){
        view.addSubview(header)
        header.addSubview(codeSegmented)
        header.addSubview(searchButton)
        header.addSubview(cameraButton)
    }
    
    func configureHeader(){
        configureSegmentedControl()
        
        //configure search button
        let searchImage = UIImage(systemName: "magnifyingglass")
        let tintedSearchImage = searchImage?.withRenderingMode(.alwaysTemplate)
        self.searchButton.setImage(tintedSearchImage, for: .normal)
        self.searchButton.tintColor = .black
        self.searchButton.translatesAutoresizingMaskIntoConstraints = false
        self.searchButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 10).isActive = true
        self.searchButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        self.searchButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        self.searchButton.centerYAnchor.constraint(equalTo: self.header.centerYAnchor).isActive = true
        
        //configure camera button
        let cameraImage = UIImage(systemName: "camera.circle.fill")
        let tintedcameraImage = cameraImage?.withRenderingMode(.alwaysTemplate)
        self.cameraButton.setImage(tintedcameraImage, for: .normal)
        self.cameraButton.tintColor = .lightGray
        self.cameraButton.translatesAutoresizingMaskIntoConstraints = false
        self.cameraButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -10).isActive = true
        self.cameraButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        self.cameraButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        self.cameraButton.centerYAnchor.constraint(equalTo: self.header.centerYAnchor).isActive = true
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
        self.codeSegmented.centerXAnchor.constraint(equalTo: self.header.centerXAnchor).isActive = true
        self.codeSegmented.centerYAnchor.constraint(equalTo: self.header.centerYAnchor).isActive = true
        self.codeSegmented.widthAnchor.constraint(equalToConstant: 50).isActive = true
        self.codeSegmented.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
    }
   
}
