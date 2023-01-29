//
//  LoadingView.swift
//  KreamWaffleApp
//
//  Created by 최성혁 on 2023/01/27.
//

import Foundation
import SnapKit
import UIKit

final class LoadingIndicator {
    static func showLoading() {
        // 최상단에 있는 window 객체 획득
        let scenes = UIApplication.shared.connectedScenes
        let windowScene = scenes.first as? UIWindowScene
        guard let window = windowScene?.windows.first else { return }

        let loadingIndicatorView: UIActivityIndicatorView
        if let existedView = window.subviews.first(where: { $0 is UIActivityIndicatorView } ) as? UIActivityIndicatorView {
            loadingIndicatorView = existedView
        } else {
            loadingIndicatorView = UIActivityIndicatorView(style: .large)
            loadingIndicatorView.frame = window.frame
            loadingIndicatorView.color = .brown
            window.addSubview(loadingIndicatorView)
        }

        loadingIndicatorView.startAnimating()
    }
    
    static func hideLoading() {
        DispatchQueue.main.async {
            // 최상단에 있는 window 객체 획득
            let scenes = UIApplication.shared.connectedScenes
            let windowScene = scenes.first as? UIWindowScene
            guard let window = windowScene?.windows.first else { return }
            
            window.subviews.filter({ $0 is UIActivityIndicatorView }).forEach { $0.removeFromSuperview() }
        }
    }
    
    func getSafeAreaTop() -> CGFloat {
        let keyWindow = UIApplication.shared.connectedScenes
            .filter({$0.activationState == .foregroundActive})
            .map({$0 as? UIWindowScene})
            .compactMap({$0})
            .first?.windows
            .filter({$0.isKeyWindow}).first
        return (keyWindow?.safeAreaInsets.top)!
    }
}
