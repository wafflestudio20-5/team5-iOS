//
//  OpeningViewController.swift
//  KreamWaffleApp
//
//  Created by grace kim  on 2023/01/18.
//

import UIKit

class OpeningViewController: UIViewController {
    
    var openingImage = UIImageView()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .black
        self.view.addSubview(openingImage)
        let image = UIImage(named: "OpeningScreen")
        //resize image
        let resizedImage = image?.resize(targetSize: CGSize(width: self.view.frame.width, height: self.view.frame.height))
        self.openingImage.image = resizedImage
        self.openingImage.translatesAutoresizingMaskIntoConstraints = false
        self.openingImage.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        self.openingImage.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        self.openingImage.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        self.openingImage.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        let seconds = 0.5
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
            self.dismiss(animated: true)
        }
    }
    


}
