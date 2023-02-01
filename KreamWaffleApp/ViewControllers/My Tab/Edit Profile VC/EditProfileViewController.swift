//
//  EditProfileViewController.swift
//  KreamWaffleApp
//
//  Created by grace kim  on 2023/01/27.
//

import UIKit
import RxSwift
import RxRelay

class EditProfileViewController: UIViewController, UITableViewDelegate {
    
    //임시 profile data --> view model 로 맵핑해주는걸로 고치기
    let data = Profile(user_id: 1, user_name: "gracekim027", profile_name: "feifh9", introduction: "", image: "kream", num_followers: 0, num_followings: 0, following: "true")
    
    var editDic : BehaviorRelay<[editCase]> = BehaviorRelay(value: [editCase.profileName, editCase.userName, editCase.introduction])
    var temDic : [editCase] = []
    
    var disposeBag = DisposeBag()

    var viewModel : UserInfoViewModel?
    var editTable = UITableView()
    
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
        self.view.addSubviews(self.profileButton, self.editTable)
        self.profileButton.translatesAutoresizingMaskIntoConstraints = false
        self.profileButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        self.profileButton.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 100).isActive = true
        self.inputTableView()
    }
    
    func inputTableView(){
        self.editTable.separatorStyle = .none
        self.editTable.register(EditProfileTableViewCell.self, forCellReuseIdentifier: "EditProfileTableViewCell")
        self.temDic = self.editDic.value
        self.editTable
            .rx
            .setDelegate(self)
            .disposed(by: disposeBag)
        
        self.editDic.asObservable()
            .bind(to: self.editTable.rx
                .items(cellIdentifier: "EditProfileTableViewCell", cellType: EditProfileTableViewCell.self))
        { [self] index, element, cell in
                //element is editCase
                      cell.addData(editCase: element, userProfile: self.data)
                      cell.editButton.addTarget(self, action: #selector(self.editCell), for: .touchUpInside)
            }
                  .disposed(by: disposeBag)
        
        self.editTable.translatesAutoresizingMaskIntoConstraints = false
        self.editTable.backgroundColor = .clear
        NSLayoutConstraint.activate([
            self.editTable.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.editTable.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            self.editTable.topAnchor.constraint(equalTo: self.profileButton.bottomAnchor, constant: 50),
            self.editTable.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
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
    
    @objc
    func editCell(){
        //TODO edit case 에 따라 변경되도록 하기
        let subVC = SubEditProfileViewController(myProfile: self.data, editCase: .profileName)
        subVC.modalPresentationStyle = .pageSheet
        self.present(subVC, animated: true)
    }
    


}
