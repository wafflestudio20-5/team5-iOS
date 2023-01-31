//
//  ShopFilterDetailTableViewCell.swift
//  KreamWaffleApp
//
//  Created by 이선재 on 2023/01/30.
//

import UIKit

class ShopFilterDetailTableViewCell: UITableViewCell {
    override var reuseIdentifier: String? {
        return "ShopFilterDetailTableViewCell"
    }
    
    private let headerLabel = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .white
        self.contentView.backgroundColor = .white
        setUpLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(header: String) {
        self.headerLabel.text = header
        self.headerLabel.font = UIFont.systemFont(ofSize: 15)
        self.headerLabel.textColor = .black
    }
    
    func setUpLayout() {
        self.contentView.addSubview(headerLabel)
        headerLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            headerLabel.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor),
            headerLabel.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor),
            headerLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 10),
            headerLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -100),
            headerLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 20),
//            headerLabel.bottomAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 5)
        ])
    }
    
    func setUpAccessoryView() {
        let image = UIImage(systemName: "checkmark")
        let accessory  = UIImageView(frame:CGRect(x:0, y:0, width:(image?.size.width)!, height:(image?.size.height)!))
        accessory.image = image
        accessory.tintColor = .black
        self.accessoryView = accessory
        self.backgroundColor = .white
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        if selected {
            self.headerLabel.font = UIFont.boldSystemFont(ofSize: 15)
            self.selectedBackgroundView?.backgroundColor = .white
            setUpAccessoryView()
        } else {
            self.headerLabel.font = UIFont.systemFont(ofSize: 15)
            self.accessoryView = nil
        }
    }

}
