//
//  ShopFilterTableViewCell.swift
//  KreamWaffleApp
//
//  Created by 이선재 on 2023/01/29.
//

import UIKit

class ShopFilterTableViewCell: UITableViewCell {
    override var reuseIdentifier: String? {
        return "ShopFilterTableViewCell"
    }
    
    private let headerLabel = UILabel()
    private let selectionLabel = UILabel()
    private var cellModel = ShopFilterItem(header: "", selection: "", items: [])
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .white
        self.selectionStyle = .none
        setUpLabels()
        setUpLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(cellModel: ShopFilterItem) {
        self.cellModel = cellModel
        self.headerLabel.text = cellModel.header
        self.selectionLabel.text = cellModel.selection
    }
    
    func setUpLabels() {
        // header label
        self.headerLabel.font = UIFont.systemFont(ofSize: 14)
        self.headerLabel.textColor = .black
        
        // selection label
        self.selectionLabel.font = UIFont.systemFont(ofSize: 15)
        self.selectionLabel.textColor = .lightGray
        
        self.accessoryType = .disclosureIndicator
        self.accessoryView?.tintColor = .lightGray
    }
    
    func setUpLayout() {
        self.contentView.addSubview(headerLabel)
        headerLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            headerLabel.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor),
            headerLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 10),
            headerLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -100),
            headerLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 10),
//            headerLabel.bottomAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 5)
        ])
        
        self.contentView.addSubview(selectionLabel)
        selectionLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            selectionLabel.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor),
            selectionLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 10),
            selectionLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -100),
            selectionLabel.topAnchor.constraint(equalTo: self.headerLabel.bottomAnchor, constant: 5),
            selectionLabel.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -10)
        ])
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        
    }

}
