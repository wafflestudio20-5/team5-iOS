//
//  UIViewController+presentLoginAgainAlert.swift
//  KreamWaffleApp
//
//  Created by 최성혁 on 2023/02/02.
//

import Foundation
import UIKit

extension UIViewController {
    func presentLoginAgainAlert() {
        let alert = UIAlertController(title: "실패", message: "다시 로그인해주세요.", preferredStyle: UIAlertController.Style.alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { _ in
            self.navigationController?.popViewController(animated: true)
        }
        alert.addAction(okAction)
        self.present(alert, animated: false, completion: nil)
    }
    
}
