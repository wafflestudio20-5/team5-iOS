//
//  StyleTabCollectionVC.swift
//  KreamWaffleApp
//
//  Created by 최성혁 on 2023/01/05.
//

import Foundation
import UIKit
import CHTCollectionViewWaterfallLayout
import RxSwift
import RxCocoa

final class StyleTabCollectionViewVC : UIViewController{
    private let viewModel: StyleViewModel
    private let disposeBag = DisposeBag()
    
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
        setUpCollectionView()
    }
    
    func setUpCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self

        view.addSubview(collectionView)

        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.collectionView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 5),
            self.collectionView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -5),
            self.collectionView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            self.collectionView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
}

extension StyleTabCollectionViewVC: CHTCollectionViewDelegateWaterfallLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let targetImageSize = viewModel.getStyleCellModelListAt(index:indexPath.row).thumbnailImage!.size

        let cellWidth: CGFloat = (view.bounds.width - 20)/2 //셀 가로 넓이
        let imageWidth = targetImageSize.width
        let imageHeight = targetImageSize.height
        let imageRatio = imageHeight/imageWidth

        return CGSize(width: cellWidth, height: imageRatio * cellWidth + 60)
    }
}

extension StyleTabCollectionViewVC: UICollectionViewDataSource {
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
