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
    private let headerIndexDict = [0 : "카테고리", 1 : "브랜드", 2 : "가격"]
    private let headerIndexDefaultTextDict = [0 : "모든 카테고리", 1 : "모든 브랜드", 2 : "모든 가격"]
    
    private let headerLabel = UILabel()
    private let selectionLabel = UILabel()
    private var cellModel = ShopFilterItem(header: "", selection: "", items: [])
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .white
        self.selectionStyle = .none
        setUpLabels()
        setUpLayout()
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(updateSubHeader(_:)),
                                               name: NSNotification.Name("filterSelections"),
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(updateSubHeaderBrand(_:)),
                                               name: NSNotification.Name("brandFilterSelections"),
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(updateSubHeaderNil(_:)),
                                               name: NSNotification.Name("filterSelectionsNil"),
                                               object: nil)
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
    
    @objc func updateSubHeader(_ notification: Notification) {
        guard let notification = notification.object as? [String: Any] else { return }
        guard let index = notification["index"] as? Int else { return }
        guard let filterSelectionList = notification["filterSelections"] as? [String] else { return }
 
        if ((index == 0 || index == 2) && headerIndexDict[index] == headerLabel.text) {
            selectionLabel.text = filterSelectionList.joined(separator: ", ")
        }
    }
    
    @objc func updateSubHeaderBrand(_ notification: Notification) {
        guard let notification = notification.object as? [String: Any] else { return }
        guard let index = notification["index"] as? Int else { return }
        guard let filterSelectionList = notification["filterSelections"] as? [Brand] else { return }
 
        if headerIndexDict[index] == headerLabel.text {
            selectionLabel.text = filterSelectionList.map{$0.name}.joined(separator: ", ")
        }
    }
    
    @objc func updateSubHeaderNil(_ notification: Notification) {
        guard let notification = notification.object as? [String: Any] else { return }
        guard let index = notification["index"] as? Int else { return }
        
        if headerIndexDict[index] == headerLabel.text {
            selectionLabel.text = headerIndexDefaultTextDict[index]
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        
    }

}
