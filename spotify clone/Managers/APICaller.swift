//
//  APICaller.swift
//  spotify clone
//
//  Created by Игорь Морозов on 18.08.2021.
//

import Foundation

final class APICaller {
    static let shared = APICaller()
    
    private init() {}
    
    struct Constants {
        static let baseApiUrl = "https://api.spotify.com/v1"
    }
    
    enum apiError: Error {
        case failedToGetData
    }
    public func getCurrentUserProfile(completion: @escaping (Result<UserProfile, Error>) -> Void) {
        createRequest(with: URL(string: Constants.baseApiUrl + "/me"), type: .GET) { baseRequest in
            // get data
            let task = URLSession.shared.dataTask(with: baseRequest) { data, _ , error in
                guard let data = data, error == nil else {
                    // if failed
                    completion(.failure(apiError.failedToGetData))
                    return
                }
                
                do {
                    let result = try JSONDecoder().decode(UserProfile.self, from: data)
                    print(result)
                }
                catch {
                    print(error.localizedDescription)
                    completion(.failure(error))
                }
                
            }
            task.resume()
        }
    }
    
    // enum for http methods
    enum Method: String {
        case GET
        case POST
    }
    
    // create a generic request which will be used for everything else to build on top of
    private func createRequest(with url: URL?, type: Method, completion: @escaping (URLRequest) -> Void) {
        AuthManager.shared.withValidToken { token in
            guard let apiURL = url else {
                return
            }
            var request = URLRequest(url: apiURL)
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            request.httpMethod = type.rawValue
            request.timeoutInterval = 30
            
            completion(request)
        }
        
    }
}
