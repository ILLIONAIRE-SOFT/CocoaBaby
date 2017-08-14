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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if Auth.auth().currentUser != nil {
            BabyStore.shared.fetchBaby(completion: { (baby) in
                if baby != nil {
                    self.presentMainTabViewController()
                } else {
                    self.presentTutorialViewController()
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
