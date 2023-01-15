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
    var divider = UIView()
    
    var stackView = UIStackView()
    
    init(subviewData : subviewData){
        self.subviewData = subviewData
        super.init(frame: .zero)
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
        stackView.axis = .horizontal
        stackView.alignment = .top
        stackView.distribution = .equalSpacing
//        stackView.layoutMargins = UIEdgeInsets(top: -10, left: -10, bottom: -10, right: -10)
//        self.stackView.addBackground(color: .)
        stackView.spacing = 0
        stackView.layer.cornerRadius = 10

        
        if (self.subviewData?.total_title == "보관 판매 내역"){
            self.stackView.backgroundColor = colors.backgroundGreen
        } else{
            self.stackView.backgroundColor = colors.lessLightGray
        }
        
        self.stackView.translatesAutoresizingMaskIntoConstraints = false
        self.stackView.topAnchor.constraint(equalTo: self.title.bottomAnchor).isActive = true
        self.stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        self.stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        self.stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        
        let cell_1 = ProfileSubviewSubCell(mySet: self.subviewData!.set_1)
        let cell_2 = ProfileSubviewSubCell(mySet: self.subviewData!.set_2)
        let cell_3 = ProfileSubviewSubCell(mySet: self.subviewData!.set_3)
        let cell_4 = ProfileSubviewSubCell(mySet: self.subviewData!.set_4)
                
        let cellList = [cell_1, divider, cell_2, cell_3, cell_4]
        self.stackView.addArrangedSubviews(cellList)

        cell_1.translatesAutoresizingMaskIntoConstraints = false
        cell_1.leadingAnchor.constraint(equalTo: stackView.leadingAnchor, constant: 20).isActive = true
        
        self.divider.backgroundColor = .gray
        
        self.divider.translatesAutoresizingMaskIntoConstraints = false
        self.divider.leadingAnchor.constraint(equalTo: cell_1.trailingAnchor, constant: 10).isActive = true
        self.divider.widthAnchor.constraint(equalToConstant: 1).isActive = true
        self.divider.heightAnchor.constraint(equalTo: self.stackView.heightAnchor).isActive = true
        
        cell_2.translatesAutoresizingMaskIntoConstraints = false
        cell_2.leadingAnchor.constraint(equalTo: divider.trailingAnchor, constant: 10).isActive = true
        
        cell_3.translatesAutoresizingMaskIntoConstraints = false
        cell_3.leadingAnchor.constraint(equalTo: cell_2.trailingAnchor, constant: 10).isActive = true
        
        cell_4.translatesAutoresizingMaskIntoConstraints = false
        cell_4.leadingAnchor.constraint(equalTo: cell_3.trailingAnchor, constant: 10).isActive = true
        cell_4.trailingAnchor.constraint(lessThanOrEqualTo:stackView.trailingAnchor, constant: -20).isActive = true
        
        
        for view in stackView.arrangedSubviews {
            stackView.sendSubviewToBack(view)
        }
        
        print("\(stackView.arrangedSubviews)")
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
