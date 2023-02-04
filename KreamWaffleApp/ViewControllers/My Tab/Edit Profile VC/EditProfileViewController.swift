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
import Kingfisher

class EditProfileViewController: UIViewController, UITableViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var editDic : BehaviorRelay<[editCase]> = BehaviorRelay(value: [editCase.profileName, editCase.userName, editCase.introduction])
    var temDic : [editCase] = []
    
    var disposeBag = DisposeBag()

    var viewModel : UserProfileViewModel
    var editTable = UITableView()
    
    var bio : String?
    
    let bag = DisposeBag()
    
    var profileButton = UIButton()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.title = "프로필 관리"
        self.setUpBackButton()
        self.view.addSubviews(self.profileButton, self.editTable)
        self.bindViews()
        self.inputTableView()
    }
    
    func bindViews() {
        self.viewModel.imageRelay.subscribe{ [weak self] event in
            if let image = event.element {
                self?.setupProfileButton(with: image)
            }
        }
    }
    
    func setupProfileButton(with image: UIImage){
        
        profileButton.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(profileButton)
        NSLayoutConstraint.activate([
            profileButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            profileButton.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 100),
            profileButton.widthAnchor.constraint(equalToConstant: 100),
            profileButton.heightAnchor.constraint(equalToConstant: 100)])
        
        profileButton.layer.masksToBounds = true
        profileButton.layer.cornerRadius = 50
        profileButton.addTarget(self, action: #selector(editProfileImage), for: .touchUpInside)
        profileButton.setImage(image, for: .normal)
        
        let editLabel = UILabel()
        profileButton.contentVerticalAlignment = .fill
        profileButton.contentHorizontalAlignment = .fill

        editLabel.backgroundColor = .systemGray
        editLabel.text = "편집"
        editLabel.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        editLabel.textAlignment = .center
        editLabel.textColor = .white
        editLabel.translatesAutoresizingMaskIntoConstraints = false
        profileButton.addSubview(editLabel)
        NSLayoutConstraint.activate([
            editLabel.leadingAnchor.constraint(equalTo: profileButton.leadingAnchor),
            editLabel.trailingAnchor.constraint(equalTo: profileButton.trailingAnchor),
            editLabel.bottomAnchor.constraint(equalTo: profileButton.bottomAnchor),
            editLabel.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
    
    @objc func tappedCancel(){
        self.dismiss(animated: true)
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
            
            //binding current value label to newest
            self.viewModel.tapRelay.asObservable()
                .subscribe{ [self] editCase in
                    
                    //Binding to cell's saves buttons, and calling API.
                    if (element == editCase.element){
                    switch (element){
                    case .profileName:
                        cell.currentTextLabel.text = viewModel.profileNameRelay.value
                        self.viewModel.partialEditProfile(newValue: viewModel.profileNameRelay.value, editCase: .profileName)
                    case .userName:
                        cell.currentTextLabel.text = viewModel.userNameRelay.value
                        self.viewModel.partialEditProfile(newValue: viewModel.userNameRelay.value, editCase: .userName)
                    case .introduction:
                        cell.currentTextLabel.text = viewModel.bioRelay.value
                        self.viewModel.partialEditProfile(newValue: viewModel.bioRelay.value, editCase: .introduction)
                    default:
                        print("")
                    }
                }
            }.disposed(by: bag)
            
            
            cell.editButton.rx.tap.bind {
                let subVC = SubEditProfileViewController(myProfile: self.viewModel.userProfile, editCase: element, user:nil, viewModel: nil, profileViewModel: self.viewModel)
                subVC.modalPresentationStyle = .pageSheet
                self.present(subVC, animated: true)
            }.disposed(by: bag)
            cell.selectionStyle = .none
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
            self.viewModel.imageRelay.accept(image)
            self.viewModel.editProfileImage(newImage: image)
        }
        
        dismiss(animated: true, completion: nil)
    }

}
