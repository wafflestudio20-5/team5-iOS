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
            cell.addData(editCase: element, userProfile: nil, user: viewModel.user)
            if (element == .password){
                //=========for changing password============
                self.viewModel.pwTextRelay.subscribe { pw in
                   //get pw's count and make length of *
                    let str = String(repeating: "*", count: pw.element?.count ?? 8)
                    cell.currentTextLabel.text = str
                }
                
                cell.editButton.rx
                    .tap
                    .bind {
                        let subVC = SubEditProfileViewController(myProfile: nil, editCase: element, user: viewModel.user, viewModel: self.viewModel)
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

    init(viewModel: EditAccountViewModel){
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
