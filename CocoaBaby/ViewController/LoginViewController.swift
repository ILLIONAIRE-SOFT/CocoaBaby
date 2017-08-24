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
import FBSDKLoginKit


class LoginViewController: BaseViewController, GIDSignInUIDelegate, FBSDKLoginButtonDelegate {
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let loginButton = FBSDKLoginButton()
        loginButton.delegate = self
        loginButton.center = view.center
        view.addSubview(loginButton)
        
        loginButton.addTarget(self, action: #selector(tappedFacebookLogin(_:)), for: .touchUpInside)
        GIDSignIn.sharedInstance().uiDelegate = self
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func tappedFacebookLogin(_ sender: UIButton) {
        self.startLoading()
    }
    
    // MARK: - IBActions
    @IBAction func tappedLoginWithGoogle(_ sender: UIButton) {
        print("LoginViewController - tapped google login")
        GIDSignIn.sharedInstance().signIn()
    }
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error?) {
        if let error = error {
            print(error.localizedDescription)
            return
        }
        
        guard !result.isCancelled else {
            self.stopLoading()
            return
        }
        
        
        let credential = FacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
        
        Auth.auth().signIn(with: credential) { (user, error) in
            if let error = error {
                print(error)
                return
            }
            
            let mainSB = UIStoryboard(name: StoryboardName.main, bundle: nil)
            let viewController = mainSB.instantiateViewController(withIdentifier: StoryboardName.splashViewController)
            
            let appDelegate = UIApplication.shared.delegate! as! AppDelegate
            
            self.stopLoading()
            appDelegate.window?.rootViewController = viewController
            appDelegate.window?.makeKeyAndVisible()
            
            if let uid = Auth.auth().currentUser?.uid {
                let babyRef = Database.database().reference(withPath: "babies/\(uid)")
                babyRef.keepSynced(true)
                
                let diaryRef = Database.database().reference(withPath: "diaries/\(uid)")
                diaryRef.keepSynced(true)
            }
        }
    }

    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        
    }


}
