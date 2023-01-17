//
//  RegisterRepository.swift
//  KreamWaffleApp
//
//  Created by grace kim  on 2023/01/04.
//


import Foundation
import RxSwift
import RxCocoa
import Alamofire

#if canImport(FoundationNetworking)
import FoundationNetworking
import UIKit
//import XCTest
#endif


///wraps up database, networking, and data source handling logic for registering account
class LoginRepository {
    
    private var semaphore = DispatchSemaphore (value: 0)
    private let apiKey = "f330b07acf479c98b184db47a4d2608b" //for Naver
    private let baseAPIURL = "https://kream-waffle.cf/accounts"
    private let urlSession = URLSession.shared
    private let userDefaults = UserDefaults.standard
    
    init() {}
    
    //save or get saved user from defaults
    func saveUser(user: User) {
        userDefaults.set(try? PropertyListEncoder().encode(user), forKey: "savedUser")
       }
    
    func getUser()->User?{
        if let storedObject: Data = UserDefaults.standard.object(forKey: "savedUser") as? Data {
                    return try? PropertyListDecoder().decode(User.self, from: storedObject)
            }
        return nil
    }
    
    func logOutUser(){
        userDefaults.removeObject(forKey: "savedUser")
    }
       
    //login with custom or social
    func loginAccount(email: String, password: String, completion: @escaping (Result<UserResponse, LoginError>) -> ()){
        
        let URLString = "\(baseAPIURL)/login/"
        guard let url = URL(string: URLString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!) else {
            print("url error")
            return
        }
        
        let headers : HTTPHeaders = [
            .contentType("application/json")
        ]
        
        let parameters = [
            "email": email,
            "password": password,
        ]
        
        AF.request(url, method: .post, parameters: parameters, encoder: JSONParameterEncoder.default, headers: headers).response{ response in
            switch response.result {
            case .success(let data):
                do{
                    let results : UserResponse = try JSONDecoder().decode(UserResponse.self, from: data!)
                    self.saveUser(user: results.user)
                    print("LoginRepository: User is", results.user)
                    completion(.success(results))
                }catch{
                    completion(.failure(.unknownError))
                }
                
            case .failure(let error):
                let json = String(data: response.data!, encoding: String.Encoding.utf8)
                let loginError = checkErrorMessage(String(describing: json))
                completion(.failure(loginError))
                print(error)
            }
            
        }
    }
          
    
    func registerAccount(with email: String, password: String, shoe_size: Int, completion: @escaping (Result<Bool, LoginError>) -> ()){
        let URLString = "\(baseAPIURL)/registration/"
        guard let url = URL(string: URLString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)  else {
            print("url error")
            return
        }
        
        let headers : HTTPHeaders = [
            .contentType("application/json")
        ]
        
        let parameters = [
            "email": email,
            "password1": password,
            "password2": password,
            "shoe_size": shoe_size,
        ] as [String : Any]
        
        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).response{ response in
            switch response.result {
            case .success(let data):
                do{
                    completion(.success(true))
                }catch{
                    completion(.failure(.signupError))
                }
                
            case .failure(let error):
                //TODO 에러 종류 바꾸기
                completion(.failure(.signupError))
                print(error)
            }
        }
        }
    
    ///with Naver's access token, get user info from custom server
    func loginWithNaver(naverToken: String, completion: @escaping (Result<UserResponse, LoginError>) -> ()){
        
        let URLString = "\(baseAPIURL)/social/naver?token=\(naverToken)"
        guard let url = URL(string: URLString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)  else {
            print("url error")
            return
        }
        
        AF.request(url, method: .get, parameters: nil, encoding: URLEncoding.httpBody, headers: nil).response{ response in
            switch response.result {
            case .success(let data):
                do{
                    let results : UserResponse = try JSONDecoder().decode(UserResponse.self, from: data!)
                    self.saveUser(user: results.user)
                    print("LoginRepository: User is", results.user)
                    completion(.success(results))
                }catch{
                    completion(.failure(.unknownError))
                }
                
            case .failure(let error):
                //let json = String(data: response.data!, encoding: String.Encoding.utf8)
                //let loginError = checkErrorMessage(String(describing: json))
                completion(.failure(.unknownError))
                print(error)
            }
            
        }
    }
    
    func loginWithGoogle(googleToken: String, completion: @escaping (Result<UserResponse, LoginError>) -> ()){
        
        let URLString = "\(baseAPIURL)/social/google?token=\(googleToken)"
        guard let url = URL(string: URLString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)  else {
            print("url error")
            return
        }
        
        AF.request(url, method: .get, parameters: nil, encoding: URLEncoding.httpBody, headers: nil).response{ response in
            switch response.result {
            case .success(let data):
                do{
                    let results : UserResponse = try JSONDecoder().decode(UserResponse.self, from: data!)
                    self.saveUser(user: results.user)
                    print("LoginRepository: User is", results.user)
                    completion(.success(results))
                }catch{
                    completion(.failure(.unknownError))
                }
                
            case .failure(let error):
                completion(.failure(.unknownError))
                print(error)
            }
            
        }
    }
}
   

