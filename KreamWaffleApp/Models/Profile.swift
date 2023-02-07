//
//  Profile.swift
//  KreamWaffleApp
//
//  Created by 최성혁 on 2023/01/21.
//

import Foundation
import UIKit
import Kingfisher

final class Profile: Codable {
    private enum CodingKeys: String, CodingKey {
        case user_id, user_name, profile_name, introduction, image, num_followers, num_followings, following, num_posts
    }
    
    let user_id: Int
    let user_name: String
    let profile_name: String
    let introduction: String
    let image: String
    let num_posts : Int
    let num_followers: Int
    let num_followings: Int
    let following: String?
    var updatedImage : UIImage? //Photopicker 에서 이미지 보낼때.
    
    init(
        user_id: Int,
        user_name: String,
        profile_name: String,
        introduction: String,
        image: String?,
        num_posts : Int,
        num_followers: Int,
        num_followings: Int,
        following: String
    ) {
        self.user_id = user_id
        self.user_name = user_name
        self.profile_name = profile_name
        self.introduction = introduction
        self.image = image ?? ""
        self.num_posts = num_posts
        self.num_followers = num_followers
        self.num_followings = num_followings
        self.following = following
        var stringToImage = UIImage()
        if let url = URL.init(string: self.image) {
        let resource = ImageResource(downloadURL: url)
        KingfisherManager.shared.retrieveImage(with: resource, options: nil, progressBlock: nil) { result in
                switch result {
                case .success(let value):
                    print("Bringing image success")
                    stringToImage = value.image
                    //self.updatedImage = value.image as UIImage
                case .failure(_):
                    let personImage = UIImage(systemName: "person.crop.circle.fill")
                    //let image = UIImage(systemName: "person.crop.circle.fill")!
                    personImage?.withRenderingMode(.alwaysTemplate)
                    //green 이면 여기서 난 것
                    personImage?.withTintColor(colors.accentGreen)
                    stringToImage = personImage!
                    //self.updatedImage = image
                }
            }
        } else {
            let personImage = UIImage(systemName: "person.crop.circle.fill")
            //let image = UIImage(systemName: "person.crop.circle.fill")!
            personImage?.withRenderingMode(.alwaysTemplate)
            //green 이면 여기서 난 것
            personImage?.withTintColor(colors.accentGreen)
            stringToImage = personImage!
            //self.updatedImage = image
        }
        
        self.updatedImage = stringToImage
    }
    
    //ERROR: called when login with nil profile account.
    init() {
        self.user_id = 0
        self.user_name = "-"
        self.profile_name = "-"
        self.introduction = "-"
        self.image = ""
        self.num_followers = 0
        self.num_followings = 0
        self.following = nil
        self.num_posts = 0
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        user_id = try container.decodeIfPresent(Int.self, forKey: .user_id) ?? -1
        user_name = try container.decodeIfPresent(String.self, forKey: .user_name) ?? "-"
        profile_name = try container.decodeIfPresent(String.self, forKey: .profile_name) ?? "-"
        introduction = try container.decodeIfPresent(String.self, forKey: .introduction) ?? "-"
        image = try container.decodeIfPresent(String.self, forKey: .image) ?? ""
        num_followers = try container.decodeIfPresent(Int.self, forKey: .num_followers) ?? 0
        num_followings = try container.decodeIfPresent(Int.self, forKey: .num_followings) ?? 0
        num_posts = try container.decodeIfPresent(Int.self, forKey: .num_posts) ?? 0
        do {
            let strFollowing = try container.decodeIfPresent(String.self, forKey: .following)
            self.following = strFollowing
        } catch {
            do {
                let boolFollowing: Bool = try container.decodeIfPresent(Bool.self, forKey: .following) ?? false
                self.following = boolFollowing ? "true" : "false"
            } catch {
                self.following = "false"
                print(error)
            }
        }    }
    
    func getImage(imageString: String) -> UIImage? {
        var image = UIImage()
        if let url = URL.init(string: imageString) {
        let resource = ImageResource(downloadURL: url)
        KingfisherManager.shared.retrieveImage(with: resource, options: nil, progressBlock: nil) { result in
                switch result {
                case .success(let value):
                    print("Bringing image success")
                    image = value.image
                    //self.updatedImage = value.image as UIImage
                case .failure(_):
                    let personImage = UIImage(systemName: "person.crop.circle.fill")
                    //let image = UIImage(systemName: "person.crop.circle.fill")!
                    personImage?.withRenderingMode(.alwaysTemplate)
                    //green 이면 여기서 난 것
                    personImage?.withTintColor(colors.accentGreen)
                    image = personImage!
                    //self.updatedImage = image
                }
            }
        } else {
            let personImage = UIImage(systemName: "person.crop.circle.fill")
            //let image = UIImage(systemName: "person.crop.circle.fill")!
            personImage?.withRenderingMode(.alwaysTemplate)
            //green 이면 여기서 난 것
            personImage?.withTintColor(colors.accentGreen)
            image = personImage!
            //self.updatedImage = image
        }
        return image
    }
}
