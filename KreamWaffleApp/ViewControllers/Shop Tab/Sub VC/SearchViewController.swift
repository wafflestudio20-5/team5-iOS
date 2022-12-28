//
//  SearchViewController.swift
//  KreamWaffleApp
//
//  Created by grace kim  on 2022/12/28.
//

import UIKit
import RxSwift
import RxCocoa




class SearchViewController: UIViewController, UIScrollViewDelegate {

  //multiple collection views inside table view cell
   
  let recentSearchKeywords = ["에어포스", "아디다스 삼바", "검솔", "슈프림", "어그", "덩크", "눕시"]
  let recommendSearchKeywords = ["스캇", "구름백", "삼바", "자더에러", "사카이", "리뉴드테크", "오프화이트"]
    
    private var table : UITableView!
    private let bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.view.addSubview(table)
        //configureTable()
    }
    
    func configureTable(){
        self.table.translatesAutoresizingMaskIntoConstraints = false
        self.table.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 12).isActive = true
        self.table.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -12).isActive = true
        self.table.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        self.table.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
    }
    
    func bind(){
    }
    
    init(){
    super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
