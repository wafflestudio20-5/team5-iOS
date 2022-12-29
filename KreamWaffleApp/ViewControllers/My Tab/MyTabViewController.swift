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
        let loginScreen = LoginViewController()
        loginScreen.modalPresentationStyle = .fullScreen
        self.present(loginScreen, animated: false)
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
