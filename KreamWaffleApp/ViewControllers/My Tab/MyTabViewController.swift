//
//  MyTabViewController.swift
//  KreamWaffleApp
//
//  Created by 이선재 on 2022/12/25.
//
import UIKit

class MyTabViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        //shoeScreen.modalPresentationStyle = .fullScreen
        let loginScreen = LoginViewController()
        let profile = ProfileViewController()
        loginScreen.modalPresentationStyle = .fullScreen
        self.present(loginScreen, animated: false)
    }
    

}
