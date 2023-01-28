//
//  SubEditProfileViewController.swift
//  KreamWaffleApp
//
//  Created by grace kim  on 2023/01/29.
//

import UIKit

enum editCase {
    case profileName
    case userName
    case introduction
}

class SubEditProfileViewController: UIViewController, UINavigationBarDelegate {
    
    var myProfile : Profile
    var editCase : editCase
    
    var navBarTitle : String?
    var detail: String?
    var textfieldTitle: String?
    var currentText : String?
    
    var detailLabel = UILabel()
    var textfieldTitleLabel = UILabel()
    var textfield = UITextField()
    var line = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        mapData()
        addNavigationBar()
        setupSubviews()
    }
    
    private func addNavigationBar() {
        let height: CGFloat = 75
        var statusBarHeight: CGFloat = 0
        if #available(iOS 13.0, *) {
            statusBarHeight = view.window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
        } else {
            statusBarHeight = UIApplication.shared.statusBarFrame.height
        }
        let navbar = UINavigationBar(frame: CGRect(x: 0, y: statusBarHeight, width: UIScreen.main.bounds.width, height: height))
        view.addSubview(navbar)
        navbar.backgroundColor = UIColor.clear
        navbar.delegate = self as UINavigationBarDelegate

        let navItem = UINavigationItem()
        navItem.title = self.navBarTitle ?? "수정"
        navItem.rightBarButtonItem = UIBarButtonItem(title: "취소", style: .plain, target: self, action: #selector(tappedCancel))

        navbar.items = [navItem]
        self.view?.frame = CGRect(x: 0, y: height, width: UIScreen.main.bounds.width, height: (UIScreen.main.bounds.height - height))
    }
    
    @objc
    func tappedCancel(){
        self.dismiss(animated: true)
    }
    
    func mapData(){
        switch (self.editCase){
        case .profileName:
            self.navBarTitle = "프로필 이름 변경"
            self.detail = "나만의 프로필 이름으로 변경하세요. 변경 후 30일이 지나야 다시 변경 가능하므로 신중히 변경해주세요."
            self.textfieldTitle = "프로필 이름"
            self.currentText = self.myProfile.profile_name
        case .userName:
            self.navBarTitle = "이름 변경"
            self.detail = nil
            self.textfieldTitle = "이름"
            self.currentText = self.myProfile.user_name
        case .introduction:
            self.navBarTitle = "소개 변경"
            self.detail = nil
            self.textfieldTitle = "소개"
            self.currentText = self.myProfile.introduction
        }
    }
    
    init(myProfile: Profile, editCase: editCase){
        self.myProfile = myProfile
        self.editCase = editCase
        super.init(nibName: nil, bundle: nil)
    }
    
    func setupSubviews(){
        self.title = self.navBarTitle
        self.view.addSubview(detailLabel)
        self.view.addSubview(textfieldTitleLabel)
        self.view.addSubview(textfield)
       
        
        self.detailLabel.text = self.detail
        self.detailLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.detailLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 10),
            self.detailLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -10),
            self.detailLabel.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 85)
        ])
        
        self.textfieldTitleLabel.text = self.textfieldTitle
        self.textfieldTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.textfieldTitleLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 10),
            self.textfieldTitleLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -10),
            self.textfieldTitleLabel.topAnchor.constraint(equalTo: self.detailLabel.bottomAnchor, constant: self.view.frame.height/32)
        ])
        
        self.textfield.text = self.currentText
        self.textfield.backgroundColor = .clear
        self.textfield.textColor = .black
        self.textfield.setLeftPaddingPoints(10)
        self.textfield.setRightPaddingPoints(10)
        self.textfield.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.textfield.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 10),
            self.textfield.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -10),
            self.textfield.topAnchor.constraint(equalTo: self.textfieldTitleLabel.bottomAnchor, constant: 10)
        ])
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
