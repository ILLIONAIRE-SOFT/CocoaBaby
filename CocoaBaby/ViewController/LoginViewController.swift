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


class LoginViewController: UIViewController, GIDSignInUIDelegate {
    
    @IBOutlet var facebookLoginButton: FBSDKLoginButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.mainPinkColor
    
        GIDSignIn.sharedInstance().uiDelegate = self
    }
    
    // MARK: - IBActions
    @IBAction func tappedLoginWithGoogle(_ sender: UIButton) {
        print("LoginViewController - tapped google login")
        GIDSignIn.sharedInstance().signIn()
    }
    
    @IBAction func tappedLoginWithFacebook(_ sender: Any) {
        let facebookLoginManager = FBSDKLoginManager()
        facebookLoginManager.logIn(withPublishPermissions: [], from: self) {
            (result, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            if let result = result {
                if result.isCancelled {
                    print("Cancelled")
                    return
                }
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
    }

}
