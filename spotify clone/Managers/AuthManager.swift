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
    
    struct Constants {
        static let clientID = ConfigClientID
        static let clientSecret = ConfigClientSecret
        static let tokenApiUrl = "https://accounts.spotify.com/api/token"
    }
    
    private init() {}
    
    // constructing the URL for AuthViewController
    public var signInUrl: URL? {
        
        let base = "https://accounts.spotify.com/authorize"
        let scope = "user-read-private"
        let redirectUri = "https://google.com"
        let string = "\(base)?response_type=code&client_id=\(Constants.clientID)&scope=\(scope)&redirect_uri=\(redirectUri)&show_dialog=true"
        
        return URL(string: string)
    }
    
    var isSignedIn: Bool {
        return false
    }
    
    private var accessToken: String? {
        return nil
    }
    
    private var refreshToken: String? {
        return nil
    }
    
    private var tokenExpirationDate: Date? {
        return nil
    }
    
    private var shouldReffreshToken: Bool {
        return false
    }
    
    public func exchangeCodeForToken(
        code: String,
        completion: @escaping ((Bool) -> Void)
    ) {
        
        // MARK: make api request
        
        guard let url = URL(string: Constants.tokenApiUrl) else {
            return
        }
        
        // construct query
        var components = URLComponents()
        components.queryItems = [
            URLQueryItem(name: "grant_type", value: "authorization_code"),
            URLQueryItem(name: "code", value: code),
            URLQueryItem(name: "redirect_url", value: "https://google.com")
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
        
        let task = URLSession.shared.dataTask(with: request) { data, _, error in
            // if data doesn't exist or there is an error - completion = false
            guard let data = data, error == nil else {
                completion(false)
                return
            }
            // otherwise go and try
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                print("success: \(json)")
            }
            catch {
                print(error.localizedDescription)
                completion(false)
            }
        }
        task.resume()
    }
    
    public func refreshAccessToken() {
        
    }
    
    private func cacheToken() {
        
    }
}


