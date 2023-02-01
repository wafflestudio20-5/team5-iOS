//
//  NewPostViewController.swift
//  KreamWaffleApp
//
//  Created by grace kim  on 2023/01/24.
//

import UIKit
import RxSwift
import RxCocoa
import PhotosUI
import Kingfisher

class NewPostViewController: UIViewController, UICollectionViewDelegate, UIScrollViewDelegate {
    let newPostViewModel: NewPostViewModel
    let userInfoViewModel: UserInfoViewModel
    let addButton = UIButton()
    let disposeBag = DisposeBag()
    var cellHeight: CGFloat?
    
    private var imageCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 10
        layout.itemSize = CGSize(width: 150, height: 150)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.register(PostPhotoCollectionViewCell.self, forCellWithReuseIdentifier: "ImageViewCell")
        collectionView.isScrollEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.contentInset = .zero
        
        return collectionView
    }()
    
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
    
    init(newPostViewModel : NewPostViewModel, userInfoViewModel: UserInfoViewModel){
        self.newPostViewModel = newPostViewModel
        self.userInfoViewModel = userInfoViewModel
        
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
        configureTextfield()
        configureImageCollectionView()
        bindUI()
        bindCollectionView()
    }
    
    @objc private func didTapTextView(_ sender: Any) {
        view.endEditing(true)
    }
    
    //등록 버튼 rx 바인딩 해주기
    func setupNavigationBar(){
        self.navigationItem.title = "스타일 올리기"
        
        let uploadPostButton = UIBarButtonItem(title: "등록", style: .plain, target: self, action: #selector(uploadPostButtonTapped))
        uploadPostButton.tintColor = .black

        let plusImage = UIImage(systemName: "plus.circle")
        let addPictureButton = UIBarButtonItem(title: "", style: .plain, target: self, action: #selector(addPictureButtonTapped))
        addPictureButton.image = plusImage
        addPictureButton.tintColor = .black
        
        self.navigationItem.rightBarButtonItems = [uploadPostButton, addPictureButton]

    }
    
    func addSubviews(){
        self.view.addSubview(imageCollectionView)
        self.view.addSubview(textView)
    }
    
    private func configureTextfield() {
        self.textView.backgroundColor = .white
        self.textView.translatesAutoresizingMaskIntoConstraints = false
        self.textView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0).isActive = true
        self.textView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0).isActive = true
        self.textView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        self.textView.heightAnchor.constraint(equalToConstant: 150).isActive = true
    }
    
    private func configureImageCollectionView() {
        self.imageCollectionView.showsHorizontalScrollIndicator = false
        self.imageCollectionView.backgroundColor = .white
        
        self.imageCollectionView.contentInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        
        self.imageCollectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.imageCollectionView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            self.imageCollectionView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
            self.imageCollectionView.topAnchor.constraint(equalTo: self.textView.bottomAnchor, constant: 10),
            self.imageCollectionView.heightAnchor.constraint(equalToConstant: 150),
        ])
    }
    
    private func bindUI() {
        self.textView.rx.text
            .orEmpty
            .bind(to: self.newPostViewModel.postTextRelay)
            .disposed(by: disposeBag)
        
        self.newPostViewModel.isValidPost()
            .subscribe(
                onNext: { isValidPost in
                    if isValidPost {
                        self.navigationItem.rightBarButtonItems![0].isEnabled = true
                        self.navigationItem.rightBarButtonItems![0].tintColor = UIColor.black
                    } else {
                        self.navigationItem.rightBarButtonItems![0].isEnabled = false
                        self.navigationItem.rightBarButtonItems![0].tintColor = UIColor.lightGray
                    }
                }
                )
            .disposed(by: disposeBag)
        
        self.newPostViewModel.postCountRelay
            .map { $0 > 4 ? true : false }
            .subscribe(onNext: { isPictureCntLimit in
                if isPictureCntLimit {
                    self.navigationItem.rightBarButtonItems![1].isEnabled = false
                } else {
                    self.navigationItem.rightBarButtonItems![1].isEnabled = true
                }
            } )
            .disposed(by: disposeBag)
    }
    
    private func bindCollectionView() {
        self.imageCollectionView.register(PostPhotoCollectionViewCell.self, forCellWithReuseIdentifier: "PostPhotoCollectionViewCell")

        self.newPostViewModel.selectedImagesDataSource
            .bind(to: imageCollectionView.rx.items(cellIdentifier: "PostPhotoCollectionViewCell", cellType: PostPhotoCollectionViewCell.self)) { index, item, cell in
                cell.deleteButton.tag = index
                cell.setImage(image: item, addPostViewModel: self.newPostViewModel)
                cell.deleteButton.addTarget(self, action: #selector(self.deleteButtonTapped(sender:)), for: .touchUpInside)
            }
            .disposed(by: disposeBag)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.textView.layer.addBorder([.bottom], color: .lightGray, width: 1.0)
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

//새로운 사진 추가 관련 함수
extension NewPostViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    @objc func addPictureButtonTapped() {
        print("🆕 new picture")
        let uiImagePickerVC = UIImagePickerController()
        uiImagePickerVC.sourceType = .photoLibrary
        uiImagePickerVC.delegate = self

        present(uiImagePickerVC, animated: true, completion: nil)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            self.newPostViewModel.appendPicture(image: image)
        }

        dismiss(animated: true, completion: nil)
    }
}

//버튼과 연결된 함수
extension NewPostViewController {
    @objc func uploadPostButtonTapped() {
        print("✉️ upload post")
        
        let completion = { [weak self] in
            LoadingIndicator.hideLoading()
            self?.navigationController?.popViewController(animated: true)
        }
        
        let onNetworkFailure = { [weak self] in
            let alert = UIAlertController(title: "실패", message: "네트워크 연결을 확인해주세요", preferredStyle: UIAlertController.Style.alert)
            let okAction = UIAlertAction(title: "OK", style: .default) { _ in
                self?.navigationController?.popViewController(animated: true)
            }
            alert.addAction(okAction)
            self?.present(alert, animated: false, completion: nil)
        }
        
        LoadingIndicator.showLoading()
        
        self.newPostViewModel.uploadPost(token: self.userInfoViewModel.UserResponse!.accessToken, content: textView.text, completion: completion, onNetworkFailure: onNetworkFailure)
    }
    
    @objc func deleteButtonTapped(sender: UIButton) {
        print("❌ delete picture")
        self.newPostViewModel.removePicture(at: sender.tag)
    }
}

