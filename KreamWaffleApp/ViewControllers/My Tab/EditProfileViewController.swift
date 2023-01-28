//
//  EditProfileViewController.swift
//  KreamWaffleApp
//
//  Created by grace kim  on 2023/01/27.
//

import UIKit

class EditProfileViewController: UIViewController {

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
        button.addTarget(self, action: #selector(editProfileImage), for: .touchUpInside)
        return button
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.setUpBackButton()
        self.title = "프로필 관리"
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
        
    }
    


}
