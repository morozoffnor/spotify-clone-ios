//
//  AuthManager.swift
//  spotify clone
//
//  Created by Игорь Морозов on 18.08.2021.
//

import Foundation


final class AuthManager {
    static let shared = AuthManager()
    
    private init() {}
    
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
}
