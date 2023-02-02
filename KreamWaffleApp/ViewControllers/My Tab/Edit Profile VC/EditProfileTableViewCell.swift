//
//  EditProfileTableViewCell.swift
//  KreamWaffleApp
//
//  Created by grace on 2023/02/01.
//

import UIKit

class EditProfileTableViewCell: UITableViewCell {
    
    
    var titleLabel = UILabel()
    var currentTextLabel = UILabel()
    var underLine = UILabel()
    
    lazy var editButton: UIButton = {
        let button = UIButton(type: .custom)
        let attributes: [NSAttributedString.Key: Any] = [
            .font : UIFont.systemFont(ofSize: 13, weight: .regular),
        ]
        let titleString = NSAttributedString(string: "변경", attributes: attributes)
        button.setAttributedTitle(titleString, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        var configuration = UIButton.Configuration.plain()
        configuration.baseForegroundColor = .black
        configuration.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 7, bottom: 5, trailing: 7)
        button.configuration = configuration
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?){
        super.init(style: .default, reuseIdentifier: "EditProfileTableViewCell")
        self.contentView.heightAnchor.constraint(greaterThanOrEqualToConstant: 80).isActive = true
        self.contentView.addSubviews(titleLabel, currentTextLabel, underLine, editButton)
        self.setupDesign()
    }
   
    func addData(editCase: editCase, userProfile: Profile?, user: User?){
        switch (editCase){
        case .profileName:
            self.titleLabel.text = "프로필 이름"
            self.currentTextLabel.text = userProfile?.profile_name
        case .userName:
            self.titleLabel.text = "이름"
            self.currentTextLabel.text = userProfile?.user_name
        case .introduction:
            self.titleLabel.text = "소개"
            if (userProfile?.introduction == ""){
            self.currentTextLabel.text = "나를 소개하세요"
            }else{
                self.currentTextLabel.text = userProfile?.introduction
            }
        case .password:
            self.titleLabel.text = "비밀번호"
            self.currentTextLabel.text = "**********"
            
        case .email:
            self.titleLabel.text = "이메일 아이디"
            self.currentTextLabel.text = user?.email
            
        case .shoeSize:
            self.titleLabel.text = "신발 사이즈"
            self.currentTextLabel.text = String(user?.shoeSize ?? 0)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setupDesign(){
        self.titleLabel.textColor = .black
        self.titleLabel.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        self.titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.titleLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 20),
            self.titleLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor)
        ])
    
        self.currentTextLabel.textColor = .black
        self.currentTextLabel.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        self.currentTextLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.currentTextLabel.topAnchor.constraint(equalTo: self.titleLabel.bottomAnchor, constant: 5),
            self.currentTextLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 20)
        ])
        
        let attributes: [NSAttributedString.Key: Any] = [
            .font : UIFont.systemFont(ofSize: 13, weight: .regular),
        ]
        let titleString = NSAttributedString(string: "변경", attributes: attributes)
        self.editButton.setAttributedTitle(titleString, for: .normal)
        self.editButton.layer.borderWidth = 1
        self.editButton.layer.cornerRadius = 9
        self.editButton.setTitleColor(.black, for: .normal)
        self.editButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.editButton.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -20),
            self.editButton.centerYAnchor.constraint(equalTo: self.currentTextLabel.centerYAnchor)
        ])
        
        
        self.underLine.backgroundColor = colors.lessLightGray
        self.underLine.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.underLine.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 20),
            self.underLine.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -20),
            self.underLine.heightAnchor.constraint(equalToConstant: 0.7),
            self.underLine.topAnchor.constraint(equalTo: self.currentTextLabel.bottomAnchor, constant: 10)
        ])
    }
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    //some fields are not changeable
    func removeButton(){
        self.editButton.removeFromSuperview()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if (selected){
            self.backgroundColor = .clear
        }
    }

}
