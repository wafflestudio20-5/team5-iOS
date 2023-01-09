//
//  ProfileSubview.swift
//  KreamWaffleApp
//
//  Created by grace kim  on 2023/01/02.
//
import Foundation
import UIKit

struct titleNumberSet {
    var title : String
    var number : Int
}

struct subviewData {
    var total_title : String //보관판매내역
    var set_1 : titleNumberSet //발송 요청
    var set_2 : titleNumberSet //판매 대기
    var set_3 : titleNumberSet //판매 중
    var set_4 : titleNumberSet //정산 완료
}

class ProfileSubview : UIView {
    var subviewData : subviewData?
    
    var title = UILabel()
    var seeMore = UIButton()
    var divider = UILabel()
    var stackView = UIStackView()
    
    init(subviewData : subviewData){
        self.subviewData = subviewData
        super.init(frame: .zero)
        self.backgroundColor = .clear
        self.addSubviews(title, seeMore, stackView)
        configureTitle()
        configureStackView()
    }
    
    func configureTitle(){
        self.title.translatesAutoresizingMaskIntoConstraints = false
        self.title.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        self.title.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        self.title.textColor = .black
        self.title.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        self.title.text = subviewData?.total_title
    }
    
    
    func configureStackView(){
        self.stackView.axis = .horizontal
        self.stackView.alignment = .center
        self.stackView.distribution = .equalSpacing
        self.stackView.layoutMargins = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        
        if (self.subviewData?.total_title == "보관 판매 내역"){
            self.stackView.backgroundColor = colors.backgroundGreen
        }else{
            self.stackView.backgroundColor = colors.lightGray
        }
        
        let cell_1 = ProfileSubviewSubCell(mySet: self.subviewData!.set_1)
        let cell_2 = ProfileSubviewSubCell(mySet: self.subviewData!.set_2)
        let cell_3 = ProfileSubviewSubCell(mySet: self.subviewData!.set_3)
        let cell_4 = ProfileSubviewSubCell(mySet: self.subviewData!.set_4)
        
        self.divider.backgroundColor = .lightGray
        
        
        self.divider.translatesAutoresizingMaskIntoConstraints = false
        self.divider.widthAnchor.constraint(equalToConstant: 1).isActive = true
        self.divider.heightAnchor.constraint(equalTo: self.stackView.heightAnchor).isActive = true
        
        self.stackView.translatesAutoresizingMaskIntoConstraints = false
        self.stackView.topAnchor.constraint(equalTo: self.title.bottomAnchor, constant: 10).isActive = true
        self.stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20).isActive = true
        self.stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20).isActive = true
        self.stackView.heightAnchor.constraint(greaterThanOrEqualToConstant: self.frame.height/16).isActive = true
        
        self.stackView.addArrangedSubviews([cell_1, divider, cell_2, cell_3, cell_4])
        
        //self.stackView.layer.cornerRadius = 10
        self.stackView.addBackground(color: .systemGray)
        self.stackView.layer.cornerRadius = 10
        //self.stackView.clipsToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


class SeparatorView: UIView {

    init() {
        super.init(frame: .zero)
        setUp()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setUp() {
        backgroundColor = .gray
    }

}
