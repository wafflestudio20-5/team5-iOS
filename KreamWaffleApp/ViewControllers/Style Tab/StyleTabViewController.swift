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
        let layout = CHTCollectionViewWaterfallLayout()
        layout.itemRenderDirection = .leftToRight
        layout.columnCount = 2
        layout.minimumColumnSpacing = 10
        layout.minimumInteritemSpacing = 3
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        collectionView.register(StyleCollectionViewCell.self, forCellWithReuseIdentifier: StyleCollectionViewCell.identifier)
        return collectionView
    }()
    
    init(viewModel: StyleViewModel) {
        self.viewModel = viewModel

        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.navigationItem.titleView = self.header
        addSubviews()
        configureHeader()
        setUpCollectionView()
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
        NSLayoutConstraint.activate([
            self.searchButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 10),
            self.searchButton.heightAnchor.constraint(equalToConstant: 50),
            self.searchButton.widthAnchor.constraint(equalToConstant: 50),
            self.searchButton.centerYAnchor.constraint(equalTo: self.header.centerYAnchor),
        ])
        
        //configure camera button
        let cameraImage = UIImage(systemName: "camera.circle.fill")
        let tintedcameraImage = cameraImage?.withRenderingMode(.alwaysTemplate)
        self.cameraButton.setImage(tintedcameraImage, for: .normal)
        self.cameraButton.tintColor = .lightGray
        self.cameraButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.cameraButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -10),
            self.cameraButton.widthAnchor.constraint(equalToConstant: 50),
            self.cameraButton.heightAnchor.constraint(equalToConstant: 50),
            self.cameraButton.centerYAnchor.constraint(equalTo: self.header.centerYAnchor),
        ])
    }
    
    
    func configureSegmentedControl(){
        self.header.backgroundColor = .white
        self.header.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.header.heightAnchor.constraint(equalToConstant: 40),
            self.header.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: -50),
            self.header.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            self.header.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
        ])
                         
        self.codeSegmented.backgroundColor = .white
        self.codeSegmented.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.codeSegmented.centerXAnchor.constraint(equalTo: self.header.centerXAnchor),
            self.codeSegmented.centerYAnchor.constraint(equalTo: self.header.centerYAnchor),
            self.codeSegmented.widthAnchor.constraint(equalToConstant: 50),
            self.codeSegmented.heightAnchor.constraint(equalToConstant: 30),
        ])
    }
    
    func setUpCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        
        view.addSubview(collectionView)

        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.collectionView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 5),
            self.collectionView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -5),
            self.collectionView.topAnchor.constraint(equalTo: self.header.bottomAnchor, constant: 10),
            self.collectionView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: 0),
        ])
    }
}

extension StyleTabViewController: UICollectionViewDelegate{
    
}

extension StyleTabViewController: CHTCollectionViewDelegateWaterfallLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let targetImageSize = viewModel.getStyleCellModelListAt(index:indexPath.row).thumbnailImage!.size

        let cellWidth: CGFloat = (view.bounds.width - 20)/2 //셀 가로 넓이
        let imageWidth = targetImageSize.width
        let imageHeight = targetImageSize.height
        let imageRatio = imageHeight/imageWidth

        return CGSize(width: cellWidth, height: imageRatio * cellWidth + 60)
    }
}

extension StyleTabViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: StyleCollectionViewCell.identifier, for: indexPath) as? StyleCollectionViewCell else {
            return StyleCollectionViewCell()
        }
        
        cell.configure(with: self.viewModel.getStyleCellModelListAt(index: indexPath.row))
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.viewModel.getStyleCellModelListNum()
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
}
