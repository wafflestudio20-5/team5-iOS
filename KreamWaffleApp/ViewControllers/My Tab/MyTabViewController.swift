//
//  MyTabViewController.swift
//  KreamWaffleApp
//
//  Created by 이선재 on 2022/12/25.
//
import UIKit
import BetterSegmentedControl

//와플 사진 Url: https://wimg.mk.co.kr/meet/neds/2021/06/image_readtop_2021_567569_16233998554678633.jpg

class MyTabViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        //shoeScreen.modalPresentationStyle = .fullScreen
        let loginScreen = LoginViewController()
        let profile = ProfileViewController()
        loginScreen.modalPresentationStyle = .fullScreen
        self.present(loginScreen, animated: false)
        
        setUpSegmentedControl()
    }
    
    func setUpSegmentedControl() {
        let control = BetterSegmentedControl(
            frame: CGRect(x: 0, y: 0, width: view.bounds.width/2 - 32.0, height: 30),
            segments: LabelSegment.segments(withTitles: ["내 쇼핑", "내 프로필"],
                                            normalFont: .boldSystemFont(ofSize: 17.0),
                                            normalTextColor: .lightGray,
                                            selectedFont: .boldSystemFont(ofSize: 17.0),
                                            selectedTextColor: .black
                                           ),
            options: [.backgroundColor(.white),
                      .indicatorViewBackgroundColor(.white),
                      .cornerRadius(3.0),
                      .animationSpringDamping(1.0)]
        )

        control.addTarget(
            self,
            action: #selector(navigationSegmentedControlValueChanged(_:)),
            for: .valueChanged)

        control.sizeToFit()
        navigationItem.titleView = control
    }
    
    @objc func navigationSegmentedControlValueChanged(_ sender: BetterSegmentedControl) {
        //***** !! To 은혜님 !! ******
        // 여기서 어떤 뷰컨 숨기고 어떤 뷰컨 드러낼지 설정하시면 됩니다!
        if sender.index == 0 {
            print("Turning lights on.")
            view.backgroundColor = .white
        } else {
            print("Turning lights off.")
            view.backgroundColor = .darkGray
        }
    }
}
