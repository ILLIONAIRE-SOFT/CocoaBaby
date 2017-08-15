//
//  UserSettingsViewController.swift
//  CocoaBaby
//
//  Created by Sohn on 15/08/2017.
//  Copyright © 2017 Sohn. All rights reserved.
//

import UIKit

class UserSettingsViewController: BaseViewController {
    
    private var selectedGender: String? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func tappedMaleButton(_ sender: UIButton) {
        selectedGender = "male"
        
    }
    
    @IBAction func tappedFemaleButton(_ sender: UIButton) {
        selectedGender = "female"
        
    }
    
    @IBAction func tappedDone(_ sender: UIButton) {
        guard let gender = selectedGender else {
            return
        }
        
        startLoading()
        
        var user = User()
        user.gender = gender
        
        UserStore.shared.saveUser(user: user) { (result) in
            switch result {
            case .success(_):
                self.presentSplashViewController()
            case .failure(_):
                self.presentSplashViewController()
            }
            self.stopLoading()
        }
        
        //go to splash view
    }
    
    func presentSplashViewController() {
        let appDelegate = UIApplication.shared.delegate! as! AppDelegate
        
        let mainSB = UIStoryboard(name: "Main", bundle: nil)
        let viewController = mainSB.instantiateViewController(withIdentifier: "SplashViewController")
        
        appDelegate.window?.rootViewController = viewController
        appDelegate.window?.makeKeyAndVisible()
    }
}
