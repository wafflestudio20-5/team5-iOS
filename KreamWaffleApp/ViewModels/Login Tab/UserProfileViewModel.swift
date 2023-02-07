//
//  UserProfileViewModel.swift
//  KreamWaffleApp
//
//  Created by grace on 2023/02/01.
//

import Foundation
import RxRelay
import UIKit
import RxSwift
import Kingfisher

class UserProfileViewModel {
    
    let usecase : UserUsecase
    let bag = DisposeBag()
    
    //var imageRelay : BehaviorRelay<UIImage>
    var profileNameRelay =  BehaviorRelay<String>.init(value: "")
    var userNameRelay =  BehaviorRelay<String>.init(value: "")
    var bioRelay =  BehaviorRelay<String>.init(value: "")
    var imageRelay =  BehaviorRelay<UIImage>.init(value: UIImage())
    
    //저장 버튼 탭 저장하는 릴레이 (각자의 저장 버튼을 누르면 tap Relay 가 그걸 받고, Profile edit VC가 그것을 보고 알아서 맞는 값을 위 릴레이에서 할당해준다.
    var tapRelay = BehaviorRelay<editCase>(value: .none)
    
    //image change 할때마다 true 값을 받고, 그렇다면 my tab 에서 캐시값으로 이미지 세팅을 한다. 
    var imageChangeRelay = BehaviorRelay<Bool>(value: false)
    
    init(usecase: UserUsecase) {
        self.usecase = usecase
        self.bindIndividualRelays()
    }
    
    var userProfile: Profile {
        get {
            return self.usecase.userProfile ?? Profile(user_id: 0, user_name: "", profile_name: "nil_profile", introduction: "", image: "", num_followers: 0, num_followings: 0, following: "")
        }
    }
    
    //프로필 수정 탭에서 이용될 relay
    func bindIndividualRelays(){
        userProfileDataSource.subscribe { [weak self] event in
            let image = self?.getImage(with: event.element?.image ?? "")
            self?.imageRelay.accept(image!)
            self?.userNameRelay.accept(event.element?.user_name ?? "")
            self?.bioRelay.accept(event.element?.introduction ?? "")
            self?.profileNameRelay.accept(event.element?.profile_name ?? "")
        }.disposed(by: bag)
    }
    
    //이거 공용 함수로 만들어도 되지 않을까?
    func getImage(with imageString: String) -> UIImage {
        var image = UIImage()
        if let url = URL.init(string: imageString) {
        let resource = ImageResource(downloadURL: url)
        KingfisherManager.shared.retrieveImage(with: resource, options: nil, progressBlock: nil) { result in
                switch result {
                case .success(let value):
                    print("Bringing image success")
                    image = value.image as UIImage
                case .failure(_):
                    image = UIImage(systemName: "person.crop.circle.fill")!
                    image.withRenderingMode(.alwaysTemplate)
                    image.withTintColor(colors.lessLightGray)
                }
            }
        } else {
            image = UIImage(systemName: "person.crop.circle.fill")!
            image.withRenderingMode(.alwaysTemplate)
            image.withTintColor(colors.lessLightGray)
        }
        
        return image
    }

    
    var userProfileDataSource: Observable<Profile> {
        get {
            return self.usecase.profileRelay.asObservable()
        }
    }
    
    func requestUserProfile(onNetworkFailure: @escaping ()->()){
        self.usecase.requestProfile(onNetworkFailure: onNetworkFailure)
    }
    
    //post
    func editProfile(Profile: Profile){
        self.usecase.updateProfile(Profile: Profile)
    }
    
    //patch (for only text related fields)
    func partialEditProfile(newValue: String, editCase: editCase){
        self.usecase.updatePartialProfile(newValue: newValue, editCase: editCase)
    }
    
    //patch
    func editProfileImage(newImage: UIImage){
        self.usecase.updateProfileImage(newImage: newImage)
    }
}
