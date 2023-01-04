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
    private let baseAPIURL = "https://api.themoviedb.org/3"
    private let urlSession = URLSession.shared
    
    init() {}
    
    /*
    func registerAccount(with email: String, password: String, completion: Bool){
        let URLString = "\(baseAPIURL)/movie/\(endpoint.rawValue)?api_key=\(apiKey)&language=en-US&page=\"
        guard let url = URL(string: URLString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)  else {
            completion(.failure(.invalidEndPoint))
            print("url error")
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
        guard error == nil else {
            print(String(describing: error))
            return }
        guard let data = data else {
            self.semaphore.signal()
            return
        }
        do {
            let results : MovieResponse = try JSONDecoder().decode(MovieResponse.self, from: data)
            completion(.success(results))
            self.semaphore.signal()
            } catch {
            print(error.localizedDescription)
        }
        }
        task.resume()
        self.semaphore.wait()
    }*/
   
}
