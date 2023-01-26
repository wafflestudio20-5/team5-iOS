//
//  AddPostViewModel.swift
//  KreamWaffleApp
//
//  Created by grace kim  on 2023/01/25.
//

import Foundation
import UIKit
import RxSwift
import RxRelay


final class NewPostViewModel {
    let postCountRelay = BehaviorRelay<Int>(value: 0)
    let postTextRelay = BehaviorRelay<String>(value: "")
    let selectedImagesRelay = BehaviorRelay<[UIImage]>(value: [])
    
    var selectedImagesDataSource: Observable<[UIImage]> {
        return selectedImagesRelay.asObservable()
    }
    
    var selectedImages = [UIImage]() {
        didSet {
            self.postCountRelay.accept(selectedImages.count)
            self.selectedImagesRelay.accept(selectedImages)
        }
    }
    
    let newPostRepository: NewPostRepository
    
    let bag = DisposeBag()
    
    init(newPostRepository: NewPostRepository) {
        self.newPostRepository = newPostRepository
    }
    
    func isValidPost() -> Observable<Bool> {
        return Observable.combineLatest(postCountRelay, postTextRelay).map { count, text in
            return (!text.isEmpty && count>0)
        }
    }
    
    func uploadPost(){
        //사진이랑 텍스트 보냄.
    }
    
    func removePicture(at index: Int){
        self.selectedImages.remove(at: index)
    }
    
    func appendPicture(image: UIImage?) {
        if let newImage = image {
            self.selectedImages.append(newImage)
        } else {
            print("😞 newImage is nil")
        }
    }
}
