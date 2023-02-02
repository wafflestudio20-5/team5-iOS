//
//
//  ShoeSizeSelectionViewController.swift
//  KreamWaffleApp
//
//  Created by grace kim  on 2023/01/01.
//

import UIKit
import RxSwift
import RxCocoa


//for the half screen modal view
class ShoeSizeSelectionViewController: UIViewController, UIScrollViewDelegate, UICollectionViewDelegateFlowLayout {
    private let bag = DisposeBag()
    let viewModel : SignUpViewModel?
    let loginVM: EditAccountViewModel?
    var sizeView : UICollectionView!
    private var layout = UICollectionViewFlowLayout()
    private var backButton = UIButton()
    private var titleLabel = UILabel()
    
    let shoeSizes = [220, 225, 230, 235, 240, 245, 250, 255, 260, 265, 270, 275, 280, 285, 290, 295, 300]
    
    init(viewModel: SignUpViewModel?, loginVM: EditAccountViewModel?){
        self.viewModel = viewModel
        self.loginVM = loginVM
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(red: 250/255.0, green: 250/255.0, blue: 250/255.0, alpha: 1.0)
        bind()
        self.view.addSubview(titleLabel)
        self.view.addSubview(backButton)
        self.view.addSubview(sizeView)
        configureCollectionView()
    }
    
    
    private func bind(){
        self.sizeView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        self.sizeView.register(ShoeSizeSelectionCollectionViewCell.self, forCellWithReuseIdentifier: "ShoeSizeSelectionCollectionViewCell")
        
        self.sizeView.rx.setDelegate(self)
            .disposed(by: bag)
        
        let sizeObservable = Observable.of(self.shoeSizes)
        sizeObservable
            .observe(on: MainScheduler.instance)
            .bind(to: sizeView.rx.items(cellIdentifier: "ShoeSizeSelectionCollectionViewCell", cellType: ShoeSizeSelectionCollectionViewCell.self))
        { index, int, cell  in
            cell.setInt(size: int)
            //cell.layer.cornerRadius = 5
        }
        .disposed(by: bag)
        
        self.sizeView
            .rx
            .modelSelected(Int.self)
            .subscribe(onNext: { model in
                self.viewModel?.shoeSizeRelay.accept(model)
                self.dismiss(animated: true)
            }).disposed(by: bag)
        
        self.sizeView
            .rx
            .modelSelected(Int.self)
            .subscribe(onNext: { model in
                self.loginVM?.shoeSizeRelay.accept(model)
                self.loginVM?.changeShoeSize()
                self.dismiss(animated: true)
            }).disposed(by: bag)
    }
    
    private func configureCollectionView(){
        titleLabel.text = "사이즈 선택"
        titleLabel.backgroundColor = .white
        titleLabel.textColor = .black
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        self.titleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.titleLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        self.titleLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        self.titleLabel.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        self.titleLabel.heightAnchor.constraint(equalToConstant: self.view.frame.height/16).isActive = true
        
        let blue_x = UIImage(systemName: "xmark")
        let tinted_x = blue_x?.withRenderingMode(.alwaysTemplate)
        self.backButton.setImage(tinted_x, for: .normal)
        self.backButton.tintColor = .black
        self.titleLabel.addSubview(backButton)
        backButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -10).isActive = true
        backButton.centerYAnchor.constraint(equalTo: self.titleLabel.centerYAnchor).isActive = true
        backButton.heightAnchor.constraint(equalToConstant: self.view.frame.height/20).isActive = true
        backButton.widthAnchor.constraint(equalToConstant: self.view.frame.height/20).isActive = true
        backButton.addTarget(self, action: #selector(exitVC), for: .touchUpInside)
    
        layout.scrollDirection = .vertical
        self.sizeView.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
        self.sizeView.showsVerticalScrollIndicator = false
        self.sizeView.backgroundColor = .clear
        self.sizeView.translatesAutoresizingMaskIntoConstraints = false
        self.sizeView.topAnchor.constraint(equalTo: self.titleLabel.bottomAnchor).isActive = true
        self.sizeView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20).isActive = true
        self.sizeView.heightAnchor.constraint(greaterThanOrEqualToConstant: self.view.frame.height / 2).isActive = true
        self.sizeView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20).isActive = true
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            let width = collectionView.bounds.width
            let cellWidth = (width - 30) / 3
        return CGSize(width: cellWidth, height: cellWidth / 2.2)
        }
    
    @objc func exitVC(){
        self.dismiss(animated: true)
    }
}
