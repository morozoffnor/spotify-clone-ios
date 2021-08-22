//
//  WelcomeViewController.swift
//  spotify clone
//
//  Created by Игорь Морозов on 18.08.2021.
//

import UIKit

class WelcomeViewController: UIViewController {
    
    private let signInButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .white
        button.setTitle("Sign in with Spotify", for: .normal)
        button.setTitleColor(.black, for: .normal)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Spotify clone baby"
        // view background color
        view.backgroundColor = .systemGreen
        
        // adding button to the view
        view.addSubview(signInButton)
        
        // setting "an action" for the button
        signInButton.addTarget(self, action: #selector(didTapSignIn), for: .touchUpInside)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // creating a frame for the button
        signInButton.frame = CGRect(
            x: 20,
            y: view.height-50-view.safeAreaInsets.bottom,
            width: view.width-40,
            height: 50
        )
        
    }
    
    @objc func didTapSignIn() {
        let vc = AuthViewController()
        
        // store the bool if the user has signed in
        vc.completionHandler = { [weak self ] succsess in
            DispatchQueue.main.async {
                self?.handleSignIn(success: succsess)
            }
        }
        vc.navigationItem.largeTitleDisplayMode = .never
        
        // push to another view controller with animation
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func handleSignIn(success: Bool) {
        // Log user in or thow error
        guard success else {
            // createing alert if something goes wrong when signing in
            let alert = UIAlertController(title: "Ooops", message: "Something went wrong", preferredStyle: .alert)
            // adding a button to the alert
            alert.addAction(UIAlertAction(title: "Pohi", style: .cancel, handler: nil))
            // presenting it
            present(alert, animated: true)
            return
        }
        // if everything is okay:
        let mainAppTabBarVC = TabBarViewController()
        mainAppTabBarVC.modalPresentationStyle = .fullScreen
        present(mainAppTabBarVC, animated: true)
    }

}
