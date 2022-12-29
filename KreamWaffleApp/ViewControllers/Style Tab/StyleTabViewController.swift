//
//  StyleTabViewController.swift
//  KreamWaffleApp
//
//  Created by 이선재 on 2022/12/24.
//

import UIKit
import RxSwift
import RxCocoa
import CHTCollectionViewWaterfallLayout

class StyleTabViewController: UIViewController {
    private let viewModel: StyleViewModel
    private let disposeBag = DisposeBag()
    
    private var header = UIView()
    private var codeSegmented = CustomSegmentedControl(buttonTitle: ["최신"])
    private var searchButton = UIButton()
    private var cameraButton = UIButton()
        
    private let collectionView: UICollectionView = {
//        let layout = CHTCollectionViewWaterfallLayout()
//        layout.itemRenderDirection = .leftToRight
//        layout.columnCount = 2
//        layout.minimumColumnSpacing = 5
//        layout.minimumInteritemSpacing = 5
//
//        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: StyleCollectionViewFlowLayout())
        
        collectionView.register(StyleCollectionViewCell.self, forCellWithReuseIdentifier: StyleCollectionViewCell.identifier)
        return collectionView
    }()
    
    init(viewModel: StyleViewModel) {
        self.viewModel = viewModel

        super.init(nibName: nil, bundle: nil)
        collectionView.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.navigationItem.titleView = self.header
        addSubviews()
        configureHeader()
        setUpCollectionView()
        bindCollectionView()
    }
    
    func addSubviews(){
        view.addSubview(header)
        header.addSubview(codeSegmented)
        header.addSubview(searchButton)
        header.addSubview(cameraButton)
    }
    
    func configureHeader(){
        configureSegmentedControl()
        
        //configure search button
        let searchImage = UIImage(systemName: "magnifyingglass")
        let tintedSearchImage = searchImage?.withRenderingMode(.alwaysTemplate)
        self.searchButton.setImage(tintedSearchImage, for: .normal)
        self.searchButton.tintColor = .black
        self.searchButton.translatesAutoresizingMaskIntoConstraints = false
        self.searchButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 10).isActive = true
        self.searchButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        self.searchButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        self.searchButton.centerYAnchor.constraint(equalTo: self.header.centerYAnchor).isActive = true
        
        //configure camera button
        let cameraImage = UIImage(systemName: "camera.circle.fill")
        let tintedcameraImage = cameraImage?.withRenderingMode(.alwaysTemplate)
        self.cameraButton.setImage(tintedcameraImage, for: .normal)
        self.cameraButton.tintColor = .lightGray
        self.cameraButton.translatesAutoresizingMaskIntoConstraints = false
        self.cameraButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -10).isActive = true
        self.cameraButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        self.cameraButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        self.cameraButton.centerYAnchor.constraint(equalTo: self.header.centerYAnchor).isActive = true
    }
    
    
    func configureSegmentedControl(){
        self.header.backgroundColor = .white
        self.header.translatesAutoresizingMaskIntoConstraints = false
        self.header.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        self.header.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 50).isActive = true
        self.header.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        self.header.heightAnchor.constraint(equalToConstant: 40).isActive = true
                                    
        self.codeSegmented.backgroundColor = .white
        self.codeSegmented.translatesAutoresizingMaskIntoConstraints = false
        self.codeSegmented.centerXAnchor.constraint(equalTo: self.header.centerXAnchor).isActive = true
        self.codeSegmented.centerYAnchor.constraint(equalTo: self.header.centerYAnchor).isActive = true
        self.codeSegmented.widthAnchor.constraint(equalToConstant: 50).isActive = true
        self.codeSegmented.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
    }
    
    func setUpCollectionView() {
        view.addSubview(collectionView)

        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.collectionView.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor, constant: 0),
            self.collectionView.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor, constant: 0),
            self.collectionView.topAnchor.constraint(equalTo: self.header.bottomAnchor, constant: 0),
            self.collectionView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: 0),
        ])
    }
    
    func bindCollectionView() {
        collectionView.register(StyleCollectionViewCell.self, forCellWithReuseIdentifier: "StyleCollectionViewCell")
        
        viewModel.styleDataSource
            .bind(to: collectionView.rx.items(cellIdentifier: "StyleCollectionViewCell", cellType: StyleCollectionViewCell.self)) { index, item, cell in
                cell.configure(with: item)
            }
            .disposed(by: disposeBag)

    }
}

extension StyleTabViewController: UICollectionViewDelegate{
    
}
//
//extension StyleTabViewController: CHTCollectionViewDelegateWaterfallLayout {
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//
////        let imageHeight = viewModel.getImageByIndex(index: indexPath.item).size.height
//        let imageHeight = 500
//
//        return CGSize(width: Int(view.frame.size.width) / 2, height: imageHeight+50)
////        return CGSize(width: 400, height: 1000)
//
//    }
//}
