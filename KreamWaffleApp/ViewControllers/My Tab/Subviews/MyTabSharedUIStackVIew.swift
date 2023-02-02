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
    let title3: String?
    let subtitle3: String?
    
    lazy var subView1 = UIStackView()
    lazy var subView2 = UIStackView()
    lazy var subView3 = UIStackView()
    
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
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func titleLabel(title: String) -> UILabel{
        let label = UILabel()
        label.text = title
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        return label
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
        let titleLabel_1 = titleLabel(title: self.title1)
        let subtitleLabel_1 = subtitleLabel(title: self.subtitle1)
        let subview_1 = miniStackView(subviews: [titleLabel_1, subtitleLabel_1])
        subview_1.translatesAutoresizingMaskIntoConstraints = false
        
        let titleLabel_2 = titleLabel(title: self.title2 ?? "")
        let subtitleLabel_2 = subtitleLabel(title: self.subtitle2 ?? "")
        let subview_2 = miniStackView(subviews: [titleLabel_2, subtitleLabel_2])
        subview_2.translatesAutoresizingMaskIntoConstraints = false
        
        let titleLabel_3 = titleLabel(title: self.title3 ?? "")
        let subtitleLabel_3 = subtitleLabel(title: self.subtitle3 ?? "")
        let subview_3 = miniStackView(subviews: [titleLabel_3, subtitleLabel_3])
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
