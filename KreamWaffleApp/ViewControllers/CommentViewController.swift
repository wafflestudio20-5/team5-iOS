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
    
    private var textViewBottomConstraint: NSLayoutConstraint?

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
    
    private let font1: CGFloat = 14
    private let font2: CGFloat = 13
    private let font3: CGFloat = 12
        
    private let collectionViewRefreshControl = UIRefreshControl()
    private let writingReplyIndicator = UIView()
    private let writingReplyLabel = UILabel()
    private let stopWritingReplyButton = UIButton()
    
    private lazy var sendCommentButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .clear
        button.setTitle("등록", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel!.font = UIFont.boldSystemFont(ofSize: 14)
        button.addTarget(self, action: #selector(sendButtonTapped), for: .touchUpInside)

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
        setUpWritingReplyIndicator()
        bindUI()
        bindCollectionView()
        setUpRefreshControl()
        requestInitialData()
        
        self.textViewBottomConstraint = enterCommentTextView.bottomConstraint
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil)
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil)
    }
    
    func addSubviews() {
        self.view.addSubview(enterCommentTextView)
        self.view.addSubview(sendCommentButton)
        self.view.addSubview(commentCollectionView)
        self.view.addSubview(writingReplyIndicator)
        self.writingReplyIndicator.addSubview(writingReplyLabel)
        self.writingReplyIndicator.addSubview(stopWritingReplyButton)
    }
    
    func configureDelegate() {
        enterCommentTextView.delegate = self
        commentCollectionView.delegate = self
    }
    
    func setUpEnterCommentView() {
        self.enterCommentTextView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.enterCommentTextView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 5),
            self.enterCommentTextView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -35),
            self.enterCommentTextView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
        ])
        
        self.sendCommentButton.backgroundColor = .clear
        self.sendCommentButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.sendCommentButton.leadingAnchor.constraint(equalTo: self.enterCommentTextView.trailingAnchor, constant: 5),
            self.sendCommentButton.widthAnchor.constraint(equalToConstant: 30),
            self.sendCommentButton.topAnchor.constraint(equalTo: self.enterCommentTextView.topAnchor),
            self.sendCommentButton.heightAnchor.constraint(equalToConstant: 20),
        ])
        
//        self.enterCommentView.bringSubviewToFront(self.sendCommentButton)

    }
    
    func setUpCollectionView() {
        commentCollectionView.showsVerticalScrollIndicator = false

        commentCollectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.commentCollectionView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            self.commentCollectionView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
            self.commentCollectionView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            self.commentCollectionView.bottomAnchor.constraint(equalTo: self.enterCommentTextView.topAnchor),
        ])
    }
    
    func setUpWritingReplyIndicator() {
        self.writingReplyIndicator.translatesAutoresizingMaskIntoConstraints = false
        self.writingReplyLabel.translatesAutoresizingMaskIntoConstraints = false
        self.stopWritingReplyButton.translatesAutoresizingMaskIntoConstraints = false
        
        self.writingReplyIndicator.backgroundColor = .lightGray
        
        self.writingReplyLabel.font = UIFont.boldSystemFont(ofSize: self.font1)
        self.writingReplyLabel.textColor = .black
        self.writingReplyLabel.numberOfLines = 1
        self.writingReplyLabel.textAlignment = .left
        self.writingReplyLabel.adjustsFontSizeToFitWidth = false
        self.writingReplyLabel.text = "댓글 작성 중입니다..."
        
        
        self.stopWritingReplyButton.backgroundColor = .clear
        self.stopWritingReplyButton.setTitle("취소", for: .normal)
        self.stopWritingReplyButton.setTitleColor(.black, for: .normal)
        self.stopWritingReplyButton.titleLabel!.font = UIFont.boldSystemFont(ofSize: self.font2)
        self.stopWritingReplyButton.addTarget(self, action: #selector(stopWritingReplyButtonTapped), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            self.writingReplyIndicator.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            self.writingReplyIndicator.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
            self.writingReplyIndicator.heightAnchor.constraint(equalToConstant: 30),
            self.writingReplyIndicator.bottomAnchor.constraint(equalTo: self.enterCommentTextView.topAnchor),
            
            self.writingReplyLabel.leadingAnchor.constraint(equalTo: self.writingReplyIndicator.leadingAnchor, constant: 10),
            self.writingReplyLabel.trailingAnchor.constraint(equalTo: self.stopWritingReplyButton.leadingAnchor),
            self.writingReplyLabel.centerYAnchor.constraint(equalTo: self.writingReplyIndicator.centerYAnchor),
            
            self.stopWritingReplyButton.widthAnchor.constraint(equalToConstant: 30),
            self.stopWritingReplyButton.trailingAnchor.constraint(equalTo: self.writingReplyIndicator.trailingAnchor),
            self.stopWritingReplyButton.centerYAnchor.constraint(equalTo: self.writingReplyLabel.centerYAnchor),
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
        
        self.commentViewModel.isWritingCommentRelay
            .map { !$0 }
            .bind(to: writingReplyIndicator.rx.isHidden)
            .disposed(by: disposeBag)
    }
    
    func bindCollectionView() {
        commentCollectionView.register(CommentCollectionViewCell.self, forCellWithReuseIdentifier: "CommentCollectionViewCell")

        self.commentViewModel.commentDataSource
            .bind(to: commentCollectionView.rx.items(cellIdentifier: "CommentCollectionViewCell", cellType: CommentCollectionViewCell.self)) { index, item, cell in
                cell.configure(with: item)
            }
            .disposed(by: disposeBag)
    }
    
    func setUpRefreshControl() {
        self.collectionViewRefreshControl.addTarget(self, action: #selector(refreshFunction), for: .valueChanged)
        self.commentCollectionView.refreshControl = self.collectionViewRefreshControl
    }

    
    func requestInitialData() {
        Task {
            let isValidToken = await self.userInfoViewModel.checkAccessToken()
            if isValidToken {
                let token = self.userInfoViewModel.UserResponse?.accessToken
                self.commentViewModel.requestInitialData(token: token!)
            } else {
                let alert = UIAlertController(title: "실패", message: "다시 로그인해주세요.", preferredStyle: UIAlertController.Style.alert)
                let okAction = UIAlertAction(title: "OK", style: .default) { _ in
                    self.navigationController?.popViewController(animated: true)
                }
                alert.addAction(okAction)
                self.present(alert, animated: false, completion: nil)
            }
        }
    }
}

extension CommentViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        self.commentViewModel.isWritingComment = true
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
                    self.commentViewModel.requestNextData(token: token!)
                } else {
                    self.presentLoginAgainAlert()
                }
            }
        }
    }
}

extension CommentViewController {
    @objc func stopWritingReplyButtonTapped() {
        self.commentViewModel.isWritingComment = false
        self.enterCommentTextView.endEditing(true)
        self.enterCommentTextView.text = textViewPlaceHolder
    }
    
    @objc func refreshFunction() {
        Task {
            let isValidToken = await self.userInfoViewModel.checkAccessToken()
            if isValidToken {
                let token = self.userInfoViewModel.UserResponse?.accessToken
                self.commentViewModel.requestInitialData(token: token!)
                self.collectionViewRefreshControl.endRefreshing()
            } else {
                self.presentLoginAgainAlert()
            }
        }
    }
    
    @objc func sendButtonTapped() {
        self.commentViewModel.isWritingComment = false
        if self.enterCommentTextView.text == self.textViewPlaceHolder {
            return
        }
        Task {
            let isValidToken = await self.userInfoViewModel.checkAccessToken()
            if isValidToken {
                let token = self.userInfoViewModel.UserResponse!.accessToken
                
                self.commentViewModel.sendComment(
                    token: token,
                    content: self.enterCommentTextView.text,
                    completion: { [weak self] in
                        self?.requestInitialData()
                        self?.enterCommentTextView.text = self?.textViewPlaceHolder
                    },
                    onNetworkFailure: { [weak self] in
                        let alert = UIAlertController(title: "실패", message: "네트워크 연결을 확인해주세요", preferredStyle: UIAlertController.Style.alert)
                        let okAction = UIAlertAction(title: "OK", style: .default) { _ in
                            self?.navigationController?.popViewController(animated: true)
                        }
                        alert.addAction(okAction)
                        self?.present(alert, animated: false, completion: nil)
                    }
                )
            } else {
                self.presentLoginAgainAlert()
            }
        }
    }
    
    @objc func keyboardWillShow(_ notification: NSNotification)  {
        moveViewWithKeyboard(notification: notification, viewBottomConstraint: self.textViewBottomConstraint!, keyboardWillShow: true)
    }
    
    @objc func keyboardWillHide(_ notification: NSNotification)  {
        moveViewWithKeyboard(notification: notification, viewBottomConstraint: self.textViewBottomConstraint!, keyboardWillShow: false)
    }
    
    func moveViewWithKeyboard(notification: NSNotification, viewBottomConstraint: NSLayoutConstraint, keyboardWillShow: Bool) {
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
        let keyboardHeight = keyboardSize.height

        let keyboardDuration = notification.userInfo![UIResponder.keyboardAnimationDurationUserInfoKey] as! Double
            
        let keyboardCurve = UIView.AnimationCurve(rawValue: notification.userInfo![UIResponder.keyboardAnimationCurveUserInfoKey] as! Int)!
        
        if keyboardWillShow {
            let safeAreaExists = (self.view?.window?.safeAreaInsets.bottom != 0) // Check if safe area exists
            let bottomConstant: CGFloat = 20
            viewBottomConstraint.constant = keyboardHeight + (safeAreaExists ? 0 : bottomConstant)
        }else {
            viewBottomConstraint.constant = 20
        }
        
        let animator = UIViewPropertyAnimator(duration: keyboardDuration, curve: keyboardCurve) { [weak self] in
            // Update Constraints
            self?.view.layoutIfNeeded()
        }
        
        // Perform the animation
        animator.startAnimation()
    }
}

extension CommentViewController: UICollectionViewDelegate {
    
}
