//
//  UIViewController+pushAddPostVC\.swift
//  KreamWaffleApp
//
//  Created by 최성혁 on 2023/01/26.
//

import Foundation
import UIKit

extension UIViewController {
    func pushAddPostVC() {
        let newPostRepository = NewPostRepository()
        
        let newPostViewModel = NewPostViewModel(newPostRepository: newPostRepository)
        let newPostVC = NewPostViewController(newPostViewModel: newPostViewModel)
        self.navigationController?.pushViewController(newPostVC, animated: true)
    }
     
}
