//
//  MyTabSharedUIStackVIew.swift
//  KreamWaffleApp
//
//  Created by grace kim  on 2023/01/21.
//

import UIKit

class MyTabSharedUIStackVIew: UIStackView {
    
    let setCount : Int
    let title1: String
    let subtitle1: String
    let title2: String?
    let subtitle2: String?
    var title3: String?
    let subtitle3: String?
    
    var subView1 : UIStackView?
    var subView2 : UIStackView?
    var subView3: UIStackView?
    
    lazy var titleLabel1 = UILabel()
    lazy var titleLabel2 = UILabel()
    lazy var titleLabel3 = UILabel()
    
    init(title1: String, subtitle1: String, title2 : String?, subtitle2: String?, title3: String?, subtitle3: String?, setCount: Int){
        self.setCount = setCount
        self.title1 = title1
        self.subtitle1 = subtitle1
        self.title2 = title2
        self.subtitle2 = subtitle2
        self.title3 = title3
        self.subtitle3 = subtitle3
        super.init(frame: .zero)
        setupMainView()
        setupSubviews()
        setUpTitleLabel()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpTitleLabel() {
        self.titleLabel1.text = self.title1
        self.titleLabel1.textColor = .black
        self.titleLabel1.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        
        self.titleLabel2.text = self.title2 ?? ""
        self.titleLabel2.textColor = .black
        self.titleLabel2.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        
        self.titleLabel3.text = self.title3 ?? ""
        self.titleLabel3.textColor = .black
        self.titleLabel3.font = UIFont.systemFont(ofSize: 15, weight: .bold)
    }
    
    func subtitleLabel(title: String) -> UILabel{
        let label = UILabel()
        label.text = title
        label.textColor = .darkGray
        label.font = UIFont.systemFont(ofSize: 13, weight: .medium)
        return label
    }
    
    func miniStackView(subviews: [UILabel]) -> UIStackView{
        let view = UIStackView()
        view.addArrangedSubviews(subviews)
        view.axis = .vertical
        view.alignment = .center
        view.spacing = 5
        return view
    }
    
    func setupSubviews(){
        let subtitleLabel_1 = subtitleLabel(title: self.subtitle1)
        let subview_1 = miniStackView(subviews: [self.titleLabel1, subtitleLabel_1])
        subview_1.translatesAutoresizingMaskIntoConstraints = false
        
        let subtitleLabel_2 = subtitleLabel(title: self.subtitle2 ?? "")
        let subview_2 = miniStackView(subviews: [self.titleLabel2, subtitleLabel_2])
        subview_2.translatesAutoresizingMaskIntoConstraints = false
        
        let subtitleLabel_3 = subtitleLabel(title: self.subtitle3 ?? "")
        let subview_3 = miniStackView(subviews: [self.titleLabel3, subtitleLabel_3])
        subview_3.translatesAutoresizingMaskIntoConstraints = false
        
        let subviews = [subview_1, subview_2, subview_3]
        for count in 1...setCount{
            self.addArrangedSubview(subviews[count-1])
        }
    }
    
    func setupMainView(){
        self.backgroundColor = .white
        self.axis = .horizontal
        self.distribution = .equalSpacing
        //self.spacing = 30
        self.alignment = .center
        self.isLayoutMarginsRelativeArrangement = true
        self.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 0, leading: 50, bottom: 0, trailing: 50)
    }
}
