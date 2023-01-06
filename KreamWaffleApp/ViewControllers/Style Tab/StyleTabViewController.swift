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
    private var styleTabCollectionViewVC: StyleTabCollectionViewVC
    
    init(viewModel: StyleViewModel) {
        self.viewModel = viewModel
        styleTabCollectionViewVC = StyleTabCollectionViewVC(viewModel: self.viewModel)

        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigationBar()
        setUpButtons()
        setUpChildVC()
    }
    
    func setUpNavigationBar() {
        self.navigationController?.title = "최신"
        self.navigationController?.navigationBar.backIndicatorImage = UIImage(systemName: "arrow.backward")
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage(systemName: "arrow.backward")
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    
    func setUpButtons() {
        //configure search button
        let searchImage = UIImage(systemName: "magnifyingglass")
        let tintedSearchImage = searchImage?.withRenderingMode(.alwaysTemplate)
        let searchButton = UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(searchButtonTapped))
        searchButton.image = tintedSearchImage
        searchButton.tintColor = .black
        navigationItem.leftBarButtonItem = searchButton
        
        //configure camera button
        let cameraImage = UIImage(systemName: "camera.circle.fill")
        let tintedCameraImage = cameraImage?.withRenderingMode(.alwaysTemplate)
        let cameraButton = UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(cameraButtonTapped))
        cameraButton.image = tintedCameraImage
        cameraButton.tintColor = .lightGray
        navigationItem.rightBarButtonItem = cameraButton
    }
    
    func setUpChildVC() {
        self.view.addSubview(styleTabCollectionViewVC.view)
        self.addChild(styleTabCollectionViewVC)
        styleTabCollectionViewVC.didMove(toParent: self)
        
        styleTabCollectionViewVC.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.styleTabCollectionViewVC.view.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor, constant: 0),
            self.styleTabCollectionViewVC.view.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor, constant: 0),
            self.styleTabCollectionViewVC.view.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 0),
            self.styleTabCollectionViewVC.view.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: 0),
        ])
    }
    
    @objc func cameraButtonTapped() {
        print("camera button tapped")
    }
    
    @objc func searchButtonTapped() {
        print("search button tapped")
    }
}
