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
    
    struct Constants{
         static let clientID = ConfigClientID
         static let clientSecret = ConfigClientSecret
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
        complettion: @escaping ((Bool) -> Void)
    ) {
        // make api request to get token
    }
    
    public func refreshAccessToken() {
        
    }
    
    private func cacheToken() {
        
    }
}


