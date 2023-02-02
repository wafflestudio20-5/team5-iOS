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
    
    var viewModel : LoginViewModel
    
    var editDic : BehaviorRelay<[editCase]> = BehaviorRelay(value: [editCase.email, editCase.password, editCase.shoeSize])
    var temDic : [editCase] = []
    
    var disposeBag = DisposeBag()

    var editTable = UITableView()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "로그인 정보"
        self.setUpBackButton()
        self.navigationItem.backButtonDisplayMode = .minimal
        self.view.backgroundColor = .white
        self.view.addSubview(editTable)
        self.setupTable()
    
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
            cell.addData(editCase: element, userProfile: nil, user: viewModel.UserUseCase.user) //TODO: edit so that it gets user from view model
            if (element != .email && element != .shoeSize){
                cell.editButton.rx
                    .tap
                    .bind {
                        let subVC = SubEditProfileViewController(myProfile: nil, editCase: element, user: viewModel.UserUseCase.user!, loginVM: self.viewModel)
                        subVC.bindLoginVM()
                        subVC.modalPresentationStyle = .pageSheet
                        self.present(subVC, animated: true)
                    }
            }else if (element == .email || element == .shoeSize){
                cell.removeButton()
            }else if (element == .shoeSize){
                cell.editButton.rx
                    .tap
                    .bind {
                        let vc = ShoeSizeSelectionViewController(viewModel: nil)
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

    init(viewModel: LoginViewModel){
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
