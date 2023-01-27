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
    var contentView = UIView()
        
    init(subviewData : subviewData){
        self.subviewData = subviewData
        super.init(frame: .zero)
        self.addSubviews(title, seeMore)
        configureTitle()
        setUpContentViewLayout()
        setUpCellLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureTitle(){
        self.title.translatesAutoresizingMaskIntoConstraints = false
        self.title.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        self.title.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        self.title.textColor = .black
        self.title.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        self.title.text = subviewData?.total_title
    }
    
    func setUpContentViewLayout() {
        self.addSubview(self.contentView)
        self.contentView.backgroundColor = colors.lightGray
        self.contentView.setupCornerRadius(10)

        self.contentView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.contentView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.contentView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.contentView.topAnchor.constraint(equalTo: self.title.bottomAnchor, constant: 5),
            self.contentView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
        ])
    }
    
    func setUpCellLayout() {
        let cell_1 = ProfileSubviewSubCell(mySet: self.subviewData!.set_1)
        let cell_2 = ProfileSubviewSubCell(mySet: self.subviewData!.set_2)
        let cell_3 = ProfileSubviewSubCell(mySet: self.subviewData!.set_3)
        let cell_4 = ProfileSubviewSubCell(mySet: self.subviewData!.set_4)
        
        self.contentView.addSubviews(cell_1, divider, cell_2, cell_3, cell_4)
        let cellWidth = (UIScreen.main.bounds.width - 40)/4
        
        cell_1.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            cell_1.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            cell_1.widthAnchor.constraint(equalToConstant: cellWidth),
            cell_1.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 5),
            cell_1.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor),
        ])
        
        divider.backgroundColor = .lightGray
        divider.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            divider.leadingAnchor.constraint(equalTo: cell_1.trailingAnchor),
            divider.widthAnchor.constraint(equalToConstant: 1),
            divider.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            divider.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor),
        ])
        
        cell_2.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            cell_2.leadingAnchor.constraint(equalTo: divider.trailingAnchor),
            cell_2.widthAnchor.constraint(equalToConstant: cellWidth),
            cell_2.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 5),
            cell_2.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor),
        ])
        
        cell_3.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            cell_3.leadingAnchor.constraint(equalTo: cell_2.trailingAnchor),
            cell_3.widthAnchor.constraint(equalToConstant: cellWidth),
            cell_3.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 5),
            cell_3.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor),
        ])
        
        cell_4.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            cell_4.leadingAnchor.constraint(equalTo: cell_3.trailingAnchor),
            cell_4.widthAnchor.constraint(equalToConstant: cellWidth),
            cell_4.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 5),
            cell_4.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor),
        ])
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
