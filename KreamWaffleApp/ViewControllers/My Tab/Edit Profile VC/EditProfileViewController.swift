//
//  EditProfileViewController.swift
//  KreamWaffleApp
//
//  Created by grace kim  on 2023/01/27.
//

import UIKit

class EditProfileViewController: UIViewController {
    
    //임시 profile data --> view model 로 맵핑해주는걸로 고치기
    let data = Profile(user_id: 1, user_name: "gracekim027", profile_name: "feifh9", introduction: "", image: "sample", num_followers: 0, num_followings: 0, following: "true")
    

    var viewModel : UserInfoViewModel?
    
    var profileImage : UIImage?
    var profileName : String?
    var userName : String?
    var bio : String?
    
    lazy var profileButton : UIButton  = {
        let button = UIButton()
        button.setImage(profileImage, for: .normal)
        button.frame = CGRect(x: 160, y: 100, width: 50, height: 50)
        button.layer.cornerRadius = 0.5 * button.bounds.size.width
        button.clipsToBounds = true
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.borderWidth = 2
        button.addTarget(self, action: #selector(editProfileImage), for: .touchUpInside)
        return button
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.setUpBackButton()
        self.title = "프로필 관리"
        self.view.addSubview(self.profileButton)
        self.profileButton.translatesAutoresizingMaskIntoConstraints = false
        self.profileButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        self.profileButton.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 100).isActive = true
    }
    
    init(viewModel: UserInfoViewModel){
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc
    func editProfileImage(){
        let subVC = SubEditProfileViewController(myProfile: self.data, editCase: .profileName)
        subVC.modalPresentationStyle = .pageSheet
        self.present(subVC, animated: true)
    }
    


}
