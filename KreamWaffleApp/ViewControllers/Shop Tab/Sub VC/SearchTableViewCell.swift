//
//  SearchTableViewCell.swift
//  KreamWaffleApp
//
//  Created by grace kim  on 2022/12/28.
//

import UIKit


class SearchTableViewCell: UITableViewCell {
    
    var collectionView : UICollectionView?
    
    override var reuseIdentifier: String? {
        return "SearchTableViewCell"
    }
    
    init(collectionView : UICollectionView){
        super.init(style: .default, reuseIdentifier: "SearchTableViewCell")
        self.collectionView = collectionView
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
