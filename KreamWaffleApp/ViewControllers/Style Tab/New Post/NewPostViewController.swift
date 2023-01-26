//
//  NewPostViewController.swift
//  KreamWaffleApp
//
//  Created by grace kim  on 2023/01/24.
//

import UIKit
import RxSwift
import RxCocoa

class NewPostViewController: UIViewController, UICollectionViewDelegate, UIScrollViewDelegate {
    
    private let bag = DisposeBag()
    
//    var imageCount = 0 {
//        didSet {
//            self.viewModel?.postCountRelay.accept(imageCount)
//        }
//    }
    
    let addPostViewModel: AddPostViewModel
    let addButton = UIButton()
    let disposeBag = DisposeBag()
    
    private let imageCollectionView: UICollectionView
//    private var layout = UICollectionViewFlowLayout()
    
    lazy var textView: UITextView = {
        let view = UITextView()
        view.textContainerInset = UIEdgeInsets(top: 0, left: 10.0, bottom: 10, right: 10.0)
        view.font = .systemFont(ofSize: 15)
        view.text = textViewPlaceHolder
        view.textColor = .lightGray
        view.delegate = self
        return view
        }()
    
    let textViewPlaceHolder = "#아이템과 #스타일을 자랑해보세요..."
    
    init(addPostViewModel : AddPostViewModel){
        self.addPostViewModel = addPostViewModel
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal

        self.imageCollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)

        super.init(nibName: nil, bundle: nil)
        self.imageCollectionView.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpBackButton()
        self.view.backgroundColor = .white
        setupNavigationBar()
        addSubviews()
        configureImageCollectionView()
        configureTextfield()
        bind()
        //let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapTextView(_:)))
       //view.addGestureRecognizer(tapGesture)
    }
    
    @objc private func didTapTextView(_ sender: Any) {
        view.endEditing(true)
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
    
    func addSubviews(){
        self.view.addSubview(imageCollectionView)
        self.view.addSubview(textView)
    }
    
    private func configureImageCollectionView(){
        //self.layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 20)
        self.imageCollectionView.showsHorizontalScrollIndicator = false
        self.imageCollectionView.backgroundColor = .clear
        self.imageCollectionView.translatesAutoresizingMaskIntoConstraints = false
        self.imageCollectionView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        self.imageCollectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0).isActive = true
        self.imageCollectionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -10).isActive = true
        self.imageCollectionView.heightAnchor.constraint(equalToConstant: 80).isActive = true
        self.imageCollectionView.contentInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
    }
    
    private func configureTextfield(){
        self.textView.translatesAutoresizingMaskIntoConstraints = false
        self.textView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0).isActive = true
        self.textView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0).isActive = true
        self.textView.topAnchor.constraint(equalTo: self.imageCollectionView.bottomAnchor, constant: 20).isActive = true
        self.textView.heightAnchor.constraint(equalToConstant: 150).isActive = true
    }
    
    private func bind() {
        //binding to viewmodel
        self.textView.rx.text
            .orEmpty
            .bind(to: self.addPostViewModel.postTextRelay)
            .disposed(by: bag)
        
        self.addPostViewModel.isValid()
            .bind(to: self.addButton.rx.isEnabled)
            .disposed(by: bag)
        
        self.addPostViewModel.isValid()
            .map { $0 ? UIColor.black: UIColor.lightGray}
            .bind(to: self.addButton.rx.tintColor)
            .disposed(by: bag)
        
    
        
        //binding collection view
//        imageCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
//        self.imageCollectionView.register(PostPhotoCollectionViewCell.self, forCellWithReuseIdentifier: "PostPhotoCollectionViewCell")
//        imageCollectionView.rx.setDelegate(self)
//            .disposed(by: bag)
//        let imageObservable = Observable.of(self.selectedImages)
//        imageObservable
//            .observe(on: MainScheduler.instance)
//            .bind(to: imageCollectionView.rx.items(cellIdentifier: "PostPhotoCollectionViewCell", cellType: PostPhotoCollectionViewCell.self))
//        { index, image, cell in
//            cell.setImage(image: image, viewModel: self.viewModel!)
//            cell.layer.cornerRadius = 5
//        }
//        .disposed(by: bag)
        

        self.imageCollectionView.register(PostPhotoCollectionViewCell.self, forCellWithReuseIdentifier: "PostPhotoCollectionViewCell")

        self.addPostViewModel.selectedImagesDataSource
            .bind(to: imageCollectionView.rx.items(cellIdentifier: "PostPhotoCollectionViewCell", cellType: PostPhotoCollectionViewCell.self)) { index, item, cell in
                cell.tag = index
                cell.setImage(image: item, addPostViewModel: self.addPostViewModel)
            }
            .disposed(by: disposeBag)

        
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.textView.layer.addBorder([.bottom], color: .lightGray, width: 1.0)
    }
    
    /*
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PostPhotoCollectionViewCell", for: indexPath) as? PostPhotoCollectionViewCell else { return UICollectionViewCell() }
        cell.deleteButton.tag = indexPath.row
        cell.deleteButton.addTarget(self, action: #selector(deleteUser(sender:)), for: .touchUpInside)
        return cell
    }

    @objc func deleteUser(sender:UIButton) {
        print("[Log] NewPostVC: delete image")
        let i = sender.tag
        self.selectedImages.remove(at: i)
        self.imageCollectionView.reloadData()
    }*/
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        let width = collectionView.bounds.height
//        let cellWidth = (width - 30) / 3
//        return CGSize(width: 70, height: 70)
//    }
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
