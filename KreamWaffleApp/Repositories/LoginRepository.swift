//
//  RegisterRepository.swift
//  KreamWaffleApp
//
//  Created by grace kim  on 2023/01/04.
//


import Foundation
import RxSwift
import RxCocoa

#if canImport(FoundationNetworking)
import FoundationNetworking
import UIKit
//import XCTest
#endif


///wraps up database, networking, and data source handling logic for registering account
class LoginRepository {
    
    private var semaphore = DispatchSemaphore (value: 0)
    private let apiKey = "f330b07acf479c98b184db47a4d2608b"
    private let baseAPIURL = "https://kream-waffle.cf/accounts"
    private let urlSession = URLSession.shared
    
    init() {}
    
    func loginAccount(email: String, password: String, completion: @escaping (Result<UserReponse, Error>) -> ()){
        
        let URLString = "\(baseAPIURL)/accounts/login"
        print(URLString)
        guard let url = URL(string: URLString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)  else {
            print("url error")
            return
        }
        
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "accept")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.method = .get
        
        let task = urlSession.dataTask(with: request) { data, response, error in
                guard error == nil else {
                    print(String(describing: error))
                    return }
                guard let data = data else {
                    self.semaphore.signal()
                    return
                }
                do {
                    print(data)
                    let results : UserReponse = try JSONDecoder().decode(UserReponse.self, from: data)
                    completion(.success(results))
                    print("getting is completed in repository")
                    self.semaphore.signal()
                    } catch {
                    completion(.failure(error))
                    print("problem is here")
                    print(error.localizedDescription)
                }
                }
                task.resume()
                self.semaphore.wait()
    }
    
    
    func registerAccount(with email: String, password: String, shoe_size: Int){
        let URLString = "\(baseAPIURL)/registration/"
        guard let url = URL(string: URLString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)  else {
            print("url error")
            return
        }
        
        //TODO: request X-CSRFT token first?
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "accept")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        //request.setValue("CDZtko1uXdwHLfx26ArX3oW43yQxtGjTft3MSfHl8aOZAWdinyIpHG5K7xxLKGYM", forHTTPHeaderField: "X-CSRFToken")
        request.method = .post
        
        let parameters: [String: Any] = [
            "email": email,
            "password1": password,
            "password2": password,
            "shoe_size": shoe_size,
        ]
        
        do {
            // convert parameters to Data and assign dictionary to httpBody of request
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
          } catch let error {
            print(error.localizedDescription)
            return
          }
        
        // create dataTask using the session object to send data to the server
          let task = urlSession.dataTask(with: request) { data, response, error in
            
            if let error = error {
              print("Post Request Error: \(error.localizedDescription)")
              return
            }
    
            // ensure there is valid response code returned from this HTTP response
              /*
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode)
            else {
              print("Invalid Response received from the server")
                print(response as Any)
              return
            }*/
            
            // ensure there is data returned
            guard let responseData = data else {
              print("nil Data received from the server")
              return
            }
              
            
            do {
              // create json object from data or use JSONDecoder to convert to Model stuct
              if let jsonResponse = try JSONSerialization.jsonObject(with: responseData, options: .mutableContainers) as? [String: Any] {
                print(jsonResponse)
                // handle json response
              } else {
                print("data maybe corrupted or in wrong format")
                throw URLError(.badServerResponse)
              }
            } catch let error {
              print(error.localizedDescription)
            }
          }
          // perform the task
          task.resume()
        self.semaphore.wait()
        }
    
    ///with Naver's access token, get user info from custom server
    func loginWithNaver(naverToken: String, completion: @escaping (Result<UserReponse, Error>) -> ()){
        
        let URLString = "\(baseAPIURL)/accounts/social/naver?token=\(naverToken)"
        print(URLString)
        guard let url = URL(string: URLString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)  else {
            print("url error")
            return
        }
        
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "accept")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.method = .get
        
        let task = urlSession.dataTask(with: request) { data, response, error in
                guard error == nil else {
                    print(String(describing: error))
                    return }
                guard let data = data else {
                    self.semaphore.signal()
                    return
                }
                do {
                    print(data)
                    let results : UserReponse = try JSONDecoder().decode(UserReponse.self, from: data)
                    completion(.success(results))
                    print("getting is completed in repository")
                    self.semaphore.signal()
                    } catch {
                    completion(.failure(error))
                    print("problem is here")
                    print(error.localizedDescription)
                }
                }
                task.resume()
                self.semaphore.wait()
    }
}
   

