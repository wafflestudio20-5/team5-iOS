//
//  EditProfileViewController.swift
//  KreamWaffleApp
//
//  Created by grace kim  on 2023/01/27.
//

import UIKit
import RxSwift
import RxRelay
import PhotosUI

class EditProfileViewController: UIViewController, UITableViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var editDic : BehaviorRelay<[editCase]> = BehaviorRelay(value: [editCase.profileName, editCase.userName, editCase.introduction])
    var temDic : [editCase] = []
    
    var disposeBag = DisposeBag()

    var viewModel : UserProfileViewModel
    var editTable = UITableView()
    
    var bio : String?
    
    lazy var profileButton : UIButton  = {
        let button = UIButton()
        let editLabel = UILabel()
        button.setImage(UIImage(named: viewModel.userProfile.image), for: .normal)
        editLabel.backgroundColor = .systemGray
        editLabel.text = "편집"
        editLabel.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        editLabel.textAlignment = .center
        editLabel.textColor = .white
        editLabel.translatesAutoresizingMaskIntoConstraints = false
        button.addSubview(editLabel)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(button)
        NSLayoutConstraint.activate([
            editLabel.leadingAnchor.constraint(equalTo: button.leadingAnchor),
            editLabel.trailingAnchor.constraint(equalTo: button.trailingAnchor),
            editLabel.bottomAnchor.constraint(equalTo: button.bottomAnchor),
            editLabel.heightAnchor.constraint(equalToConstant: 30),
            
            button.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            button.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 100),
            button.widthAnchor.constraint(equalToConstant: 100),
            button.heightAnchor.constraint(equalToConstant: 100)
        ])
        
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 50
        button.addTarget(self, action: #selector(editProfileImage), for: .touchUpInside)
        return button
    }()
    
    lazy var saveButton : UIButton = {
        let button = UIButton()
        self.view.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            button.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20),
            button.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20),
            button.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -self.view.frame.height/32),
            button.heightAnchor.constraint(equalToConstant: self.view.frame.height/16)
        ])
        button.setTitle("저장", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .light)
        button.backgroundColor = colors.lessLightGray
        button.titleLabel?.textColor = .white
        button.layer.cornerRadius = 10
        button.clipsToBounds = true
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.setUpBackButton()
        self.title = "프로필 관리"
        self.view.addSubviews(self.profileButton, self.editTable)
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
            cell.addData(editCase: element, userProfile: self.viewModel.userProfile, user: nil)
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
    
    init(viewModel: UserProfileViewModel){
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc
    func editProfileImage(){
        let uiImagePickerVC = UIImagePickerController()
        uiImagePickerVC.sourceType = .photoLibrary
        uiImagePickerVC.delegate = self
        self.present(uiImagePickerVC, animated: true, completion: nil)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            //TODO: profile 자체 수정
            self.profileButton.setImage(image, for: .normal)
        }
        dismiss(animated: true, completion: nil)
    }
    
    @objc
    func editCell(){
        //TODO edit case 에 따라 변경되도록 하기
        let subVC = SubEditProfileViewController(myProfile: self.viewModel.userProfile, editCase: .profileName, user: nil, loginVM: nil)
        subVC.modalPresentationStyle = .pageSheet
        self.present(subVC, animated: true)
    }
    


}
