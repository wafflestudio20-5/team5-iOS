//
//  NewPostViewController.swift
//  KreamWaffleApp
//
//  Created by grace kim  on 2023/01/24.
//

import UIKit
import RxSwift
import RxCocoa

class NewPostViewController: UIViewController, UIScrollViewDelegate {
    
    private let bag = DisposeBag()
    
    var imageCount = 0 {
        didSet {
            self.viewModel?.postCountRelay.accept(imageCount)
        }
    }
    
    private var selectedImages : [UIImage]
    var viewModel : AddPostViewModel?
    let addButton = UIButton()
    
    let textViewPlaceHolder = "#아이템과 #스타일을 자랑해보세요..."
    
    lazy var textView: UITextView = {
        let view = UITextView()
        view.layer.borderWidth = 1.0
        view.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.7).cgColor
        view.textContainerInset = UIEdgeInsets(top: 16.0, left: 16.0, bottom: 16.0, right: 16.0)
        view.font = .systemFont(ofSize: 18)
        view.text = textViewPlaceHolder
        view.textColor = .lightGray
        view.delegate = self
        return view
        }()

    private var imageCollectionView : UICollectionView!
    private var layout = UICollectionViewFlowLayout()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        setupNavigationBar()
        bind()
        addSubviews()
        configureImageCollectionView()
        configureTextfield()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapTextView(_:)))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc
        private func didTapTextView(_ sender: Any) {
            view.endEditing(true)
        }

    
    func addSubviews(){
        self.view.addSubview(imageCollectionView)
        self.view.addSubview(textView)
    }
    
    //등록 버튼 rx 바인딩 해주기
    func setupNavigationBar(){
        addButton.setTitle("등록", for: .normal)
        addButton.setTitleColor(.black, for: .normal)
        addButton.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        let navButton = UIBarButtonItem(customView: addButton)
        self.navigationItem.rightBarButtonItem = navButton
        self.navigationItem.title = "스타일 올리기"
    }
    
    //should take photo and post view model
    init(selectedImages : [UIImage], viewModel : AddPostViewModel){
        self.selectedImages = selectedImages
        self.viewModel = viewModel
        self.imageCount = selectedImages.count
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func bind(){
       
        //binding to viewmodel
        self.textView.rx.text
            .orEmpty
            .bind(to: self.viewModel!.postTextRelay)
            .disposed(by: bag)
        
        self.viewModel?.isValid()
            .bind(to: self.addButton.rx.isEnabled)
            .disposed(by: bag)
        
        self.viewModel?.isValid()
            .map { $0 ? UIColor.black: UIColor.lightGray}
            .bind(to: self.addButton.rx.tintColor)
            .disposed(by: bag)
        
        
        //binding collection view
        imageCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        self.imageCollectionView.register(PostPhotoCollectionViewCell.self, forCellWithReuseIdentifier: "PostPhotoCollectionViewCell")
        imageCollectionView.rx.setDelegate(self)
            .disposed(by: bag)
        let imageObservable = Observable.of(self.selectedImages)
        imageObservable
            .observe(on: MainScheduler.instance)
            .bind(to: imageCollectionView.rx.items(cellIdentifier: "PostPhotoCollectionViewCell", cellType: PostPhotoCollectionViewCell.self))
        { index, image, cell in
            cell.setImage(image)
            cell.layer.cornerRadius = 5
        }
        .disposed(by: bag)
    }
    
    private func configureImageCollectionView(){
        self.layout.scrollDirection = .horizontal
        self.imageCollectionView.setCollectionViewLayout(layout, animated: true)
        self.imageCollectionView.showsHorizontalScrollIndicator = false
        self.imageCollectionView.backgroundColor = .clear
        self.imageCollectionView.translatesAutoresizingMaskIntoConstraints = false
        self.imageCollectionView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 90).isActive = true
        self.imageCollectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 10).isActive = true
        self.imageCollectionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -10).isActive = true
        self.imageCollectionView.heightAnchor.constraint(equalToConstant: 90).isActive = true
        self.imageCollectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 15)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.textView.layer.addBorder([.bottom], color: .lightGray, width: 1.0)
    }
    
    private func configureTextfield(){
        self.textView.translatesAutoresizingMaskIntoConstraints = false
        self.textView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0).isActive = true
        self.textView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0).isActive = true
        self.textView.topAnchor.constraint(equalTo: self.imageCollectionView.bottomAnchor, constant: 10).isActive = true
        self.textView.heightAnchor.constraint(equalToConstant: 200).isActive = true
    }
}

extension NewPostViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == textViewPlaceHolder {
            textView.text = nil
            textView.textColor = .black
        }
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            textView.text = textViewPlaceHolder
            textView.textColor = .lightGray
        }
    }

    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let inputString = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard let oldString = textView.text, let newRange = Range(range, in: oldString) else { return true }
        let newString = oldString.replacingCharacters(in: newRange, with: inputString).trimmingCharacters(in: .whitespacesAndNewlines)

        let characterCount = newString.count
        guard characterCount <= 700 else { return false }
        return true
    }
}
