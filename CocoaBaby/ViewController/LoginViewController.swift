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
        
//        if Auth.auth().currentUser != nil {
//            
//        } else {
//            GIDSignIn.sharedInstance().signIn()
//        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if Auth.auth().currentUser != nil {
            let appDelegate = UIApplication.shared.delegate! as! AppDelegate
            
            let initialViewController = self.storyboard!.instantiateViewController(withIdentifier: "mainTabBarViewController")
            appDelegate.window?.rootViewController = initialViewController
            appDelegate.window?.makeKeyAndVisible()
            
        } else {
//            GIDSignIn.sharedInstance().signIn()
        }
        
    }
}
