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

final class StyleFeedCollectionViewVC : UIViewController{
    /*  이 view model을 뭘 끼우느냐에 따라서
     *  1. STYLE탭 메인에서 보여주는 collection view
     *  2. 사용자별 프로필 페이지에서 피드를 보여주는 collection view
     */
    private let disposeBag = DisposeBag()
    private let styleFeedViewModel: StyleFeedViewModel
    private let userInfoViewModel: UserInfoViewModel
    
    private let collectionView: UICollectionView = {
        let layout = CHTCollectionViewWaterfallLayout()
        layout.itemRenderDirection = .leftToRight
        layout.columnCount = 2
        layout.minimumColumnSpacing = 10
        layout.minimumInteritemSpacing = 3
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        collectionView.register(StyleFeedCollectionViewCell.self, forCellWithReuseIdentifier: StyleFeedCollectionViewCell.identifier)
        return collectionView
    }()
    
    init(styleFeedViewModel: StyleFeedViewModel, userInfoViewModel: UserInfoViewModel) {
        self.styleFeedViewModel = styleFeedViewModel
        self.userInfoViewModel = userInfoViewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpCollectionView()
        bindCollectionView()
        requestInitialData()
    }
    
    func setUpCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self

        view.addSubview(collectionView)
        collectionView.showsVerticalScrollIndicator = false
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.collectionView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 5),
            self.collectionView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -5),
            self.collectionView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            self.collectionView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
    
    func bindCollectionView() {
        self.styleFeedViewModel.stylePostDataSource
                    .subscribe { [weak self] event in
                        switch event {
                        case .next:
                            self!.collectionView.reloadData()
                        case .completed:
                            break
                        case .error:
                            break
                        }
                    }
                    .disposed(by: disposeBag)
    }
    
    func requestInitialData() {
        self.styleFeedViewModel.requestStylePostData(page: 1)
    }
    
    func requestStylePostData(page: Int) {
        self.styleFeedViewModel.requestStylePostData(page: page)
    }
}

extension StyleFeedCollectionViewVC: CHTCollectionViewDelegateWaterfallLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let targetImageRatio = CGFloat(styleFeedViewModel.getStylePostAt(at: indexPath.row).image_ratio)
        
        let cellWidth: CGFloat = (view.bounds.width - 20)/2 //셀 가로 넓이
        let labelHeight: CGFloat = 20 // cell에서 label하나의 높이

        return CGSize(width: cellWidth, height: targetImageRatio * cellWidth + 3*labelHeight)
    }
}

extension StyleFeedCollectionViewVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: StyleFeedCollectionViewCell.identifier, for: indexPath) as? StyleFeedCollectionViewCell else {
            return StyleFeedCollectionViewCell()
        }
        
        cell.configure(with: self.styleFeedViewModel.getStylePostAt(at: indexPath.row))
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.styleFeedViewModel.getStylePostListCount()
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
}

extension StyleFeedCollectionViewVC: UIScrollViewDelegate  {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        let position = scrollView.contentOffset.y
//        if (position > (self.collectionView.contentSize.height - 5 - scrollView.frame.size.height)) {
//            self.viewModel.requestStylePostData(page: 2)
//        }
    }
}

extension StyleFeedCollectionViewVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {        
        let detailViewRepository = StyleDetailRepository()
        let detailUsecase = StyleDetailUsecase(repository: detailViewRepository, stylePost: self.styleFeedViewModel.getStylePostAt(at: indexPath.row))
        
        let detailViewModel = StyleTabDetailViewModel(styleDetailUsecase: detailUsecase)
        let newDetailViewController = StyleTabPostDetailViewController(styleTabDetailViewModel: detailViewModel, userInfoViewModel: self.userInfoViewModel)
        self.navigationController?.pushViewController(newDetailViewController, animated: true)
    }
}
