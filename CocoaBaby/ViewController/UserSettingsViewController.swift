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
    @IBOutlet var mamaButton: UIButton!
    @IBOutlet var papaButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mamaButton.layer.cornerRadius = 20
        papaButton.layer.cornerRadius = 20
        
        mamaButton.layer.borderColor = UIColor.white.cgColor
        papaButton.layer.borderColor = UIColor.white.cgColor
        
        mamaButton.layer.borderWidth = 0.3
        papaButton.layer.borderWidth = 0.3
        
        mamaButton.setTitleColor(.white, for: .normal)
        papaButton.setTitleColor(.white, for: .normal)
        
        mamaButton.tintColor = UIColor.white
        papaButton.tintColor = UIColor.white
        
        mamaButton.setTitleColor(UIColor.mainBlueColor, for: .selected)
        papaButton.setTitleColor(UIColor.mainBlueColor, for: .selected)
    }
    
    @IBAction func tappedFemaleButton(_ sender: UIButton) {
        selectedGender = "female"
        mamaButton.isSelected = true
        papaButton.isSelected = false
        
        mamaButton.backgroundColor = .white
        papaButton.backgroundColor = .clear
    }
    
    @IBAction func tappedMaleButton(_ sender: UIButton) {
        selectedGender = "male"
        mamaButton.isSelected = false
        papaButton.isSelected = true
        
        mamaButton.backgroundColor = .clear
        papaButton.backgroundColor = .white
    }
    
    
    
    @IBAction func tappedDone(_ sender: UIButton) {
        guard let gender = selectedGender else {
            return
        }
        
        startLoading()
        
        var user = User()
        user.gender = gender
        
        UserStore.shared.updateUser(post: [UserPayloadName.gender.rawValue:gender]) { (result) in
            switch result {
            case .success(_):
                self.presentSplashViewController()
            case .failure(_):
                self.presentSplashViewController()
            }
            self.stopLoading()
        }
        
        
        //        UserStore.shared.saveUser(user: user) { (result) in
        //            switch result {
        //            case .success(_):
        //                self.presentSplashViewController()
        //            case .failure(_):
        //                self.presentSplashViewController()
        //            }
        //            self.stopLoading()
        //        }
    }
    
    func presentSplashViewController() {
        let appDelegate = UIApplication.shared.delegate! as! AppDelegate
        
        let mainSB = UIStoryboard(name: "Main", bundle: nil)
        let viewController = mainSB.instantiateViewController(withIdentifier: "SplashViewController")
        
        appDelegate.window?.rootViewController = viewController
        appDelegate.window?.makeKeyAndVisible()
    }
}
