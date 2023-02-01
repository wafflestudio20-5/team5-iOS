//
//  ProfileViewController.swift
//  KreamWaffleApp
//
//  Created by grace kim  on 2023/01/02.
//
import UIKit

class MyShoppingViewController: UIViewController {
    private let userInfoVM: UserInfoViewModel
    
    init(userInfoVM: UserInfoViewModel) {
        self.userInfoVM = userInfoVM
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var sampleData1 = subviewData(total_title: "구매 내역", set_1: titleNumberSet(title: "전체", number: 0), set_2: titleNumberSet(title: "입찰 중", number: 0), set_3: titleNumberSet(title: "진행 중", number: 0), set_4: titleNumberSet(title: "종료", number: 0))
    
    var sampleData2 = subviewData(total_title: "판매 내역", set_1: titleNumberSet(title: "전체", number: 0), set_2: titleNumberSet(title: "입찰 중", number: 0), set_3: titleNumberSet(title: "진행 중", number: 0), set_4: titleNumberSet(title: "종료", number: 0))
    
    var subView1 : ProfileSubview?
    var subView2 : ProfileSubview?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.subView1 = ProfileSubview(subviewData: sampleData1)
        self.subView2 = ProfileSubview(subviewData: sampleData2)
        self.view.backgroundColor = .white
        self.view.addSubview(subView1!)
        self.view.addSubview(subView2!)
        self.subView1?.translatesAutoresizingMaskIntoConstraints = false
        self.subView1?.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20).isActive = true
        self.subView1?.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20).isActive = true
        self.subView1?.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        self.subView1?.heightAnchor.constraint(equalToConstant: 80).isActive = true
        self.subView1?.backgroundColor = colors.lightGray
       
        
        self.subView2?.translatesAutoresizingMaskIntoConstraints = false
        self.subView2?.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20).isActive = true
        self.subView2?.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20).isActive = true
        self.subView2?.topAnchor.constraint(equalTo: self.subView1!.bottomAnchor, constant: self.view.frame.height/64).isActive = true
        self.subView2?.heightAnchor.constraint(equalToConstant: 80).isActive = true
        self.subView2?.backgroundColor = colors.lightGray
       
    }
    
}
