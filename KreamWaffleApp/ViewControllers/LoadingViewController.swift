//
//  LoadingViewController.swift
//  KreamWaffleApp
//
//  Created by grace kim  on 2023/01/06.
//

import UIKit

class LoadingViewController: UIViewController {
    
    var notification : CustomNotificationView?
    
    var loadingActivityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        
        indicator.style = .large
        indicator.color = .white
            
        // The indicator should be animating when
        // the view appears.
        indicator.startAnimating()
            
        // Setting the autoresizing mask to flexible for all
        // directions will keep the indicator in the center
        // of the view and properly handle rotation.
        indicator.autoresizingMask = [
            .flexibleLeftMargin, .flexibleRightMargin,
            .flexibleTopMargin, .flexibleBottomMargin
        ]
            
        return indicator
    }()
    
    var blurEffectView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        
        blurEffectView.alpha = 0.1
        
        // Setting the autoresizing mask to flexible for
        // width and height will ensure the blurEffectView
        // is the same size as its parent view.
        blurEffectView.autoresizingMask = [
            .flexibleWidth, .flexibleHeight
        ]
        
        return blurEffectView
    }()
    
    //외부에서 접근 가능
    func setUpNotification(notificationText:String){
        self.notification = CustomNotificationView(notificationText: notificationText)
        self.view.addSubview(notification ?? CustomNotificationView(notificationText: "error"))
        notification?.translatesAutoresizingMaskIntoConstraints = false
        notification?.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 15).isActive = true
        notification?.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -15).isActive = true
        notification?.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: self.view.frame.height/64).isActive = true
        notification?.heightAnchor.constraint(greaterThanOrEqualToConstant: self.view.frame.height/16).isActive = true
        let seconds = 2.5
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds) { [self] in
            UIView.animate(withDuration: 1.0, delay: 0.0, options: UIView.AnimationOptions.curveEaseIn, animations: {
                self.notification!.alpha = 0.0
                }) { _ in
                self.notification!.removeFromSuperview()
                }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.black.withAlphaComponent(0.2)
        
        
        // Add the blurEffectView with the same
        // size as view
        blurEffectView.frame = self.view.bounds
        view.insertSubview(blurEffectView, at: 0)
        
        // Add the loadingActivityIndicator in the
        // center of view
        loadingActivityIndicator.center = CGPoint(
            x: view.bounds.midX,
            y: view.bounds.midY
        )
        view.addSubview(loadingActivityIndicator)
    }
    
}
