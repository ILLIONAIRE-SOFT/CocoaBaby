//
//  LoginViewController.swift
//  CocoaBaby
//
//  Created by Sohn on 10/08/2017.
//  Copyright © 2017 Sohn. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn

class LoginViewController: UIViewController, GIDSignInUIDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        GIDSignIn.sharedInstance().uiDelegate = self
    }
    
    // MARK: - IBActions
    @IBAction func tappedLoginWithGoogle(_ sender: UIButton) {
        print("LoginViewController - tapped google login")
        GIDSignIn.sharedInstance().signIn()
    }

}
