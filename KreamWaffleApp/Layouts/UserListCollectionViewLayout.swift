//
//  StyleCollectionViewFlowLayout.swift
//  KreamWaffleApp
//
//  Created by 최성혁 on 2022/12/29.
//

import Foundation
import UIKit

class UserListCollectionViewLayout: UICollectionViewFlowLayout {
    override init() {
        super.init()
        
        self.sectionInset = .init(top: 0, left: 0, bottom: 0, right: 0)
        self.minimumLineSpacing = 0
        self.minimumInteritemSpacing = 0
        self.scrollDirection = .vertical
       
        let cellWidth = UIScreen.main.bounds.width
        self.itemSize = CGSize(width: cellWidth, height: UIScreen.main.bounds.height/16)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
