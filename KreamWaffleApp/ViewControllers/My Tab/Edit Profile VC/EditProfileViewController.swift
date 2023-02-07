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
    
    var profileImageView = UIImageView()
    
    var editImage = false
    var editProfileName = false
    var editUserName = false
    var editBio = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.bindViews()
        self.view.backgroundColor = .white
        self.title = "프로필 관리"
        self.setUpBackButton()
        self.setupProfileButton()
        self.view.addSubviews(self.profileImageView, self.editTable)
        self.inputTableView()
        self.bindViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.viewModel.requestUserProfile{
            print("[Log] EditProfileVC: Cannot update profile.") //토큰 체크를 해야할듯
        }
    }
    
    
    func bindViews() {
        self.viewModel.userProfileDataSource.subscribe(onNext: {[weak self] profile in
            //프로필 이미지가 있다면 설정
            if let url = URL.init(string: profile.image) {
                let resource = ImageResource(downloadURL: url)
                KingfisherManager.shared.retrieveImage(with: resource, options: nil, progressBlock: nil) { result in
                    switch result {
                    case .success(let value):
                        self?.profileImageView.image = value.image
                    case .failure(_):
                        if let image = UserDefaults.standard.loadProfileImage() {
                            print("[Log] My tab: 캐시에서 이미지 불러욤.")
                            self?.profileImageView.image = image
                        }else{
                            //캐시도 없다면 기본으로 설정
                            self?.profileImageView.image = UIImage(systemName: "person.crop.circle.fill")?.withRenderingMode(.alwaysTemplate)
                            //그게 아니라면 여기서 난 문제
                            self?.profileImageView.tintColor = .orange
                        }
                    }
                }
            }else{
                if let image = UserDefaults.standard.loadProfileImage() {
                    print("[Log] My tab: 캐시에서 이미지 불러욤.")
                    self?.profileImageView.image = image
                }else{
                    //캐시도 없다면 기본으로 설정
                    self?.profileImageView.image = UIImage(systemName: "person.crop.circle.fill")?.withRenderingMode(.alwaysTemplate)
                    //그게 아니라면 여기서 난 문제
                    self?.profileImageView.tintColor = .orange
                }
            }
            }).disposed(by: bag)
    }
                                                       
    
    func setupProfileButton(){
        
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(profileImageView)
        NSLayoutConstraint.activate([
            profileImageView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            profileImageView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 100),
            profileImageView.widthAnchor.constraint(equalToConstant: 100),
            profileImageView.heightAnchor.constraint(equalToConstant: 100)])
        
        profileImageView.clipsToBounds = true
        profileImageView.layer.cornerRadius = 50
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(editProfileImage))
        profileImageView.isUserInteractionEnabled = true
        profileImageView.addGestureRecognizer(tapGestureRecognizer)
        
        let editLabel = UILabel()
        editLabel.backgroundColor = .systemGray
        editLabel.text = "편집"
        editLabel.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        editLabel.textAlignment = .center
        editLabel.textColor = .white
        editLabel.translatesAutoresizingMaskIntoConstraints = false
        profileImageView.addSubview(editLabel)
        NSLayoutConstraint.activate([
            editLabel.leadingAnchor.constraint(equalTo: profileImageView.leadingAnchor),
            editLabel.trailingAnchor.constraint(equalTo: profileImageView.trailingAnchor),
            editLabel.bottomAnchor.constraint(equalTo: profileImageView.bottomAnchor),
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
            self.editTable.topAnchor.constraint(equalTo: self.profileImageView.bottomAnchor, constant: 50),
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
            UserDefaults.standard.saveProfileImage(image: image)
            self.viewModel.editProfileImage(newImage: image)
            self.profileImageView.image = image
            self.viewModel.imageRelay.accept(image)
        }
        
        dismiss(animated: true, completion: nil)
        self.showLoadingView()
    }
    
    
    
    func showLoadingView(){
        let loadingVC = LoadingViewController()

        // Animate loadingVC over the existing views on screen
        loadingVC.modalPresentationStyle = .overCurrentContext

        // Animate loadingVC with a fade in animation
        loadingVC.modalTransitionStyle = .crossDissolve
            
        self.present(loadingVC, animated: true, completion: nil)
            
        let seconds = 3.0
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds) { [self] in
            loadingVC.dismiss(animated: true)
            self.dismiss(animated: true)
        }
    }

}
