//
//  SettingsViewController.swift
//  KreamWaffleApp
//
//  Created by grace kim  on 2023/01/27.
//

import UIKit
import RxRelay
import RxSwift

class SettingsViewController: UIViewController, UIScrollViewDelegate, UISheetPresentationControllerDelegate {
    
    //Title Label 로그인 정보 라벨
    //Login 정보 관련 테이블뷰
    
    //로그아웃
    //divider_1
    //회원탈퇴
    //divider_2
    
    var viewModel : EditAccountViewModel?
    let disposeBag = DisposeBag()
    
    var logoutButton = UIButton()
    var divider_1 = UILabel()
    var divider_2 = UILabel()
    
    var editDic : BehaviorRelay<[editCase]> = BehaviorRelay(value: [editCase.email, editCase.password, editCase.shoeSize])
    var temDic : [editCase] = []
    var editTable = UITableView()
    var titleLabel = UILabel()
    var deleteUserButton = UIButton()
    var underLine = UILabel()
    
    init(viewModel: EditAccountViewModel){
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.setUpBackButton()
        self.navigationItem.backButtonDisplayMode = .minimal
        
        self.title = "설정"
        self.view.addSubview(titleLabel)
        self.view.addSubview(editTable)
        
        self.view.addSubview(logoutButton)
        self.view.addSubview(divider_1)
        self.view.addSubview(deleteUserButton)
        self.view.addSubview(divider_2)

        setupTitleLabel()
        setupTable()
        setupLogoutButton()
        setupDeleteAccountButton()
    }
    
    func setupTitleLabel(){
        self.titleLabel.attributedText = NSAttributedString(string: "로그인 정보", attributes: [NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17, weight: .bold)])
        self.titleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.titleLabel.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 100).isActive = true
        self.titleLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20).isActive = true
    }
    
    
    func setupTable(){
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
            cell.addData(editCase: element, userProfile: nil, user: viewModel?.user)
            cell.selectionStyle = .none
            if (element == .password){
                //=========for changing password============
                
                //TODO: change this!
                self.viewModel?.pwTextRelay.subscribe { pw in
                   //get pw's count and make length of *
                    let str = String(repeating: "*", count: pw.element?.count ?? 8)
                    cell.currentTextLabel.text = str
                }
                .disposed(by: disposeBag)
                
                cell.editButton.rx
                    .tap
                    .bind {
                        let subVC = SubEditProfileViewController(myProfile: nil, editCase: element, user: self.viewModel?.user, viewModel: self.viewModel, profileViewModel: nil)
                        subVC.modalPresentationStyle = .pageSheet
                        self.present(subVC, animated: true)
                    }
                    .disposed(by: disposeBag)
            }else if (element == .email){
                
                
                //nothing to change for email
                cell.removeButton()
                
                
            }else if (element == .shoeSize){
                
                //====size relay 에 바인딩하고 shoe select tap 을 보여줌===========
                
                self.viewModel?.shoeSizeRelay.subscribe { size in
                    if (size.element != 0){
                        cell.currentTextLabel.text = String(size.element ?? 0)
                    }else{
                        cell.currentTextLabel.text = "사이즈를 선택하세요."
                    }
                }.disposed(by: disposeBag)
               
                cell.editButton.rx
                    .tap
                    .bind {
                        let vc = ShoeSizeSelectionViewController(viewModel: nil, loginVM: self.viewModel)
                        vc.modalPresentationStyle = .pageSheet
                        if let sheet = vc.sheetPresentationController {
                            sheet.detents = [.medium()]
                            sheet.delegate = self
                            sheet.prefersGrabberVisible = true
                        }
                        self.present(vc, animated: true, completion: nil)
                    }
                    .disposed(by: disposeBag)
            }
        }
                  .disposed(by: disposeBag)
        
        self.editTable.translatesAutoresizingMaskIntoConstraints = false
        self.editTable.backgroundColor = .clear
        NSLayoutConstraint.activate([
            self.editTable.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.editTable.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            self.editTable.topAnchor.constraint(equalTo: self.titleLabel.bottomAnchor, constant: 30),
            self.editTable.heightAnchor.constraint(greaterThanOrEqualToConstant: 300)
        ])
    }
    
    func setupLogoutButton(){
        self.logoutButton.setTitle("로그아웃", for: .normal)
        self.logoutButton.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.left
        self.logoutButton.contentVerticalAlignment = UIControl.ContentVerticalAlignment.top
        self.logoutButton.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        self.logoutButton.backgroundColor = .white
        self.logoutButton.setTitleColor(colors.errorRed, for: .normal)
        self.logoutButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.logoutButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20),
            self.logoutButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20),
            self.logoutButton.topAnchor.constraint(equalTo: self.editTable.bottomAnchor, constant: 70)
        ])
        self.logoutButton.addTarget(self, action: #selector(didTapLogout), for: .touchUpInside)
        
        self.divider_1.backgroundColor = colors.lessLightGray
        self.divider_1.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.divider_1.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20),
            self.divider_1.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20),
            self.divider_1.heightAnchor.constraint(equalToConstant: 1),
            self.divider_1.topAnchor.constraint(equalTo: self.logoutButton.bottomAnchor, constant: 10)
        ])
    }
    
    @objc
    func didTapLogout(){
        self.viewModel?.logout()
        self.navigationController?.popViewController(animated: false)
    }
    
    func setupDeleteAccountButton(){
        let deleteAccountText = NSAttributedString(string: "회원 탈퇴", attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemGray, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15, weight: .regular)])
        self.deleteUserButton.setAttributedTitle(deleteAccountText, for: .normal)
        self.deleteUserButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.deleteUserButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20),
            self.deleteUserButton.topAnchor.constraint(equalTo: self.divider_1.bottomAnchor, constant: 20)
        ])
        self.deleteUserButton.addTarget(self, action: #selector(tapDeleteAccount), for: .touchUpInside)
       
        self.divider_2.backgroundColor = colors.lessLightGray
        self.divider_2.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.divider_2.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20),
            self.divider_2.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20),
            self.divider_2.heightAnchor.constraint(equalToConstant: 1),
            self.divider_2.topAnchor.constraint(equalTo: self.deleteUserButton.bottomAnchor, constant: 10)
        ])
    }
    
    @objc func tapDeleteAccount(){
        let alert = UIAlertController(title: "", message: "회원 탈퇴에 동의하십니까?", preferredStyle: UIAlertController.Style.alert)
        let noAction = UIAlertAction(title: "아니요", style: .default)
        let okAction = UIAlertAction(title: "네", style: .default) { _ in
            self.viewModel?.deleteUser()
            self.viewModel?.logout()
        }
        alert.addAction(okAction)
        alert.addAction(noAction)
        self.present(alert, animated: true, completion: nil)
    }
}
