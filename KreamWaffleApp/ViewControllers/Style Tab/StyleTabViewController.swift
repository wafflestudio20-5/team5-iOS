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
    
//    private var header = UIView()
    private var codeSegmented = CustomSegmentedControl(buttonTitle: ["최신"])
    private var searchButton = UIButton()
    private lazy var cameraButton = UIButton()
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
        addSubviews()
        setUpSegmentedControl()
        setUpButtons()
        setUpChildVC()
    }
    
    func addSubviews(){
        view.addSubview(codeSegmented)
        view.addSubview(searchButton)
        view.addSubview(cameraButton)
    }
    
    func setUpSegmentedControl() {
        self.codeSegmented.backgroundColor = .white
        self.codeSegmented.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.codeSegmented.centerXAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerXAnchor),
            self.codeSegmented.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 50),
            self.codeSegmented.widthAnchor.constraint(equalToConstant: 50),
            self.codeSegmented.heightAnchor.constraint(equalToConstant: 30),
        ])
    }
    
    func setUpButtons() {
        //configure search button
        let searchImage = UIImage(systemName: "magnifyingglass")
        let tintedSearchImage = searchImage?.withRenderingMode(.alwaysTemplate)
        self.searchButton.setImage(tintedSearchImage, for: .normal)
        self.searchButton.tintColor = .black
        self.searchButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.searchButton.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            self.searchButton.centerYAnchor.constraint(equalTo: self.codeSegmented.centerYAnchor),
            self.searchButton.widthAnchor.constraint(equalToConstant: 50),
            self.searchButton.heightAnchor.constraint(equalToConstant: 50),
        ])
        
        //configure camera button
        let cameraImage = UIImage(systemName: "camera.circle.fill")
        let tintedcameraImage = cameraImage?.withRenderingMode(.alwaysTemplate)
        self.cameraButton.setImage(tintedcameraImage, for: .normal)
        self.cameraButton.tintColor = .lightGray
        
        self.cameraButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.cameraButton.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            self.cameraButton.centerYAnchor.constraint(equalTo: self.codeSegmented.centerYAnchor),
            self.cameraButton.widthAnchor.constraint(equalToConstant: 50),
            self.cameraButton.heightAnchor.constraint(equalToConstant: 50),
        ])
    }
    
    func setUpChildVC() {
        self.addChild(styleTabCollectionViewVC)
        self.view.addSubview(styleTabCollectionViewVC.view)
        styleTabCollectionViewVC.didMove(toParent: self)
        
        styleTabCollectionViewVC.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.styleTabCollectionViewVC.view.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor, constant: 0),
            self.styleTabCollectionViewVC.view.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor, constant: 0),
            self.styleTabCollectionViewVC.view.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 0),
            self.styleTabCollectionViewVC.view.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: 0),
        ])
    }
}
