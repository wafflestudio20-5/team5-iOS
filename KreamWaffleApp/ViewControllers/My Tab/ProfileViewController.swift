//
//  ProfileViewController.swift
//  KreamWaffleApp
//
//  Created by grace kim  on 2023/01/02.
//
import UIKit

class ProfileViewController: UIViewController {

    var sampleData = subviewData(total_title: "보관 판매 내역", set_1: titleNumberSet(title: "발송요청", number: 0), set_2: titleNumberSet(title: "판매대기", number: 0), set_3: titleNumberSet(title: "판매 중", number: 0), set_4: titleNumberSet(title: "정산완료", number: 0))
    
    var subView1 : ProfileSubview?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.subView1 = ProfileSubview(subviewData: sampleData)
        self.view.backgroundColor = .white
        self.view.addSubview(subView1!)
        self.subView1?.translatesAutoresizingMaskIntoConstraints = false
        self.subView1?.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20).isActive = true
        self.subView1?.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20).isActive = true
        self.subView1?.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 200).isActive = true
        self.subView1?.heightAnchor.constraint(greaterThanOrEqualToConstant: 100).isActive = true
    }
    
}
