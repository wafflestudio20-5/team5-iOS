//
//  LoginSettingsEditViewController.swift
//  KreamWaffleApp
//
//  Created by grace on 2023/02/02.
//

import UIKit
import RxRelay
import RxSwift

class LoginSettingsEditViewController: UIViewController, UIScrollViewDelegate, UISheetPresentationControllerDelegate {
    
    let bag = DisposeBag()
    
    var viewModel : EditAccountViewModel
    
    var editDic : BehaviorRelay<[editCase]> = BehaviorRelay(value: [editCase.email, editCase.password, editCase.shoeSize])
    var temDic : [editCase] = []
    
    var disposeBag = DisposeBag()

    var editTable = UITableView()
    var titleLabel = UILabel()
    var currentTextLabel = UIButton()
    var underLine = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "로그인 정보"
        self.setUpBackButton()
        self.navigationItem.backButtonDisplayMode = .minimal
        self.view.backgroundColor = .white
        self.view.addSubview(editTable)
        self.view.addSubviews(currentTextLabel, underLine)
        self.setupTable()
        self.setupDeleteAccountButton()
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
            cell.addData(editCase: element, userProfile: nil, user: viewModel.user)
            cell.selectionStyle = .none
            if (element == .password){
                //=========for changing password============
                
                //TODO: change this!
                self.viewModel.pwTextRelay.subscribe { pw in
                   //get pw's count and make length of *
                    let str = String(repeating: "*", count: pw.element?.count ?? 8)
                    cell.currentTextLabel.text = str
                }
                
                cell.editButton.rx
                    .tap
                    .bind {
                        let subVC = SubEditProfileViewController(myProfile: nil, editCase: element, user: viewModel.user, viewModel: self.viewModel, profileViewModel: nil)
                        subVC.modalPresentationStyle = .pageSheet
                        self.present(subVC, animated: true)
                    }
            }else if (element == .email){
                
                
                //nothing to change for email
                cell.removeButton()
                
                
            }else if (element == .shoeSize){
                
                //====size relay 에 바인딩하고 shoe select tap 을 보여줌===========
                
                self.viewModel.shoeSizeRelay.subscribe { size in
                    if (size.element != 0){
                        cell.currentTextLabel.text = String(size.element ?? 0)
                    }else{
                        cell.currentTextLabel.text = "사이즈를 선택하세요."
                    }
                }.disposed(by: bag)
               
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
            }
        }
                  .disposed(by: disposeBag)
        
        self.editTable.translatesAutoresizingMaskIntoConstraints = false
        self.editTable.backgroundColor = .clear
        NSLayoutConstraint.activate([
            self.editTable.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.editTable.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            self.editTable.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 80),
            self.editTable.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
    }
    
    func setupDeleteAccountButton(){
        let deleteAccountText = NSAttributedString(string: "회원 탈퇴", attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemGray, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15, weight: .regular)])
        self.currentTextLabel.setAttributedTitle(deleteAccountText, for: .normal)
        self.currentTextLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.currentTextLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20),
            self.currentTextLabel.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -self.view.frame.height/8)
        ])
        self.currentTextLabel.addTarget(self, action: #selector(tapDeleteAccount), for: .touchUpInside)
       
        self.underLine.backgroundColor = UIColor.systemGray
        self.underLine.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.underLine.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20),
            self.underLine.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20),
            self.underLine.heightAnchor.constraint(equalToConstant: 0.7),
            self.underLine.topAnchor.constraint(equalTo: self.currentTextLabel.bottomAnchor, constant: 10)
        ])
    }
    
    @objc func tapDeleteAccount(){
        let alert = UIAlertController(title: "", message: "회원 탈퇴에 동의하십니까?", preferredStyle: UIAlertController.Style.alert)
        let noAction = UIAlertAction(title: "아니요", style: .default)
        let okAction = UIAlertAction(title: "네", style: .default) { _ in
            self.viewModel.deleteUser()
            self.viewModel.logout()
            //self?.navigationController?.popViewController(animated: true)
        }
        alert.addAction(okAction)
        alert.addAction(noAction)
        self.present(alert, animated: true, completion: nil)
    }

    init(viewModel: EditAccountViewModel){
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
