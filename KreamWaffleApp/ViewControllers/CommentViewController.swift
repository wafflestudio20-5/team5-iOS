//
//  CommentViewController.swift
//  KreamWaffleApp
//
//  Created by 최성혁 on 2023/02/01.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

final class CommentViewController: UIViewController {
    private let commentViewModel: CommentViewModel
    private let userInfoViewModel: UserInfoViewModel

    private let commentCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()

        let cellWidth = UIScreen.main.bounds.width
        layout.itemSize = CGSize(width: cellWidth, height: UIScreen.main.bounds.height/16)

        layout.sectionInset = .init(top: 0, left: 0, bottom: 0, right: 0)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .vertical

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white

        return collectionView
    }()
    
    private let collectionViewRefreshControl = UIRefreshControl()
    private let enterCommentView = UIView()
    
    private lazy var sendCommentButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .clear
        button.setTitle("등록", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel!.font = UIFont.boldSystemFont(ofSize: 14)
        return button
    }()
    
    private let textViewPlaceHolder = "댓글을 작성해보세요..."
    
    private lazy var enterCommentTextView: UITextView = {
        let textView = UITextView()
        textView.isScrollEnabled = false
        textView.layer.borderWidth = 1
        textView.layer.borderColor = UIColor.darkGray.cgColor
        textView.layer.cornerRadius = 15
        textView.clipsToBounds = true
        textView.font = UIFont.systemFont(ofSize: 14)
        textView.text = textViewPlaceHolder
        textView.textColor = .lightGray
        return textView
    }()
    
    private let disposeBag = DisposeBag()
    
    init(userInfoViewModel: UserInfoViewModel, commentViewModel: CommentViewModel) {
        self.userInfoViewModel = userInfoViewModel
        self.commentViewModel = commentViewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        self.view.backgroundColor = .white
        addSubviews()
        configureDelegate()
        setUpEnterCommentView()
        setUpCollectionView()
        bindUI()
        bindCollectionView()
        requestInitialData()
        
        commentCollectionView.register(UINib(nibName: "CommentHeader", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader , withReuseIdentifier: "CommentHeaderIdentifier")
        commentCollectionView.register(UINib(nibName: "ReplyCell", bundle: nil), forCellWithReuseIdentifier: "ReplyCellIdentifier")
    }
    
    
    func addSubviews() {
        self.view.addSubview(self.enterCommentView)
        self.enterCommentView.addSubview(enterCommentTextView)
        self.enterCommentView.addSubview(sendCommentButton)
        self.view.addSubview(commentCollectionView)

    }
    
    func configureDelegate() {
        enterCommentTextView.delegate = self
        commentCollectionView.dataSource = self
    }
    
    func setUpEnterCommentView() {
        self.enterCommentView.backgroundColor = .white

        self.enterCommentView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.enterCommentView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            self.enterCommentView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
            self.enterCommentView.topAnchor.constraint(equalTo: enterCommentTextView.topAnchor, constant: -5),
            self.enterCommentView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
        ])
        
        setUpViewsUnderEnterCommentView()
    }
    
    func setUpViewsUnderEnterCommentView() {
        self.enterCommentTextView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.enterCommentTextView.leadingAnchor.constraint(equalTo: self.enterCommentView.leadingAnchor, constant: 5),
            self.enterCommentTextView.trailingAnchor.constraint(equalTo: self.sendCommentButton.leadingAnchor, constant: -5),
            self.enterCommentTextView.bottomAnchor.constraint(equalTo: self.enterCommentView.bottomAnchor, constant: -5),
        ])
        
        self.sendCommentButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.sendCommentButton.trailingAnchor.constraint(equalTo: self.enterCommentView.trailingAnchor, constant: -7.5),
            self.sendCommentButton.centerYAnchor.constraint(equalTo: self.enterCommentView.centerYAnchor),
        ])
        
        self.enterCommentView.bringSubviewToFront(self.sendCommentButton)
    }
    
    func setUpCollectionView() {

        commentCollectionView.showsVerticalScrollIndicator = false

        commentCollectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.commentCollectionView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            self.commentCollectionView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
            self.commentCollectionView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            self.commentCollectionView.bottomAnchor.constraint(equalTo: self.enterCommentView.topAnchor),
        ])
    }
    
    func bindUI() {
        self.enterCommentTextView.rx.text
            .orEmpty
            .bind(to: self.commentViewModel.postTextRelay)
            .disposed(by: disposeBag)
        
        self.commentViewModel.postTextRelay
            .map { $0.isEmpty || $0 == self.textViewPlaceHolder }
            .bind(to: sendCommentButton.rx.isHidden)
            .disposed(by: disposeBag)
    }
    
    func bindCollectionView() {
        self.commentViewModel.commentDataSource
                    .subscribe { [weak self] event in
                        switch event {
                        case .next:
                            self!.commentCollectionView.reloadData()
                        case .completed:
                            break
                        case .error:
                            break
                        }
                    }
                    .disposed(by: disposeBag)
    }
    
    func requestInitialData() {
        Task {
            let isValidToken = await self.userInfoViewModel.checkAccessToken()
            if isValidToken {
                let token = self.userInfoViewModel.UserResponse?.accessToken
                self.commentViewModel.requestInitialFeed(token: token)
            } else {
                let alert = UIAlertController(title: "실패", message: "네트워크 연결을 확인해주세요", preferredStyle: UIAlertController.Style.alert)
                let okAction = UIAlertAction(title: "OK", style: .default) { _ in
                    self.navigationController?.popViewController(animated: true)
                }
                alert.addAction(okAction)
                self.present(alert, animated: false, completion: nil)
            }
        }
    }
}

extension CommentViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return self.commentViewModel.commentCount
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.commentViewModel.replyCountOfComment(at: section)
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let replyCell = collectionView.dequeueReusableCell(withReuseIdentifier: "ReplyCellIdentifier", for: indexPath) as! ReplyCell
        replyCell.configure(with: self.commentViewModel.getComment(at: indexPath.section).replies[indexPath.row])
        return replyCell
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) ->
            UICollectionReusableView {

            if kind == UICollectionView.elementKindSectionHeader {

                let commentHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "CommentHeaderIdentifier", for: indexPath) as! CommentHeader

                commentHeader.configure(with: self.commentViewModel.getComment(at: indexPath.section))
                return commentHeader
            }

            return UICollectionReusableView()
    }
}

extension CommentViewController: UITextViewDelegate {
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

extension CommentViewController: UIScrollViewDelegate  {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let position = scrollView.contentOffset.y
        if (position > (self.commentCollectionView.contentSize.height - 5 - scrollView.frame.size.height)) {
            Task {
                let isValidToken = await self.userInfoViewModel.checkAccessToken()
                if isValidToken {
                    let token = self.userInfoViewModel.UserResponse?.accessToken
                    self.commentViewModel.requestNextFeed(token: token)
                } else {
                    let alert = UIAlertController(title: "실패", message: "네트워크 연결을 확인해주세요", preferredStyle: UIAlertController.Style.alert)
                    let okAction = UIAlertAction(title: "OK", style: .default) { _ in
                        self.navigationController?.popViewController(animated: true)
                    }
                    alert.addAction(okAction)
                    self.present(alert, animated: false, completion: nil)
                }
            }
        }
    }
}