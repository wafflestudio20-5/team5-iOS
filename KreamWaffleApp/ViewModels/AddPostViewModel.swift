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


final class AddPostViewModel{
    
    let postCountRelay = BehaviorRelay<Int>(value: 0)
    let postTextRelay = BehaviorRelay<String>(value: "")
    let selectedImagesDataSource = BehaviorRelay<[UIImage]>(value: [])
    
    var selectedImages = [UIImage]() {
        didSet {
            self.postCountRelay.accept(selectedImages.count)
            self.selectedImagesDataSource.accept(selectedImages)
        }
    }
    
    let bag = DisposeBag()
    
    init(selectedImages: [UIImage]) {
        self.selectedImages = selectedImages
    }
    
    func isValid() -> Observable<Bool> {
        return Observable.combineLatest(postCountRelay, postTextRelay).map { count, text in
            return (!text.isEmpty && count>0)
        }
    }
    
    func addPost(){
        //사진이랑 텍스트 보냄. 
    }
    
    func removePhoto(at index: Int){
        self.selectedImages.remove(at: index)
    }
}
