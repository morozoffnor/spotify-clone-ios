//
//  AuthManager.swift
//  spotify clone
//
//  Created by Игорь Морозов on 18.08.2021.
//

import Foundation
import SwiftyJSON



final class AuthManager {
    static let shared = AuthManager()
    
    private var refreshingToken = false
    
    struct Constants {
        static let clientID = ConfigClientID
        static let clientSecret = ConfigClientSecret
        static let tokenApiUrl = "https://accounts.spotify.com/api/token"
        static let scopes = "playlist-modify-private%20playlist-read-private%20playlist-modify-public%20user-read-private%20user-follow-read%20user-library-modify%20user-library-read%20user-read-email"
    }
    
    private init() {}
    
    // constructing the URL for AuthViewController
    public var signInUrl: URL? {
        
        let base = "https://accounts.spotify.com/authorize"
        let redirectUri = "https://google.com"
        let string = "\(base)?response_type=code&client_id=\(Constants.clientID)&scope=\(Constants.scopes)&redirect_uri=\(redirectUri)&show_dialog=true"
        
        return URL(string: string)
    }
    
    var isSignedIn: Bool {
        return accessToken != nil
    }
    
    private var accessToken: String? {
        return UserDefaults.standard.string(forKey: "access_token")
    }
    
    private var refreshToken: String? {
        return UserDefaults.standard.string(forKey: "refresh_token")
    }
    
    private var tokenExpirationDate: Date? {
        return UserDefaults.standard.object(forKey: "expiration_date") as? Date
    }
    
    private var shouldReffreshToken: Bool {
        guard let expirationDate = tokenExpirationDate else {
            return false
        }
        let interval: TimeInterval = 300 // 5 minutes
        let currentDate = Date()
        // if it is bigger then go and refresh
        return currentDate.addingTimeInterval(interval) >= expirationDate
    }
    
    public func exchangeCodeForToken(
        code: String,
        completion: @escaping ((Bool) -> Void)
    ) {
        
        // MARK: Get token
        
        guard let url = URL(string: Constants.tokenApiUrl) else {
            return
        }
        
        // construct query
        var components = URLComponents()
        components.queryItems = [
            URLQueryItem(name: "grant_type", value: "authorization_code"),
            URLQueryItem(name: "code", value: code),
            URLQueryItem(name: "redirect_uri", value: "https://google.com")
        ]
        
        // assign everything to the request
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpBody = components.query?.data(using: .utf8)
        
        // Base64 encoded Authorization header
        let basicToken = Constants.clientID+":"+Constants.clientSecret
        let data = basicToken.data(using: .utf8)
        guard let base64String = data?.base64EncodedString() else {
            print("Failed to get base64")
            completion(false)
            return
        }
        request.setValue("Basic \(base64String)", forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request) { [weak self] data, _, error in
            // if data doesn't exist or there is an error - completion = false
            guard let data = data, error == nil else {
                completion(false)
                return
            }
            // otherwise go and try
            do {
                // decode json into the model and then 		cache it
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let json = try JSONDecoder().decode(AuthResponse.self, from: data)
                
                self?.cacheToken(result: json)
                completion(true)
            }
            catch {
                print(error.localizedDescription)
                completion(false)
            }
        }
        task.resume()
    }
    
    // form a "queue" of requests
    private var onRefreshBlocks = [((String) -> Void)]()
    
    // MARK: Check token
    
    // used every api call to get valid token
    public func withValidToken(completion: @escaping (String) -> Void) {
        guard !refreshingToken else {
            // append the completeion block
            onRefreshBlocks.append(completion)
            return
        }
        if shouldReffreshToken {
            // refresh if it's going to expire soon
            refreshIfNeeded { [weak self] success in
                if let token = self?.accessToken, success {
                    completion(token)
                }
            }
        }
        else if let token = accessToken {
            // return token if it's valid
            completion(token)
        }
    }
    
    // MARK: Refresh token
    
    public func refreshIfNeeded(completion: ((Bool) -> Void)?) {
        // dont refresh if it is already refreshing
        guard !refreshingToken else {
            return
        }
        
        guard shouldReffreshToken else {
            completion?(true)
            return
        }
        guard let refreshToken = self.refreshToken else {
            return
        }
        
        // refresh the token
        guard let url = URL(string: Constants.tokenApiUrl) else {
            return
        }
        
        // change the state
        refreshingToken = true
        
        // construct query
        var components = URLComponents()
        components.queryItems = [
            URLQueryItem(name: "grant_type", value: "refresh_token"),
            URLQueryItem(name: "refresh_token", value: refreshToken)
        ]
        
        // assign everything to the request
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpBody = components.query?.data(using: .utf8)
        
        // Base64 encoded Authorization header
        let basicToken = Constants.clientID+":"+Constants.clientSecret
        let data = basicToken.data(using: .utf8)
        guard let base64String = data?.base64EncodedString() else {
            print("Failed to get base64")
            completion?(false)
            return
        }
        request.setValue("Basic \(base64String)", forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request) { [weak self] data, _, error in
            // change state whether succeded or not
            self?.refreshingToken = false
            // if data doesn't exist or there is an error - completion = false
            guard let data = data, error == nil else {
                completion?(false)
                return
            }
            // otherwise go and try
            do {
                // decode json into the model
                let result = try JSONDecoder().decode(AuthResponse.self, from: data)
                
                // execute everything from queue
                self?.onRefreshBlocks.forEach { $0(result.access_token) }
                
                // remove everything from queue
                self?.onRefreshBlocks.removeAll()
                
                // cache the token
                self?.cacheToken(result: result)
                completion?(true)
            }
            catch {
                print(error.localizedDescription)
                completion?(false)
            }
        }
        task.resume()
    }
    
    private func cacheToken(result: AuthResponse) {
        UserDefaults.standard.setValue(result.access_token, forKey: "access_token")
        if let refresh_token = result.refresh_token {
            UserDefaults.standard.setValue(refresh_token, forKey: "refresh_token")
        }
        // expiration date = time user logged in + "expires_in"
        UserDefaults.standard.setValue(Date().addingTimeInterval(TimeInterval(result.expires_in)), forKey: "expiration_date")
    }
}


