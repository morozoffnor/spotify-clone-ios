//
//  AuthViewController.swift
//  spotify clone
//
//  Created by Игорь Морозов on 18.08.2021.
//

import UIKit
import WebKit
import Foundation

class AuthViewController: UIViewController, WKNavigationDelegate {
    
    private let webView: WKWebView = {
        
        // allow JavaScript on page
        let prefs = WKWebpagePreferences()
        prefs.allowsContentJavaScript = true
        
        // put prefs into config
        let config = WKWebViewConfiguration()
        config.defaultWebpagePreferences = prefs
        
        // create a webview with config
        let webView = WKWebView(frame: .zero, configuration: config)
        
        return webView
    }()
    
    public var completionHandler: ((Bool) -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Sign in"
        view.backgroundColor = .systemBackground
        
        // adding nav delegate just in case of redirect or error
        webView.navigationDelegate = self
        view.addSubview(webView)
        
        guard let url = AuthManager.shared.signInUrl else {
            return
        }
        webView.load(URLRequest(url: url))
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        webView.frame = view.bounds
        
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        guard let url = webView.url else {
            return
        }
        // Exchange the code Spotify give us for access token
        let component = URLComponents(string: url.absoluteString)
        
        // get the "code" in the query
        // everything here is optional :)
        guard let code = component?.queryItems?.first(where: { $0.name == "code" })?.value else {
            return
        }
        
        // for test perpose only. will remove later
        print("Code: \(code)")
    }
    
}
