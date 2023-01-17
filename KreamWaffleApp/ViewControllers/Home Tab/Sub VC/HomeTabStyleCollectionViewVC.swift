//
//  HomeTabStyleCollectionViewVC.swift
//  KreamWaffleApp
//
//  Created by 이선재 on 2023/01/16.
//

import UIKit

class HomeTabStyleCollectionViewVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
//        self.view.backgroundColor = .blue
        setUpHeaders()

        // Do any additional setup after loading the view.
    }
    
    private func setUpHeaders() {
        // Main Header "Just Dropped"
        let mainHeaderLabel = UILabel()
        mainHeaderLabel.text = "Style Picks"
        mainHeaderLabel.font = UIFont.boldSystemFont(ofSize: 18)
        self.view.addSubview(mainHeaderLabel)
        mainHeaderLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            mainHeaderLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            mainHeaderLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 10),
            mainHeaderLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -10),
            mainHeaderLabel.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 15),
//            mainHeaderLabel.bottomAnchor.constraint(equalTo: self.view.topAnchor, constant: 60)
        ])
        
//        // Sub Header "발매 상품"
//        let subHeaderLabel = UILabel()
//        subHeaderLabel.text = "발매 상품"
//        subHeaderLabel.font = UIFont.systemFont(ofSize: 18)
//        self.view.addSubview(subHeaderLabel)
//        subHeaderLabel.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate([
//            subHeaderLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
//            subHeaderLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 10),
//            subHeaderLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -10),
//            subHeaderLabel.topAnchor.constraint(equalTo: mainHeaderLabel.bottomAnchor, constant: 0),
////            subHeaderLabel.bottomAnchor.constraint(equalTo: self.view.topAnchor, constant: 100)
//        ])
        
    }
    

}
