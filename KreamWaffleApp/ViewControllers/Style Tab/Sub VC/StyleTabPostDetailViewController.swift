//
//  StyleTabPostDetailViewController.swift
//  KreamWaffleApp
//
//  Created by 최성혁 on 2023/01/06.
//

import Foundation
import UIKit

final class StyleTabPostDetailViewController: UIViewController {
    private let viewModel: StyleTabDetailViewModel
    
    init(viewModel: StyleTabDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        self.navigationController?.navigationBar.tintColor = .lightGray
    }
}
