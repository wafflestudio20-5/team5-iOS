//
//  ProductSizeSelectionViewController.swift
//  KreamWaffleApp
//
//  Created by 이선재 on 2023/01/01.
//

import UIKit
import RxSwift
import RxCocoa


//for the half screen modal view
class ProductSizeSelectionViewController: UIViewController, UIScrollViewDelegate, UICollectionViewDelegateFlowLayout {
    
    var viewModel : ShopTabDetailViewModel
    
    init(viewModel : ShopTabDetailViewModel){
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
