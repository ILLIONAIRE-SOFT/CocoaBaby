//
//  SplashViewController.swift
//  CocoaBaby
//
//  Created by Sohn on 14/08/2017.
//  Copyright © 2017 Sohn. All rights reserved.
//

import UIKit
import FirebaseAuth

class SplashViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    /// SplashViewController에서 유저 정보가 처음 로그인 한 경우 어떤 화면으로 넘어갈지 결정한다.
    /// 1. User 정보가 입력되어 있는지 검사해서 UserSettingViewController로 넘어간다.
    /// - Parameter animated: <#animated description#>
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if Auth.auth().currentUser != nil {
            UserStore.shared.fetchUser(completion: { (result) in
                switch result {
                case .success(_):
                    BabyStore.shared.fetchBaby(completion: { (baby) in
                        if baby != nil {
                            self.presentMainTabViewController()
                        } else {
                            self.presentTutorialViewController()
                        }
                    })
                case .failure(_): // UserSettingsViewController로 이동
                    self.presentUserSettingsViewController()
                }
            })
        } else {
            presentLoginViewController()
        }
    }
    
    private func presentMainTabViewController() {
        let appDelegate = UIApplication.shared.delegate! as! AppDelegate
        
        let initialViewController = self.storyboard!.instantiateViewController(withIdentifier: "mainTabBarViewController")
        appDelegate.window?.rootViewController = initialViewController
        appDelegate.window?.makeKeyAndVisible()
    }
    
    private func presentTutorialViewController() {
        let appDelegate = UIApplication.shared.delegate! as! AppDelegate
        
        let tutorialStoryboard = UIStoryboard(name: "Tutorial", bundle: nil)
        let viewController = tutorialStoryboard.instantiateViewController(withIdentifier: "tutorialNavigationViewController")
        
        appDelegate.window?.rootViewController = viewController
        appDelegate.window?.makeKeyAndVisible()
        
    }
    
    private func presentLoginViewController() {
        let appDelegate = UIApplication.shared.delegate! as! AppDelegate
        
        let initialViewController = self.storyboard!.instantiateViewController(withIdentifier: "LoginViewController")
        appDelegate.window?.rootViewController = initialViewController
        appDelegate.window?.makeKeyAndVisible()
    }
    
    private func presentUserSettingsViewController() {
        
    }
}
