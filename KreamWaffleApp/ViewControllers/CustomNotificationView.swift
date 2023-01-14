//
//  CustomNotificationView.swift
//  KreamWaffleApp
//
//  Created by grace kim  on 2023/01/06.
//

import Foundation
import UIKit

class CustomNotificationView : UIView {
    
    var notificationText : String?
    var imageView = UIButton()
    
    init(notificationText:String){
        self.notificationText = notificationText
        super.init(frame: .zero)
        self.addSubview(imageView)
        self.setupCornerRadius(25)
        self.backgroundColor = UIColor(red: 73/255.0, green: 73/255.0, blue: 73/255.0, alpha: 0.8)
        setDesign()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setDesign(){
        let label = UILabel()
        let untinted = UIImage(systemName: "exclamationmark.circle")
        let tinted = untinted?.withRenderingMode(.alwaysTemplate)
        imageView.setImage(tinted, for: .normal)
        imageView.tintColor = .red
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10).isActive = true
        imageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: self.frame.height/2).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: self.frame.height/2).isActive = true
        
        self.addSubview(label)
        label.text = self.notificationText
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        label.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
    }
}
