//
//  UserSettingsViewController.swift
//  CocoaBaby
//
//  Created by Sohn on 15/08/2017.
//  Copyright © 2017 Sohn. All rights reserved.
//

import UIKit

class UserSettingsViewController: BaseViewController {
    
    private var selectedGender: String? = nil {
        didSet {
            guard let gender = selectedGender else {
                return
            }
            
            switch gender {
            case Gender.female:
                self.momImage.tintColor = UIColor.init(colorWithHexValue: 0xDF6C7E)
                self.dadImage.tintColor = UIColor.white
            case Gender.male:
                self.dadImage.tintColor = UIColor.init(colorWithHexValue: 0xDF6C7E)
                self.momImage.tintColor = UIColor.white
            default:
                break
            }
        }
    }
    
    @IBOutlet weak var nextBtn: UIButton!
    @IBOutlet weak var momImage: UIImageView!
    @IBOutlet weak var dadImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.nextBtn.layer.cornerRadius = 15
        self.nextBtn!.layer.borderColor = UIColor.white.withAlphaComponent(1.0).cgColor
        self.nextBtn.layer.borderWidth = 1.0
        
        let MomTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(momTapped(MomTapGestureRecognizer:)))
        momImage.isUserInteractionEnabled = true
        momImage.addGestureRecognizer(MomTapGestureRecognizer)
        
        let DadTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dadTapped(DadTapGestureRecognizer:)))
        dadImage.isUserInteractionEnabled = true
        dadImage.addGestureRecognizer(DadTapGestureRecognizer)
        
    }
    
    func momTapped(MomTapGestureRecognizer: UITapGestureRecognizer) {
        
        selectedGender = Gender.female
    }
    
    func dadTapped(DadTapGestureRecognizer: UITapGestureRecognizer) {
        
        selectedGender = Gender.male
    }
    
    @IBAction func tappedDone(_ sender: UIButton) {
        guard let gender = selectedGender else {
            
           let dialog = UIAlertController(title: "Select Mom or Dad", message: nil, preferredStyle: .alert)
        
            let action = UIAlertAction(title: LocalizableString.done, style: UIAlertActionStyle.default)
            dialog.addAction(action)
            
            self.present(dialog, animated: true, completion: nil)
            
            self.momImage.tintColor = UIColor.white
            self.dadImage.tintColor = UIColor.white
            
            return
        }
        
        var user = User()
        user.gender = gender
        
        startLoading()
        
        UserStore.shared.saveUser(user: user) { (result) in
            switch result {
            case .success(_):
                self.presentSplashViewController()
            case .failure(_):
                self.presentSplashViewController()
            }
            self.stopLoading()
        }
    }
    
    func presentSplashViewController() {
        let appDelegate = UIApplication.shared.delegate! as! AppDelegate
        
        let mainSB = UIStoryboard(name: StoryboardName.main, bundle: nil)
        let viewController = mainSB.instantiateViewController(withIdentifier: StoryboardName.splashViewController)
        
        appDelegate.window?.rootViewController = viewController
        appDelegate.window?.makeKeyAndVisible()
    }
}
