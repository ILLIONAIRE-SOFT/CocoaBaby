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
    
    var overlay: UIView?
    var activityIndicator: UIActivityIndicatorView?
    
    @IBOutlet var facebookLoginButton: FBSDKLoginButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        GIDSignIn.sharedInstance().uiDelegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.view.backgroundColor = UIColor.mainPinkColor
    }
    
    // MARK: - IBActions
    @IBAction func tappedLoginWithGoogle(_ sender: UIButton) {
        print("LoginViewController - tapped google login")
        GIDSignIn.sharedInstance().signIn()
    }
    
    @IBAction func tappedLoginWithFacebook(_ sender: Any) {
        let facebookLoginManager = FBSDKLoginManager()
        self.startLoading()
        facebookLoginManager.logIn(withPublishPermissions: [], from: self) {
            (result, error) in
            if let error = error {
                print(error.localizedDescription)
                self.stopLoading()
                return
            }
            
            if let result = result {
                if result.isCancelled {
                    print("Cancelled")
                    self.stopLoading()
                    return
                }
            }
            
            let credential = FacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
            
            Auth.auth().signIn(with: credential) { (user, error) in
                if let error = error {
                    print(error)
                    self.stopLoading()
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
                   self.stopLoading()
            }
        }
    }
    
    func startLoading() {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        overlay = UIView(frame: view.frame)
        overlay?.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        
        activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .white)
        activityIndicator?.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        activityIndicator?.center = CGPoint(x: (overlay?.bounds.width)!/2, y: (overlay?.bounds.height)!/2)
        
        overlay?.addSubview(activityIndicator!)
        activityIndicator?.startAnimating()
        
        view.addSubview(overlay!)
    }
    
    func stopLoading() {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        
        guard
            let overlay = overlay,
            let indicator = activityIndicator else {
                return
        }
        
        UIView.animate(withDuration: 0.2, animations: {
            overlay.alpha = 0
        }) { (_) in
            indicator.stopAnimating()
            indicator.removeFromSuperview()
            overlay.removeFromSuperview()
        }
    }

}
