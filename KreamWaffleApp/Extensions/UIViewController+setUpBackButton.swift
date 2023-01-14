//
//  UIViewController+setUpBackButton.swift
//  KreamWaffleApp
//
//  Created by 최성혁 on 2023/01/12.
//

import Foundation
import UIKit

extension UIViewController {
    func setUpBackButton() {
        self.navigationController?.navigationBar.backIndicatorImage = UIImage(systemName: "arrow.backward")
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage(systemName: "arrow.backward")
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
}
