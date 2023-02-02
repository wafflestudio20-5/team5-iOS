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
    
    private let font1: CGFloat = 14;
        
    private let collectionViewRefreshControl = UIRefreshControl()
    private let enterCommentView = UIView()
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
        requestInitialData()
        
        commentCollectionView.register(UINib(nibName: "CommentHeader", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader , withReuseIdentifier: "CommentHeaderIdentifier")
        commentCollectionView.register(UINib(nibName: "ReplyCell", bundle: nil), forCellWithReuseIdentifier: "ReplyCellIdentifier")
    }
    
    
    func addSubviews() {
        self.view.addSubview(self.enterCommentView)
        self.enterCommentView.addSubview(enterCommentTextView)
        self.enterCommentView.addSubview(sendCommentButton)
        self.view.addSubview(commentCollectionView)
        self.view.addSubview(writingReplyIndicator)
        self.writingReplyIndicator.addSubview(writingReplyLabel)
        self.writingReplyIndicator.addSubview(stopWritingReplyButton)
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
            self.enterCommentTextView.trailingAnchor.constraint(equalTo: self.enterCommentView.trailingAnchor, constant: -35),
            self.enterCommentTextView.bottomAnchor.constraint(equalTo: self.enterCommentView.bottomAnchor, constant: -5),
        ])
        
        self.sendCommentButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.sendCommentButton.leadingAnchor.constraint(equalTo: self.enterCommentTextView.trailingAnchor, constant: 5),
            self.sendCommentButton.widthAnchor.constraint(equalToConstant: 30),
            self.sendCommentButton.centerYAnchor.constraint(equalTo: self.enterCommentView.centerYAnchor),
            self.sendCommentButton.heightAnchor.constraint(equalToConstant: 20),
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
        self.writingReplyLabel.text = "답글 작성 중입니다..."
        
        self.stopWritingReplyButton.setImage(UIImage(systemName: "x.circle"), for: .normal)
        self.stopWritingReplyButton.addTarget(self, action: #selector(stopWritingReplyButtonTapped), for: .touchUpInside)
        self.stopWritingReplyButton.setPreferredSymbolConfiguration(.init(pointSize: 20, weight: .regular, scale: .default), forImageIn: .normal)
        self.stopWritingReplyButton.tintColor = .black
        self.stopWritingReplyButton.backgroundColor = .white
        
        NSLayoutConstraint.activate([
            self.writingReplyIndicator.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            self.writingReplyIndicator.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
            self.writingReplyIndicator.heightAnchor.constraint(equalToConstant: 20),
            self.writingReplyIndicator.bottomAnchor.constraint(equalTo: self.enterCommentView.topAnchor),
            
            self.writingReplyLabel.leadingAnchor.constraint(equalTo: self.writingReplyIndicator.leadingAnchor),
            self.writingReplyLabel.trailingAnchor.constraint(equalTo: self.stopWritingReplyButton.leadingAnchor),
            self.writingReplyLabel.centerYAnchor.constraint(equalTo: self.writingReplyIndicator.centerYAnchor),
            
            self.stopWritingReplyButton.widthAnchor.constraint(equalToConstant: 20),
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
        
        self.commentViewModel.isWritingReplyRelay
            .map { !$0 }
            .bind(to: writingReplyIndicator.rx.isHidden)
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
        replyCell.replyButton.tag = self.commentViewModel.getComment(at: indexPath.section).replies[indexPath.row].id
        replyCell.replyButton.replyToProfile = self.commentViewModel.getComment(at: indexPath.section).replies[indexPath.row].to_profile
        replyCell.replyButton.addTarget(self, action: #selector(replyToReplyButtonTapped(sender:)), for: .touchUpInside)
        
        return replyCell
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) ->
            UICollectionReusableView {

            if kind == UICollectionView.elementKindSectionHeader {

                let commentHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "CommentHeaderIdentifier", for: indexPath) as! CommentHeader

                commentHeader.configure(with: self.commentViewModel.getComment(at: indexPath.section))
                commentHeader.replyButton.tag = self.commentViewModel.getCommentId(at: indexPath.section)
                commentHeader.replyButton.addTarget(self, action: #selector(replyToCommentButtonTapped(sender:)), for: .touchUpInside)
                commentHeader.replyButton.replyToProfile = self.commentViewModel.getComment(at: indexPath.section).replies[indexPath.row].to_profile
                
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
                    self.commentViewModel.requestNextData(token: token!)
                } else {
                    self.presentLoginAgainAlert()
                }
            }
        }
    }
}

extension CommentViewController {
    @objc func replyToReplyButtonTapped(sender: ReplyButton) {
        self.commentViewModel.isWritingReply = true
        self.commentViewModel.currentReplyToProfile = sender.replyToProfile
        self.writingReplyLabel.text = "\(sender.replyToProfile!.profile_name)님에게 답글 작성중..."
        self.commentViewModel.currentReplyTarget = sender.tag
    }
    
    @objc func replyToCommentButtonTapped(sender: ReplyButton) {
        self.commentViewModel.isWritingReply = true
        self.commentViewModel.currentReplyToProfile = sender.replyToProfile
        self.writingReplyLabel.text = "\(sender.replyToProfile!.profile_name)님에게 답글 작성중..."
        self.commentViewModel.currentReplyTarget = sender.tag
    }
    
    @objc func stopWritingReplyButtonTapped() {
        self.commentViewModel.isWritingReply = false
        self.enterCommentTextView.endEditing(true)
        self.enterCommentTextView.text = textViewPlaceHolder
    }
    
    @objc func sendButtonTapped() {
        Task {
            let isValidToken = await self.userInfoViewModel.checkAccessToken()
            if isValidToken {
                let token = self.userInfoViewModel.UserResponse!.accessToken
                
                if (self.commentViewModel.isWritingReply) {
                    self.commentViewModel.sendReply(
                        token: token,
                        to_profile: self.commentViewModel.currentReplyToProfile!.profile_name,
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
                }
            } else {
                self.presentLoginAgainAlert()
            }
        }
        
    }
}
